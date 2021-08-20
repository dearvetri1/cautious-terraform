provider "aws" {
  access_key = "AKIAVUFSMMTFHOUDHKES"
  secret_key = "v5YhRawiyUTcFJA2bokIwhUEBOO2wkuGx3MTjwwk"
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-0133407e358cc1af0"
  instance_type = "t2.micro"
}