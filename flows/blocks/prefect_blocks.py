from prefect_aws import ECSTask, AwsCredentials
from prefect_aws.s3 import S3Bucket
from prefect.filesystems import GitHub
from prefect.blocks.notifications import SlackWebhook


# AWS credentials block
aws_creds = AwsCredentials(
    region_name="af-south-1",
    aws_access_key_id="",
    aws_secret_access_key="" 
)
aws_creds.save("aws_creds", overwrite=True)


# AWS ECS block
airbnb_ecs_block = ECSTask(
    vpc_id="",
    cluster="",
    execution_role_arn="",
    task_role_arn="",
    task_customizations=[
        {
            "op": "add",
            "path": "/networkConfiguration/awsvpcConfiguration/securityGroups",
            "value": ["f{}"],
        },
    ],
    task_start_timeout_seconds=600

)
airbnb_ecs_block.save("airbnb_ecs_block", overwrite=True)


# S3 Bucket block
aws_s3_block = S3Bucket(
    bucket_name="airbnb-bucket",
    credentials=[]
)
aws_s3_block.save("aws_s3_block", overwrite=True)



# github storage block
github_block = GitHub(
    repository="<link>",
    access_token="" 
)
# github_block.get_directory("folder-in-repo") # specify a subfolder of repo
github_block.save("github_block")


# slack notificamtion webhook
slack_block = SlackWebhook(
    url=""   
)
slack_block.save("slack_block",overwrite=True)


