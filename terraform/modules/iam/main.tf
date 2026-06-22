# --- EKS Cluster Role ---
resource "aws_iam_role" "eks_cluster" {
  name = "${var.name_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, { Name = "${var.name_prefix}-eks-cluster-role" })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# --- EKS Node Role ---
resource "aws_iam_role" "eks_nodes" {
  name = "${var.name_prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, { Name = "${var.name_prefix}-eks-node-role" })
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ssm" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --- Jenkins Master Role ---
resource "aws_iam_role" "jenkins_master" {
  name = "${var.name_prefix}-jenkins-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, { Name = "${var.name_prefix}-jenkins-master-role" })
}

resource "aws_iam_instance_profile" "jenkins_master" {
  name = "${var.name_prefix}-jenkins-master-profile"
  role = aws_iam_role.jenkins_master.name
}

resource "aws_iam_policy" "jenkins_master_policy" {
  name        = "${var.name_prefix}-jenkins-master-policy"
  description = "Permissions for Jenkins master EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "eks:DescribeCluster",
        "ecr:*",
        "s3:GetObject","s3:PutObject","s3:DeleteObject","s3:ListBucket",
        "logs:*","cloudwatch:PutMetricData"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_master_attach" {
  role       = aws_iam_role.jenkins_master.name
  policy_arn = aws_iam_policy.jenkins_master_policy.arn
}

# --- Jenkins Worker Role ---
resource "aws_iam_role" "jenkins_worker" {
  name = "${var.name_prefix}-jenkins-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, { Name = "${var.name_prefix}-jenkins-worker-role" })
}

resource "aws_iam_instance_profile" "jenkins_worker" {
  name = "${var.name_prefix}-jenkins-worker-profile"
  role = aws_iam_role.jenkins_worker.name
}

resource "aws_iam_policy" "jenkins_worker_policy" {
  name        = "${var.name_prefix}-jenkins-worker-policy"
  description = "Permissions for Jenkins worker EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_worker_attach" {
  role       = aws_iam_role.jenkins_worker.name
  policy_arn = aws_iam_policy.jenkins_worker_policy.arn
}

# --- Terraform Execution Role ---
resource "aws_iam_role" "terraform_execution" {
  name = "${var.name_prefix}-terraform-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::<account-id>:user/terraform" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, { Name = "${var.name_prefix}-terraform-execution-role" })
}

resource "aws_iam_policy" "terraform_execution_policy" {
  name        = "${var.name_prefix}-terraform-execution-policy"
  description = "Permissions for Terraform to provision infra"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ec2:*","eks:*","rds:*","elasticache:*",
        "route53:*","kms:*","s3:*","dynamodb:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_execution_attach" {
  role       = aws_iam_role.terraform_execution.name
  policy_arn = aws_iam_policy.terraform_execution_policy.arn
}

# --- KMS Key ---
resource "aws_kms_key" "project_key" {
  description             = "KMS key for project resources"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-kms-key" })
}

resource "aws_kms_alias" "project_key_alias" {
  name          = "alias/${var.name_prefix}-kms"
  target_key_id = aws_kms_key.project_key.key_id
}

# --- ALB Ingress Controller IRSA ---
resource "aws_iam_role" "alb_ingress_irsa" {
  name = "${var.name_prefix}-alb-ingress-irsa"

  assume_role_policy = data.aws_iam_policy_document.alb_ingress_assume.json
}

data "aws_iam_policy_document" "alb_ingress_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:alb-ingress-controller"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "alb_ingress_policy" {
  role       = aws_iam_role.alb_ingress_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

# --- Cluster Autoscaler IRSA ---
resource "aws_iam_role" "cluster_autoscaler_irsa" {
  name = "${var.name_prefix}-cluster-autoscaler-irsa"

  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume.json
}

data "aws_iam_policy_document" "cluster_autoscaler_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy" {
  role       = aws_iam_role.cluster_autoscaler_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

# --- External Secrets Operator IRSA ---
resource "aws_iam_role" "external_secrets_irsa" {
  name = "${var.name_prefix}-external-secrets-irsa"

  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume.json
}

data "aws_iam_policy_document" "external_secrets_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  name        = "${var.name_prefix}-external-secrets-policy"
  description = "Permissions for External Secrets Operator"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "ssm:GetParameter",
        "ssm:GetParameters"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_attach" {
  role       = aws_iam_role.external_secrets_irsa.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

# --- Velero IRSA ---
resource "aws_iam_role" "velero_irsa" {
  name = "${var.name_prefix}-velero-irsa"

  assume_role_policy = data.aws_iam_policy_document.velero_assume.json
}

data "aws_iam_policy_document" "velero_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:velero:velero"]
    }
  }
}

resource "aws_iam_policy" "velero_policy" {
  name        = "${var.name_prefix}-velero-policy"
  description = "Permissions for Velero backups"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "s3:PutObject","s3:GetObject","s3:DeleteObject","s3:ListBucket",
        "ec2:DescribeVolumes","ec2:CreateSnapshot","ec2:DeleteSnapshot","ec2:DescribeSnapshots"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "velero_attach" {
  role       = aws_iam_role.velero_irsa.name
  policy_arn = aws_iam_policy.velero_policy.arn
}
