terraform {
  backend "s3" {
    bucket = "terraform-tfstate-vetrisplayground"
    key    = "terraform/cautious-terraform/key"
    region = "us-east-1"
  }
}