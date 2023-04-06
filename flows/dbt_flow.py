from prefect import flow
from prefect_dbt.cloud import DbtCloudCredentials
from prefect_dbt.cloud.jobs import trigger_dbt_cloud_job_run_and_wait_for_completion

# main flow
@flow
def run_dbt_cloud_job_flow():
      dbt_cloud_credentials = DbtCloudCredentials.load("dbt-cloud-cred")

      trigger_dbt_cloud_job_run_and_wait_for_completion(
            dbt_cloud_credentials=dbt_cloud_credentials,
            job_id=259333
      )


if __name__ == "__main__":
      run_dbt_cloud_job_flow()