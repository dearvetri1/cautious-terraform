output "this_vpc_id" {
  description = "The ID of this vpc"
  value = "${aws_vpc.this.id}"
}

output "this_vpc_cidr_block" {
  description = "CIDR block of this subnet"
  value       = "${aws_vpc.this.cidr_block}"
}