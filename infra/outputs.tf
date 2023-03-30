output "vpc_id" {
  value       = aws_vpc.airbnb-vpc.id
  description = "created vpc id"
  depends_on  = [aws_vpc.airbnb-vpc]
}

output "prefect_agent_cluster_name" {
  value       = module.prefect_ecs_agent.prefect_agent_cluster_name
  description = "prefect_agent_cluster_name"
  depends_on  = [module.prefect_ecs_agent]
}

output "prefect_agent_execution_role_arn" {
  value       = module.prefect_ecs_agent.prefect_agent_execution_role_arn
  description = "prefect_agent_execution_role_arn"
  depends_on  = [module.prefect_ecs_agent]
}

output "prefect_agent_security_group" {
  value       = module.prefect_ecs_agent.prefect_agent_security_group
  description = "prefect_agent_security_group"
  depends_on  = [module.prefect_ecs_agent]
}

output "prefect_agent_service_id" {
  value       = module.prefect_ecs_agent.prefect_agent_service_id
  description = "prefect_agent_service_id"
  depends_on  = [module.prefect_ecs_agent]
}

output "prefect_agent_task_role_arn" {
  value       = module.prefect_ecs_agent.prefect_agent_task_role_arn
  description = "prefect_agent_task_role_arn"
  depends_on  = [module.prefect_ecs_agent]
}

output "redshift_s3_role" {
  value       = aws_iam_role.airbnb-redshift-role.arn
  description = "redshift iam role to read datat from s3"
}
