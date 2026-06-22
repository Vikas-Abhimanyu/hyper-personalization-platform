# --- Jenkins Master ---

resource "aws_instance" "jenkins_master" {

  ami                    = var.ami_id
  instance_type          = var.master_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_master_sg_id]

  iam_instance_profile = var.jenkins_master_instance_profile

  key_name = var.key_name

  user_data = templatefile(
    "${path.module}/userdata/master_userdata.sh.tpl",
    {
      region = var.aws_region
    }
  )

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-jenkins-master"
    }
  )
}

# --- Jenkins Worker ---

resource "aws_instance" "jenkins_worker" {

  ami                    = var.ami_id
  instance_type          = var.worker_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_worker_sg_id]

  iam_instance_profile = var.jenkins_worker_instance_profile

  key_name = var.key_name

  user_data = templatefile(
    "${path.module}/userdata/worker_userdata.sh.tpl",
    {
      region       = var.aws_region
      cluster_name = var.cluster_name
    }
  )

  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-jenkins-worker"
    }
  )
}