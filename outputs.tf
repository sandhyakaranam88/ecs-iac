output "s3_bucket_name" {
  value = aws_s3_bucket.uploads.id
}

output "sqs_queue_url" {
  value = aws_sqs_queue.msg_queue.id
}

output "ecr_service1_repo_url" {
  value = aws_ecr_repository.service1.repository_url
}

output "ecr_service2_repo_url" {
  value = aws_ecr_repository.service2.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
