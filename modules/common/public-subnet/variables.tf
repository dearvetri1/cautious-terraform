variable "vpc_id" {
  description = "ID of VPC in which this subnet will exist."
  default     = ""
}

variable "map_public_ip_on_launch" {
  description = "Boolean flag to indicate whether instances launched in this subnet should have a public IP mapped on launch."
  default     = false
}

variable "az" {
  description = "Availability zone to which the subnet will belong."
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}