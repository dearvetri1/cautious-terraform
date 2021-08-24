
resource "aws_subnet" "this" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.cidr}"
  tags                    = "${var.tags}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"
}