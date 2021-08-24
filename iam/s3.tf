resource "aws_s3_bucket" "vetrisplayground-role-test-bucket" {
  bucket = "vetrisplayground-role-test-bucket"
  acl    = "private"


  tags = {
    Name = "vetrisplayground-role-test-bucket"
  }
}
