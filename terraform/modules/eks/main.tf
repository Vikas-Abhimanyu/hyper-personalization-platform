# --- EKS Cluster ---

resource "aws_eks_cluster" "this" {

  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {

    subnet_ids = var.private_subnet_ids

    security_group_ids = [
      var.cluster_sg_id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  encryption_config {

    provider {
      key_arn = var.kms_key_arn
    }

    resources = ["secrets"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-eks"
    }
  )
}

# --- Node Group ---

resource "aws_eks_node_group" "this" {

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name_prefix}-node-group"
  node_role_arn   = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_node_count
    min_size     = var.min_node_count
    max_size     = var.max_node_count
  }

  instance_types = [
    var.node_instance_type
  ]

  capacity_type = var.capacity_type

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = null
    source_security_group_ids = []
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-node-group"
    }
  )

  depends_on = [
    aws_eks_cluster.this
  ]
}