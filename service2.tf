resource "aws_iam_role" "service2_task_role" {
  name               = "${var.project_name}-service2-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_policy" "service2_sqs_access" {
  name = "${var.project_name}-service2-sqs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["sqs:SendMessage"],
        Resource = aws_sqs_queue.msg_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "service2_attach" {
  role       = aws_iam_role.service2_task_role.name
  policy_arn = aws_iam_policy.service2_sqs_access.arn
}
