resource "aws_iam_role" "task_execution" {
  name = "${var.application_name}-task-execution"
  tags = local.common_tags

  assume_role_policy  = data.aws_iam_policy_document.task_execution_assume.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

data "aws_iam_policy_document" "task_execution_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.application_name}-ecs"
  tags = local.common_tags
}

resource "aws_ecs_cluster" "main" {
  name = var.application_name
  tags = local.common_tags
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecr_repository" "main" {
  name                 = var.application_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.application_name
  tags                     = local.common_tags
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = aws_iam_role.task_execution.arn
  container_definitions    = jsonencode([
    {
      name = var.application_name
      image =  "${aws_ecr_repository.main.repository_url}:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group: aws_cloudwatch_log_group.main.name
          awslogs-region: var.aws_region
          awslogs-stream-prefix: var.application_name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.application_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [var.subnet_id]
  }

  desired_count = 1

  depends_on = [
    aws_ecs_task_definition.main
  ]
}
