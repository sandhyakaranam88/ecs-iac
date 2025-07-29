resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow HTTP for ECS services"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "service1" {
  family                   = "${var.project_name}-service1"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.service1_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "service1"
      image     = "${aws_ecr_repository.service1.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "UPLOADS_BUCKET"
          value = aws_s3_bucket.uploads.bucket
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service1" {
  name            = "${var.project_name}-service1"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service1.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

resource "aws_ecs_task_definition" "service2" {
  family                   = "${var.project_name}-service2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.service2_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "service2"
      image     = "${aws_ecr_repository.service2.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "QUEUE_URL"
          value = aws_sqs_queue.msg_queue.id
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service2" {
  name            = "${var.project_name}-service2"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service2.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_sg.id]
  }
}
