install:
	# install dependencies
	pip install --upgrade pip &&\
		pip --default-timeout=1000 install -r requirements.txt 
format:
	# format python code with black
	black infra/blocks/*.py flows/*.py
lint:
	# check code syntaxes
	pylint --disable=R,C infra/blocks/*.py flows/*.py

environment:
	# create environment variables
	chmod +x environ.sh &&\
		./environ.sh

make-blocks:
	# create prefect blocks
	python3 infra/blocks/prefect_blocks.py


# more CI
# - create prefect deployment
# - create dbt models 

# websource to data lake flow deployment - cron [every monday @ 10am UTC]
src-lake-depl:
	# prefect deployment -- src to lake deployment
	prefect deployment build flows/websrc_to_datalake.py:main_flow \
		-ib ecs-task/ecs-task -sb github/github-block -n "airbnb_src_lake_deployment" \
		--cron "0 10 * * 1" --output airbnb_src_lake_out.yaml --skip-upload --apply

# data lake to warehouse flow deployment - cron [every monday @ 1pm UTC]
lake-wh-depl:
	# prefect deployment -- lake to wh deployment
	prefect deployment build flows/lake_to_warehouse.py:main_flow \
		-ib ecs-task/ecs-task -sb github/github-block -n "airbnb_lake_wh_deployment" \
		--cron "0 13 * * 1" --output airbnb_lake_wh_out.yaml --skip-upload --apply

# trigger dbt job from prefect deployment - cron [every monday @ 2pm UTC]
trig-dbt-jobs:
	# prefect deployment -- trigger dbt jobs
	prefect deployment build flows/dbt_flow.py:run_dbt_cloud_job_flow \
		-ib ecs-task/ecs-task -sb github/github-block -n "dbt_transform_deployment" \
		--cron "0 15 * * 1" --output airbnb_dbt_out.yaml --skip-upload --apply


# CI process
all: install format lint environment  make-blocks