# --- EKS Cluster Security Group ---

resource "aws_security_group" "eks_cluster" {
  name        = "${var.name_prefix}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-eks-cluster-sg"
    }
  )
}

# --- EKS Nodes Security Group ---

resource "aws_security_group" "eks_nodes" {
  name        = "${var.name_prefix}-eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-eks-nodes-sg"
    }
  )
}

# --- RDS Security Group ---

resource "aws_security_group" "database" {
  name        = "${var.name_prefix}-database-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-database-sg"
    }
  )
}

# --- Redis Security Group ---

resource "aws_security_group" "redis" {
  name        = "${var.name_prefix}-redis-sg"
  description = "Security group for ElastiCache"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-redis-sg"
    }
  )
}

# --- Jenkins Master Security Group ---

resource "aws_security_group" "jenkins_master" {
  name        = "${var.name_prefix}-jenkins-master-sg"
  description = "Security group for Jenkins master"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-jenkins-master-sg"
    }
  )
}

# --- Jenkins Worker Security Group ---

resource "aws_security_group" "jenkins_worker" {
  name        = "${var.name_prefix}-jenkins-worker-sg"
  description = "Security group for Jenkins worker"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-jenkins-worker-sg"
    }
  )
}

# =====================================================
# Ingress Rules
# =====================================================

# Jenkins UI
resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  security_group_id = aws_security_group.jenkins_master.id

  cidr_ipv4   = var.allowed_admin_cidr
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}

# SSH (restrict to your IP or VPN CIDR)
resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins_master.id

  cidr_ipv4   = var.allowed_admin_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# Worker -> Master JNLP
resource "aws_vpc_security_group_ingress_rule" "worker_to_master" {
  security_group_id            = aws_security_group.jenkins_master.id
  referenced_security_group_id = aws_security_group.jenkins_worker.id

  from_port   = 50000
  to_port     = 50000
  ip_protocol = "tcp"
}

# EKS Nodes -> RDS
resource "aws_vpc_security_group_ingress_rule" "eks_to_rds" {

  security_group_id = aws_security_group.database.id

  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port = 5432
  to_port   = 5432
  ip_protocol = "tcp"
}

# EKS Nodes -> Redis
resource "aws_vpc_security_group_ingress_rule" "eks_to_redis" {

  security_group_id = aws_security_group.redis.id

  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port = 6379
  to_port   = 6379
  ip_protocol = "tcp"
}

# Interal-communication
resource "aws_vpc_security_group_ingress_rule" "nodes_internal" {

  security_group_id = aws_security_group.eks_nodes.id

  referenced_security_group_id = aws_security_group.eks_nodes.id

  ip_protocol = "-1"
}

# Cluster -> Nodes
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes" {

  security_group_id = aws_security_group.eks_nodes.id

  referenced_security_group_id = aws_security_group.eks_cluster.id

  ip_protocol = "-1"
}

# Nodes -> Cluster
resource "aws_vpc_security_group_ingress_rule" "nodes_to_cluster" {

  security_group_id = aws_security_group.eks_cluster.id

  referenced_security_group_id = aws_security_group.eks_nodes.id

  ip_protocol = "-1"
}

# =====================================================
# Egress Rules
# =====================================================

resource "aws_vpc_security_group_egress_rule" "allow_all_eks_cluster" {
  security_group_id = aws_security_group.eks_cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_eks_nodes" {
  security_group_id = aws_security_group.eks_nodes.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_jenkins_master" {
  security_group_id = aws_security_group.jenkins_master.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_jenkins_worker" {
  security_group_id = aws_security_group.jenkins_worker.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_database" {
  security_group_id = aws_security_group.database.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_redis" {
  security_group_id = aws_security_group.redis.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}