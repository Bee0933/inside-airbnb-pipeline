# inside-airbnb-pipeline

<!-- ![architecture](static/capstone-zoomcamp.drawio_page-0001.jpg) -->

## Overview
The "Airbnb Pipeline" project is a data engineering project that provides a complete end-to-end solution for transforming and analyzing the Airbnb dataset (Sydney). The dataset contains detailed information about Airbnb listings, reviews, and host activity in sydney Australia.

The project provides a set of scripts and tools that automate the process of downloading, cleaning, and transforming the data into a format suitable for analysis. The pipeline uses a combination of Python, SQL, and dbt (data build tool) to extract, load, and transform the data into a set of analytics tables.

The resulting analytics tables provide valuable insights into the short-term rental market, including trends in pricing, availability, and host activity. The project is well-documented and actively maintained, making it a useful resource for anyone interested in analyzing the Inside Airbnb dataset.

 
### Data source:
Kaggle Airbnb sydney dataset (https://www.kaggle.com/datasets/samibrahim/airbnb-sydney)

## Technologies used
**Cloud**: Amazon Web service (AWS) 

**Infrastructure as code (IaC)**: Terraform 

**Workflow orchestration**: Prefect, Slack (Notification), ECS Fargate

**Data Wareshouse**: Redshift

**Data Lake**: AWS S3 Bucket

**Batch processing**: Python, Pandas

**Data Transformations**:  DBT, SQL

**Data Visualizations**:  Looker Studio

## Data Pipeline Diagram
![Alt text](static/capstone-zoomcamp.drawio_page-0001.jpg "Data Pipeline Diagram")


## Project Structure
      .
      ├── dbt_transform
      │   ├── analyses
      │   ├── dbt_packages
      │   ├── dbt_project.yml
      │   ├── logs
      │   │   ├── dbt.log
      │   │   └── dbt.log.legacy
      │   ├── macros
      │   ├── models
      │   │   ├── dim
      │   │   │   ├── dim_hosts_cleansed.sql
      │   │   │   ├── dim_listings_cleansed.sql
      │   │   │   └── dim_listings_hosts.sql
      │   │   ├── fact
      │   │   │   └── fact_reviews.sql
      │   │   ├── sources.yaml
      │   │   └── src
      │   │       ├── src_hosts.sql
      │   │       ├── src_listings.sql
      │   │       └── src_reviews.sql
      │   ├── README.md
      │   ├── seeds
      │   ├── snapshots
      │   ├── target
      │   │   ├── compiled
      │   │   │   └── dbt_transform
      │   │   │       └── models
      │   │   │           ├── dim
      │   │   │           │   ├── dim_hosts_cleansed.sql
      │   │   │           │   ├── dim_listings_cleansed.sql
      │   │   │           │   └── dim_listings_hosts.sql
      │   │   │           ├── fact
      │   │   │           │   └── fact_reviews.sql
      │   │   │           └── src
      │   │   │               ├── src_hosts.sql
      │   │   │               ├── src_listings.sql
      │   │   │               └── src_reviews.sql
      │   │   ├── graph.gpickle
      │   │   ├── manifest.json
      │   │   ├── partial_parse.msgpack
      │   │   ├── run
      │   │   │   └── dbt_transform
      │   │   │       └── models
      │   │   │           ├── dim
      │   │   │           │   ├── dim_hosts_cleansed.sql
      │   │   │           │   ├── dim_listings_cleansed.sql
      │   │   │           │   └── dim_listings_hosts.sql
      │   │   │           ├── fact
      │   │   │           │   └── fact_reviews.sql
      │   │   │           └── src
      │   │   │               ├── src_hosts.sql
      │   │   │               ├── src_listings.sql
      │   │   │               └── src_reviews.sql
      │   │   └── run_results.json
      │   └── tests
      ├── environ.sh
      ├── flows
      │   ├── dbt_flow.py
      │   ├── lake_to_warehouse.py
      │   ├── test.py
      │   └── websrc_to_datalake.py
      ├── infra
      │   ├── blocks
      │   │   └── prefect_blocks.py
      │   ├── iam.tf
      │   ├── main.tf
      │   ├── network.tf
      │   ├── outputs.tf
      │   ├── provider.tf
      │   ├── terraform.tfstate
      │   ├── terraform.tfstate.backup
      │   ├── terraform.tfvars
      │   └── variables.tf
      ├── logs
      │   └── dbt.log
      ├── Makefile
      ├── README.md
      ├── requirements.txt
      ├── static
      │   └── capstone-zoomcamp.drawio_page-0001.jpg
      └── test.ipynb