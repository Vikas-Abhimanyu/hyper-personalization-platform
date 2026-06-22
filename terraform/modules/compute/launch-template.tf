# --- Jenkins Worker Launch Template ---

resource "aws_launch_template" "jenkins_worker" {

  name_prefix = "${var.name_prefix}-jenkins-worker-"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = var.jenkins_worker_instance_type

  vpc_security_group_ids = [
  var.jenkins_worker_sg_id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.jenkins_worker.name
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/userdata/worker_userdata.sh.tpl",
      {
        jenkins_master_private_ip = aws_instance.jenkins_master.private_ip
      }
    )
  )

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size           = 50
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  tag_specifications {

    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.name_prefix}-jenkins-worker"
      }
    )
  }
}

