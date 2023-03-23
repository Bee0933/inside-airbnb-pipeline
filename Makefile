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
build-infra:
	# build terraform infra
	terraform -chdir=./infra/ apply --auto-approve 

destroy-infra:
	# destroy terraform infra
	terraform -chdir=./infra/ apply --auto-approve &&\
		aws secretsmanager delete-secret --secret-id prefect-api-key-development-airbnb-etl --force-delete-without-recovery

make-blocks:
	# create prefect blocks
	python3 infra/blocks/prefect_blocks.py


# more CI
# - create prefect deployment
# - create dbt models 

# CI process
all: install format lint environment build-infra make-blocks