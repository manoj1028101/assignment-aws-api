[
  {
    "name": "api-app",
    "image": "${docker_image_url_api}",
    "cpu": 2,
    "memory": 2048,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 8000,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "MASTER_HOST",
        "value": "localhost"
      },
      {
        "name": "REDIS_HOST",
        "value": "localhost"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/api-app",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "api-app-log-stream"
      }
    }
  },
  {
    "name": "redis",
    "image": "271957787021.dkr.ecr.us-east-2.amazonaws.com/redis:latest",
    "cpu": 1,
    "memory": 2048,
    "networkMode": "awsvpc",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 6379,
        "hostPort": 6379,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/redis",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "redis-log-stream"
      }
    }
  },
  {
    "name": "mysql_db",
    "image": "271957787021.dkr.ecr.us-east-2.amazonaws.com/mysql:latest",
    "cpu": 2,
    "memory": 2048,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3306,
        "hostPort": 3306,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "MYSQL_DATABASE",
        "value": "combyne"
      },
      {
        "name": "MYSQL_ROOT_PASSWORD",
        "value": "superSecretPassword"
      },
      {
        "name": "MASTER_DB_NAME",
        "value": "combyne"
      },
      {
        "name": "MYSQL_USER",
        "value": "combyne"
      },
      {
        "name": "MYSQL_PASSWORD",
        "value": "superSecretPassword"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/mysql",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "mysql-log-stream"
      }
    }
  },
  {
    "name": "nginx",
    "image": "271957787021.dkr.ecr.us-east-2.amazonaws.com/nginx:latest",
    "cpu": 1,
    "memory": 2048,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8500,
        "hostPort": 8500,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nginx",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "nginx-log-stream"
      }
    }
  }
]