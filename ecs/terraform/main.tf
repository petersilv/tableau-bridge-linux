data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name = "${var.application_name}-task-execution"
  tags = local.common_tags

  assume_role_policy  = data.aws_iam_policy_document.assume.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

data "aws_iam_policy_document" "task" {
  statement {
    actions   = [
      "secretsmanager:*",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "task" {
  name   = "${var.application_name}-task"
  tags   = local.common_tags
  policy = data.aws_iam_policy_document.task.json
}

resource "aws_iam_role" "task" {
  name = "${var.application_name}-task"
  tags = local.common_tags

  assume_role_policy  = data.aws_iam_policy_document.assume.json
  managed_policy_arns = [
    aws_iam_policy.task.arn
  ]
}

resource "aws_security_group" "main" {
  name   = "${var.application_name}-ecs"
  vpc_id = var.vpc_id
  tags   = local.common_tags
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_secretsmanager_secret" "variables" {
  name = "${var.application_name}-ecs-variables"
  tags = local.common_tags

  recovery_window_in_days = 0
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
  task_role_arn            = aws_iam_role.task.arn
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
      command = [
        "/bin/sh",
        "-c",
        join( " && ", [
          "python3 /get-variables.py --secret ${aws_secretsmanager_secret.variables.id}",
          "source /variables",
          join( " ", [
            "/opt/tableau/tableau_bridge/bin/TabBridgeClientWorker",
            "-e",
            "--site=$site",
            "--client=$client",
            "--userEmail=$user_email",
            "--patTokenId=$token_id",
            "--patTokenFile=/token"
          ]),
        ])
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name                   = var.application_name
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.main.arn
  launch_type            = "FARGATE"
  enable_execute_command = true
  desired_count          = 1

  network_configuration {
    subnets = [var.subnet_id]
    security_groups = [aws_security_group.main.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.main
  ]
}
