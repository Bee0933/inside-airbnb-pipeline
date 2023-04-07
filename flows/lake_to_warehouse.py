from pathlib import Path
from typing import List
from datetime import timedelta
from prefect import flow, task, get_run_logger
from prefect_aws import AwsCredentials
from prefect_aws.s3 import S3Bucket
from prefect.blocks.system import Secret
from prefect.blocks.notifications import SlackWebhook
from prefect_aws.s3 import S3Bucket
from prefect.blocks.system import Secret
import boto3
import psycopg2
import os
import pandas as pd


# ETL from data Lake to Warehouse
@task(
    name="Extract Airbnb data from data lake (S3)",
    log_prints=True,
    retries=0
)
def extract_from_s3(s3_bucket:str, s3_key:str) -> pd.DataFrame:
    logger = get_run_logger()

    aws_credentials = AwsCredentials.load("aws-creds")
    aws_access_key_id = aws_credentials.aws_access_key_id
    aws_secret_access_key = aws_credentials.aws_secret_access_key.get_secret_value()

    s3 = boto3.client(
    "s3",
    region_name="af-south-1",
    aws_access_key_id=str(aws_access_key_id),
    aws_secret_access_key=str(aws_secret_access_key),
    )
    logger.info('connect to s3')

    obj = s3.get_object(Bucket=s3_bucket, Key=s3_key) 
    logger.info('reading csv file')
    return pd.read_csv(obj['Body']).head()
    



@task(name="load data to warehouse", log_prints=True, retries=0)
def write_rshift(df:pd.DataFrame, table_name:str, s3_file_location:str, iam_role:str) -> None:
    redshift_master_user = Secret.load("redshiift-master-user").get()
    redshift_master_password = Secret.load("redshift-master-password").get()

    columns = list(df.columns)

    conn = psycopg2.connect(
    host=Secret.load("redshift-host").get(),
    port=5439,
    user=redshift_master_user,
    password=redshift_master_password,
    dbname="airbnb_dev",
    )


    create_table_command = pd.io.sql.get_schema(df.reset_index(), table_name)
    create_table_command = create_table_command.replace(
        "CREATE TABLE", "CREATE TABLE IF NOT EXISTS"
    )
    create_table_command = create_table_command.replace('INTEGER', 'BIGINT')
    print(create_table_command)



    copy_command= f"COPY {table_name} ({','.join(columns)}) FROM '{s3_file_location}' IAM_ROLE '{iam_role}' IGNOREHEADER 1 DELIMITER ',' CSV"
    print(copy_command)

    # execute the COPY command using psycopg2
    with conn.cursor() as cur:
        cur.execute(create_table_command)
        conn.commit()

        cur.execute(copy_command)
        conn.commit()



@flow(
    name="EL airbnb data S3 to redshift",
    retries=0,
    log_prints=True,
    description="perfom an EL process to load airbnb data from data lake to warehouse",
)
def main_flow(files: List[str]):
    s3_bucket_block = S3Bucket.load("aws-s3-block")
    redshift_s3_iam_role = Secret.load("redshift-s3-iam-role").get()
    logger = get_run_logger()
    slack_webhook_block = SlackWebhook.load("slack-block")
    slack_webhook_block.notify("[Airbnb EL lake to warehouse started 🚀")

    for file in files:
        logger.info(f'EL process for {file} started!!')
        table_name = f"{file}_raw"
        s3_bucket = str(s3_bucket_block.bucket_name) 
        s3_key = f"data/processed/{file}.csv"
        iam_role = redshift_s3_iam_role
        s3_file_location = f"s3://{s3_bucket}/{s3_key}"

        df = extract_from_s3(s3_bucket,s3_key)
        slack_webhook_block.notify(f"[Airbnb EL lake to WH] extract {file} data complete! 🔽")

        write_rshift(df,table_name,s3_file_location,iam_role)
        slack_webhook_block.notify(f"[Airbnb EL lake to WH] load {file} data complete! 👍")
    
    slack_webhook_block.notify("[Airbnb EL lake to warehouse completed!! 💯")


if __name__ == "__main__":
    files = ["calendar", "listings", "reviews"]
    # files = ["listings"]

    main_flow(files)
