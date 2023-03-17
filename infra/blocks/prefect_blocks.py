from prefect_aws import ECSTask, AwsCredentials
from prefect_aws.s3 import S3Bucket
from prefect.filesystems import GitHub
from prefect.blocks.notifications import SlackWebhook
from decouple import config
import json

path = "../terraform.tfstate"
with open(path) as f:
    state = json.load(f)

outputs = state["outputs"]
vpc_id = outputs["vpc_id"]["value"]
cluster_name = outputs["prefect_agent_cluster_name"]["value"]
execution_role_arn = outputs["prefect_agent_execution_role_arn"]["value"]
security_group = outputs["prefect_agent_security_group"]["value"]
service_id = outputs["prefect_agent_service_id"]["value"]
task_role_arn = outputs["prefect_agent_task_role_arn"]["value"]


# AWS credentials block
aws_creds = AwsCredentials(
    region_name="af-south-1",
    aws_access_key_id=str(config("aws_access_key_id")),
    aws_secret_access_key=str(config("aws_secret_access_key")),
)
aws_creds.save("aws_creds", overwrite=True)


# AWS ECS block
airbnb_ecs_block = ECSTask(
    vpc_id=vpc_id,
    cluster=cluster_name,
    execution_role_arn=execution_role_arn,
    task_role_arn=task_role_arn,
    task_customizations=[
        {
            "op": "add",
            "path": "/networkConfiguration/awsvpcConfiguration/securityGroups",
            "value": [f"{security_group}"],
        },
    ],
    task_start_timeout_seconds=600,
)
airbnb_ecs_block.save("airbnb_ecs_block", overwrite=True)


# S3 Bucket block
aws_s3_block = S3Bucket(bucket_name="airbnb-bucket", credentials=[aws_creds])
aws_s3_block.save("aws_s3_block", overwrite=True)


# github storage block
github_block = GitHub(
    repository=config("github_repo_url"), access_token=config("github_access_token")
)
# github_block.get_directory("folder-in-repo") # specify a subfolder of repo
github_block.save("github_block", overwrite=True)


# slack notificamtion webhook
slack_block = SlackWebhook(url=config("slack_webhook"))
slack_block.save("slack_block", overwrite=True)
