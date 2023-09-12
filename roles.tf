data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2s3access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.data.arn,
    "${aws_s3_bucket.data.arn}/*"]
  }
}


resource "aws_iam_role" "instance" {
  name                = "ec2S3SSMRole"
  description         = "Allow an EC2 instance access to the s3 bucket"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMFullAccess"]

  inline_policy {
    name   = "ec2s3access"
    policy = data.aws_iam_policy_document.ec2s3access.json
  }
}

