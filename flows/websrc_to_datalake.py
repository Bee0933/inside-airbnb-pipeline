# pylint: disable=unused-import
# pylint: disable=unused-argument

import os
import ast
import glob
import numpy as np
import pandas as pd
from typing import List
from pathlib import Path
from datetime import timedelta
from prefect import flow, task, get_run_logger
from prefect.tasks import task_input_hash
from prefect_aws.s3 import S3Bucket
from kaggle.api.kaggle_api_extended import KaggleApi


def read_csv(data_path: Path) -> pd.DataFrame:
    # df_chunk = pd.read_csv(filepath_or_buffer=data_path, chunksize=30000,compression='zip', header=0, sep=',')

    # chunk_lst = list(df_chunk)
    # return pd.concat(chunk_lst)
    return pd.read_csv(
        filepath_or_buffer=data_path, compression="zip", header=0, sep=","
    ).head(1000)


@task(
    name="extract data from web src",
    retries=3,
    log_prints=True,
    cache_key_fn=task_input_hash,
    cache_expiration=timedelta(days=1),
)
def extract(files: List[str]) -> List[pd.DataFrame]:
    logger = get_run_logger()

    # api = KaggleApi()
    # api.authenticate()
    # print(api.dataset_list_files('samibrahim/airbnb-sydney').files)

    DATA_DIR = Path("../data/")
    # os.makedirs(name=DATA_DIR,exist_ok=True)

    # for file in files:
    #     os.makedirs(name=f"{DATA_DIR}/{file}",exist_ok=True)
    #     api.dataset_download_file('samibrahim/airbnb-sydney',file_name=f"{file}.csv",path=f"{DATA_DIR}/{file}", force=True)
    #     logger.info(f'downloaded {file}')

    logger.info("reading listings")
    df_listings = read_csv(
        data_path=f"{DATA_DIR}/listings_details/listings_details.csv.zip"
    )
    logger.info("reading reviews")
    df_reviews = read_csv(
        data_path=f"{DATA_DIR}/reviews_details/reviews_details.csv.zip"
    )
    logger.info("reading calendar")
    df_calenar = read_csv(data_path=f"{DATA_DIR}/calendar/calendar.csv.zip")

    return [df_listings, df_reviews, df_calenar]


@task(name="tansform data fields", retries=0, log_prints=True)
def transfom(df_list: List[pd.DataFrame]) -> Path:
    logger = get_run_logger()
    df_listings, df_reviews, df_calenar = df_list

    # listings
    df_listings.last_scraped = pd.to_datetime(df_listings.last_scraped)
    df_listings.description = df_listings.description.str.replace(
        r"<[^<>]*>", f"{os.linesep}", regex=True
    )
    df_listings.host_since = pd.to_datetime(df_listings.host_since)
    df_listings.host_about = df_listings.host_about.str.replace(
        r"\n", "", regex=True
    ).replace(r"\r", "", regex=True)
    df_listings.host_response_rate = df_listings.host_response_rate.replace(
        "%", "", regex=True
    ).astype("float16")
    df_listings.host_acceptance_rate = df_listings.host_acceptance_rate.replace(
        "%", "", regex=True
    ).astype("float16")
    df_listings["host_verifications_phone"] = np.where(
        "phone" in str(df_listings.host_verifications), "t", "f"
    ).astype("object")
    df_listings["host_verifications_email"] = np.where(
        "email" in str(df_listings.host_verifications), "t", "f"
    ).astype("object")
    df_listings = df_listings.drop(["host_verifications"], axis=1)
    df_listings.price = (
        df_listings.price.str.replace("$", "", regex=True)
        .replace(",", "", regex=True)
        .astype("float64")
    )

    # amenities
    amenit = list(df_listings.amenities.unique())
    temp_1 = ast.literal_eval(amenit[0])
    for i in amenit[1:]:
        temp = ast.literal_eval(i)
        result = list(set(temp) | set(temp_1))

    col_result = [
        val.replace(" ", "_").replace("-", "_").replace("–", "") for val in result
    ]
    for column_head, column in zip(col_result, result):
        df_listings[f"{column_head}"] = np.where(
            column in str(df_listings.amenities), "t", "f"
        ).astype("object")
    df_listings = df_listings.drop(["amenities"], axis=1)

    df_listings.minimum_minimum_nights = df_listings.minimum_minimum_nights.astype(
        "int64"
    )
    df_listings.maximum_minimum_nights = df_listings.maximum_minimum_nights.astype(
        "int64"
    )
    df_listings.minimum_maximum_nights = df_listings.minimum_maximum_nights.astype(
        "int64"
    )
    df_listings.maximum_maximum_nights = df_listings.maximum_maximum_nights.astype(
        "int64"
    )

    df_listings = df_listings.drop(["calendar_last_scraped"], axis=1)
    df_listings.first_review = pd.to_datetime(df_listings.first_review)
    df_listings.last_review = pd.to_datetime(df_listings.last_review)

    df_listings = df_listings.rename(
        columns={
            "host_response_rate": "host_response_rate_%",
            "host_acceptance_rate": "host_acceptance_rate_%",
        }
    )
    logger.info("processed listings")

    # reviews
    df_reviews.date = pd.to_datetime(df_reviews.date)
    logger.info("processed reviews")

    # calendar
    df_calenar.date = pd.to_datetime(df_calenar.date)
    df_calenar.price = df_calenar.price.str.replace("$", "", regex=True).astype(
        "float64"
    )
    df_calenar.adjusted_price = df_calenar.adjusted_price.str.replace(
        "$", "", regex=True
    ).astype("float64")
    logger.info("processed calendar")
    # save as parquet
    processed_dir = Path("../data/processed")
    os.makedirs(f"{processed_dir}", exist_ok=True)

    df_listings.to_parquet(
        f"{processed_dir}/listings.parquet", engine="fastparquet", compression="snappy"
    )
    df_reviews.to_parquet(
        f"{processed_dir}/reviews.parquet", engine="fastparquet", compression="snappy"
    )
    df_calenar.to_parquet(
        f"{processed_dir}/calendar.parquet", engine="fastparquet", compression="snappy"
    )

    return processed_dir


def delete_files_and_dir(dir_: Path, file_extension: str) -> List[Path]:
    files_in_dir = []
    for f in glob.glob(f"{dir_}/*.{file_extension}"):
        os.remove(f)
        files_in_dir.append(f)
    os.removedirs(dir_)
    return f" deleted files : {files_in_dir}"


@task(
    name="load to lake",
    retries=0,
    log_prints=True,
)
def load_lake(parquet_path: Path) -> None:
    logger = get_run_logger()

    s3_bucket_block = S3Bucket.load("aws-s3-block")
    logger.info("loaded s3block")

    parquet_files= Path(parquet_path).glob('*.parquet')

    for file in parquet_files:
        s3_bucket_block.upload_from_path(from_path=f"{file}", to_path=f"{file}".replace("../", ""))
        logger.info("loaded data to s3")

    logger.info("deleting data...")
    delete_files_and_dir(parquet_path, "parquet")

    logger.info("files deleted!!")
    return


@flow(
    name="ETL airbnb data to S3",
    retries=0,
    log_prints=True,
    description="perfom an ETL process to load airbnb data to data lake",
)
def main_flow(files: List[str]):
    #
    datasets = extract(files)
    print("output length : ", len(datasets))

    parquet_path = transfom(datasets)
    print(os.system(f"ls {parquet_path}"))

    _=load_lake(parquet_path)


if __name__ == "__main__":
    # params
    csv_filenames = ["listings_details", "reviews_details", "calendar"]

    # flow
    main_flow(csv_filenames)
