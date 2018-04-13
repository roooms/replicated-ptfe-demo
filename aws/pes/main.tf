#------------------------------------------------------------------------------
# production external-services ptfe resources
#------------------------------------------------------------------------------

locals {
  namespace = "${var.namespace}-pes"
}

resource "aws_instance" "pes" {
  count                  = 2
  ami                    = "${var.aws_instance_ami}"
  instance_type          = "${var.aws_instance_type}"
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${var.ssh_key_name}"
  user_data              = "${var.user_data}"
  iam_instance_profile   = "${aws_iam_instance_profile.ptfe.name}"

  root_block_device {
    volume_size = 80
    volume_type = "gp2"
  }

  tags {
    Name  = "${local.namespace}-instance-${count.index+1}"
    owner = "${var.owner}"
    TTL   = "${var.ttl}"
  }
}

resource "aws_lb" "pes" {
  name               = "${local.namespace}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.subnet_ids}"]

  tags {
    Name = "${local.namespace}-lb"
  }
}

resource "aws_lb_listener" "pes" {
  load_balancer_arn = "${aws_lb.pes.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.pes.1.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "pes" {
  count                = 2
  name                 = "${local.namespace}-tg-${count.index+1}"
  port                 = 80
  protocol             = "TCP"
  deregistration_delay = 15
  vpc_id               = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "pes" {
  count            = 2
  target_group_arn = "${element(aws_lb_target_group.pes.*.arn, count.index)}"
  target_id        = "${element(aws_instance.pes.*.id, count.index)}"
  port             = 80
}

resource "aws_route53_record" "pes" {
  zone_id = "${var.hashidemos_zone_id}"
  name    = "${local.namespace}.hashidemos.io."
  type    = "A"

  alias {
    name                   = "${aws_lb.pes.dns_name}"
    zone_id                = "${aws_lb.pes.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "pes" {
  bucket = "${local.namespace}-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name = "${local.namespace}-s3-bucket"
  }
}

resource "aws_db_instance" "pes" {
  allocated_storage         = 10
  engine                    = "postgres"
  engine_version            = "9.4"
  instance_class            = "db.t2.medium"
  identifier                = "${local.namespace}-db-instance"
  name                      = "ptfe"
  storage_type              = "gp2"
  username                  = "ptfe"
  password                  = "${var.database_pwd}"
  db_subnet_group_name      = "${var.db_subnet_group_name}"
  vpc_security_group_ids    = ["${var.vpc_security_group_ids}"]
  final_snapshot_identifier = "${local.namespace}-db-instance-final-snapshot"
}

#------------------------------------------------------------------------------
# iam for ec2 to s3
#------------------------------------------------------------------------------

resource "aws_iam_role" "ptfe" {
  name = "${local.namespace}-iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ptfe" {
  name = "${local.namespace}-iam_instance_profile"
  role = "${aws_iam_role.ptfe.name}"
}

data "aws_iam_policy_document" "ptfe" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.pes.id}",
      "arn:aws:s3:::${aws_s3_bucket.pes.id}/*",
    ]

    actions = [
      "s3:*",
    ]
  }
}

resource "aws_iam_role_policy" "ptfe" {
  name   = "${local.namespace}-iam_role_policy"
  role   = "${aws_iam_role.ptfe.name}"
  policy = "${data.aws_iam_policy_document.ptfe.json}"
}
