# inside-airbnb-pipeline

<!-- ![architecture](static/capstone-zoomcamp.drawio_page-0001.jpg) -->

## Overview
The "Airbnb Pipeline" project is a data engineering project that provides a complete end-to-end solution for transforming and analyzing the Airbnb dataset (Sydney). The dataset contains detailed information about Airbnb listings, reviews, and host activity in sydney Australia.

The project provides a set of scripts and tools that automate the process of downloading, cleaning, and transforming the data into a format suitable for analysis. The pipeline uses a combination of Python, SQL, and dbt (data build tool) to extract, load, and transform the data into a set of analytics tables.

The resulting analytics tables provide valuable insights into the short-term rental market, including trends in pricing, availability, and host activity. The project is well-documented and actively maintained, making it a useful resource for anyone interested in analyzing the Inside Airbnb dataset.

 
### Data source:
[Kaggle Airbnb sydney dataset](https://www.kaggle.com/datasets/samibrahim/airbnb-sydney)

## Technologies used

___

| Category         | Logo                                        | Names                          |
|--------------------|---------------------------------------------|-------------------------------|
| Cloud              | ![AWS logo](https://img.icons8.com/color/48/000000/amazon-web-services.png) | Amazon Web Service(AWS)     |
| Infrastructure as Code (IaC) | ![Terraform logo](https://img.icons8.com/color/48/000000/terraform.png) | Terraform     |
| Workflow Orchestration |  <img src="https://seeklogo.com/images/P/prefect-logo-D16B9C45A6-seeklogo.com.png" alt="Prefect logo" width="30" height="48">,    ![Slack logo](https://img.icons8.com/color/48/000000/slack.png), <img src="https://lumigo.io/wp-content/uploads/2020/07/AWS-Fargate@4x.png" alt="fargate logo" width="45" height="45">, ![Github logo](https://img.icons8.com/ios-filled/48/000000/github.png) | Prefect, Slack (Notification), ECS Fargate, Github (storage block) |
| Data Warehouse | <img src="https://www.dataliftoff.com/wp-content/uploads/2019/07/Amazon-Redshift@4x.png" alt="redshift logo" width="45" height="45"> | Redshift |
| Data Lake        | <img src="https://res.cloudinary.com/practicaldev/image/fetch/s--PnCOq3po--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://day-journal.com/memo/images/logo/aws/s3.png" alt="s3 logo" width="45" height="45"> | AWS S3 Bucket                 |
| Batch Processing | ![Python logo](https://img.icons8.com/color/48/000000/python.png), ![Pandas logo](https://img.icons8.com/color/48/000000/pandas.png) | Python, Pandas                |
| Data Transformations | <img src="https://seeklogo.com/images/D/dbt-logo-500AB0BAA7-seeklogo.com.png" alt="dbt logo" width="43" height="43">, ![SQL logo](https://img.icons8.com/ios-filled/48/000000/sql.png) | DBT, SQL                      |
| Data Visualizations | <img src="https://seeklogo.com/images/G/google-looker-logo-B27BD25E4E-seeklogo.com.png" alt="looker logo" width="35" height="45"> | Looker Studio                 |






## Data Pipeline Diagram
![Alt text](static/capstone-zoomcamp.drawio_page-0001.jpg "Data Pipeline Diagram")

**Prerequisites**:
- AWS account with access key to use aws cli
- Prefect cloud account 
- DBT cloud account
- Kaggle account
- slack webhook
- Terraform
- Make

## Project build & setup ⚙️ 

- [setup and build infra](./infra/infra_README.md)

- [setup environment variables](./env_README.md)

- setup & build all code and workflow ochestration deployment
  - `make all` <br> *run command from root directory*
    <br> 
    <br>
  - [or setup and build manually](Makefile)

**Data workflow ochestration**: 
- data extraction & transformation from websource to data lake runs every monday @ 10am UTC
- data extraction from lake to warehouse runs every monday @ 1pm UTC
- data transformation in warehouse runs every monday @ 3pm UTC
      
**Workflow ochestration notification sample**:

![Alt text](static/sample-slack-notif.png "Slcak Notification ETL src to data lake")

<br>

**Data Transformation**:

![Lineage graph](static/linage_graph.png "Lineage Graph from Data Transformation")

- `airbnb.listings` and `airbnb.reviews` are tables from the target schema of the warehouse where the extracted pipeline data was loaded based on the EL (Extract & Load) process
- `src_hosts`, `src_listings` and `src_reviews` are *ephemeral* materialized and transformed tables extracted with selected fields from the loaded data source
- `dim_hosts_cleansed` and `dim_listings_cleansed` are transformed and cleaned *views* from the ephemeral tables
- `dim_listings_hosts` is a dimension table from the join of  `dim_hosts_cleansed` and `dim_listings_cleansed` views

## Project Structure
      .
      ├── dbt_transform
      │   ├── analyses
      │   ├── dbt_packages
      │   ├── dbt_project.yml
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
      │   └── tests
      ├── environment.sh
      ├── env_README.md
      ├── flows
      │   ├── dbt_flow.py
      │   ├── lake_to_warehouse.py
      │   └── websrc_to_datalake.py
      ├── infra
      │   ├── blocks
      │   │   └── prefect_blocks.py
      │   ├── iam.tf
      │   ├── infra_README.md
      │   ├── main.tf
      │   ├── network.tf
      │   ├── outputs.tf
      │   ├── provider.tf
      │   ├── terraform.tfstate
      │   ├── terraform.tfstate.backup
      │   ├── terraform.tfvars
      │   └── variables.tf
      ├── Makefile
      ├── README.md
      ├── requirements.txt
      ├── static
      │   └── capstone-zoomcamp.drawio_page-0001.jpg
      └── test.ipynb


## Further Improvements
There is scope for improvement in several areas of this project, such as:

- Conducting tests
- Implementing CI/CD
 