resource "aws_ecs_cluster" "api" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_cloudwatch_log_group" "api-log-group" {
  name              = "/ecs/api-app"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "api-log-stream" {
  name           = "api-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.api-log-group.name
}

resource "aws_cloudwatch_log_group" "mysql-log-group" {
  name              = "/ecs/mysql"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "mysql-log-stream" {
  name           = "mysql-log-stream"
  log_group_name = aws_cloudwatch_log_group.mysql-log-group.name
}

resource "aws_cloudwatch_log_group" "redis-log-group" {
  name              = "/ecs/redis"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "redis-log-stream" {
  name           = "redis-log-stream"
  log_group_name = aws_cloudwatch_log_group.redis-log-group.name
}

resource "aws_cloudwatch_log_group" "nginx-log-group" {
  name              = "/ecs/nginx"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "nginx-log-stream" {
  name           = "nginx-log-stream"
  log_group_name = aws_cloudwatch_log_group.nginx-log-group.name
}

data "template_file" "app" {
  template = file("templates/api.json.tpl")

  vars = {
    docker_image_url_api = var.docker_image_url_api
    region                  = var.region
  }
}   

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "api-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = data.template_file.app.rendered
}

resource "aws_ecs_service" "api" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.api.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.task_sg.id]
    subnets         = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id]
  }

  depends_on      = [aws_alb_listener.ecs-alb-http-listener]

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "nginx"
    container_port   = 8500
  }
}

