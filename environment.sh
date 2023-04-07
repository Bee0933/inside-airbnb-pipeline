set -e

export aws_access_key_id="your aws access key"
export aws_secret_access_key=" your secret key "
export iam_role="your aws s3 to redshift role"
export s3_bucket="your s3 bucket name"
export redshift_master_user="your redshift username"
export redshift_master_password="your redshift password"
export redshift_host="your redshift database host address"
export github_access_token="your github access token"
export github_repo_url="https://github.com/Bee0933/inside-airbnb-pipeline"
export slack_webhook="your slack webhook"
export PREFECT_API_KEY="your prefect cloud API key "
export KAGGLE_KEY="your Kaggle key"
export KAGGLE_USERNAME="your kaggle username"


echo "created envonment variables!!"