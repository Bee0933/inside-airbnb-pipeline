# Terrafrom infrastructure inputs (tfvars required values)

These values are required by terrafrom to build the pipeline infrastructure

| Variable                          | Value                                | Description                            |
|-----------------------------------|--------------------------------------|----------------------------------------|
| env-prefix                        | development                          | Prefix to identify environment         |
| avail-zone                        | af-south-1                           | AWS availability zone                  |
| aws-cred-profile                  | default                              | AWS credentials profile name            |
| vpc-cidr-block                    | 0.0.0.0/16                         | CIDR block for VPC network              |
| airbnb-public-subnet-cidr-block-1 | 0.0.0.0/24                        | CIDR block for first public subnet      |
| airbnb-public-subnet-cidr-block-2 | 0.0.0.0/24                        | CIDR block for second public subnet     |
| airbnb-public-subnet-cidr-block-3 | 0.0.0.0/24                        | CIDR block for third public subnet      |
| rs-database-name                  | [your db name]                           | Name of the database                    |
| rs-master-username                | [your username]                             | Username of the database master user    |
| rs-master-pass                    | [your password]                         | Password of the database master user    |
| prefect-account-id                | [your prefect account id] | ID of the Prefect Cloud account         |
| prefect-api-key                   | [your prefect cloud api key] | API key for accessing Prefect Cloud   |
| prefect-workspace-id              | [Your prefect cloud workspace id] | ID of the Prefect Cloud workspace       |

---
*run the commands from the `infra/` directory*

**Build terrafrom infastructure**: `terraform apply --auto-approve`  

**Destroy terrafrom infastructure (if necessary ⚠️)**: `terraform destroy --auto-approve && aws secretsmanager delete-secret --secret-id <secret id> --force-delete-without-recover` 

