# Subnet
output "subnet_id" {
  description = "The ID of this subnet"
  value = "${aws_subnet.this.id}"
}

output "cidr_block" {
  description = "CIDR block of this subnet"
  value       = "${aws_subnet.this.cidr_block}"
}
