resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.name_prefix}-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}