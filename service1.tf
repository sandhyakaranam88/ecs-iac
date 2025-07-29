resource "aws_iam_role" "service1_task_role" {
  name               = "${var.project_name}-service1-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_policy" "service1_s3_access" {
  name = "${var.project_name}-service1-s3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.uploads.arn,
          "${aws_s3_bucket.uploads.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "service1_attach" {
  role       = aws_iam_role.service1_task_role.name
  policy_arn = aws_iam_policy.service1_s3_access.arn
}
