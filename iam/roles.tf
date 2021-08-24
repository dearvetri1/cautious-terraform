resource "aws_iam_role" "s3-mybucket-role" {
  name = "s3-mybucket-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "s3-mybucket-role"
  }
}

resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
  name = "s3-mybucket-role-instanceprofile"
  role = aws_iam_role.s3-mybucket-role.name
}