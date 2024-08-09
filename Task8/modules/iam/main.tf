# ----------------------- Role for ECS Node

//Policy Description
data "aws_iam_policy_document" "ecs_node_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Making Role of Defined Policy
resource "aws_iam_role" "ecs_node_role" {
  name               = "${var.name_prefix}-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

// Attach another policy to the above Role
resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

//Roles are designed to be “assumed” by other principals
//which do define “who am I?”, such as users, Amazon services,
//and EC2 instances. An instance profile, on the other hand,
//defines “who am I?” Just like an IAM user represents a person,
//an instance profile represents EC2 instances.
resource "aws_iam_instance_profile" "ecs_node" {
  name = "${var.name_prefix}-ecs-node-profile"
  path = "/ecs/instance/"
  role = aws_iam_role.ecs_node_role.name
}


# ----------------------- Role for ECS Task
data "aws_iam_policy_document" "ecs_task_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "${var.name_prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role" "ecs_exec_role" {
  name        = "${var.name_prefix}-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}