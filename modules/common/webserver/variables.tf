variable "ami_id" {
  description = "AMI Id of the ec2 instance that is launched."
  default     = ""
}

variable "webserver_name" {
  description = "The name of the ec2 instance that is launched."
  default     = "Webserver"
}

variable "subnet_id" {
  description = "The subnet in which this webserver is launched"
  default     = ""
}