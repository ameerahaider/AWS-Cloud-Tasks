resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name 
  node_role_arn   = var.node_instance_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.instance_type]

  # Scaling configuration for the node group
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  # Additional configuration for remote access (optional)
  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [var.node_instance_sg]
  }

  tags = {
    Name = "${var.name_prefix}-eks-node-group"
  }
}