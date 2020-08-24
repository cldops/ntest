# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table

resource "aws_vpc" "ntest" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-ntest-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "ntest" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ntest.id

  tags = map(
    "Name", "terraform-eks-ntest-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "ntest" {
  vpc_id = aws_vpc.ntest.id

  tags = {
    Name = "terraform-eks-ntest"
  }
}

resource "aws_route_table" "ntest" {
  vpc_id = aws_vpc.ntest.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntest.id
  }
}

resource "aws_route_table_association" "ntest" {
  count = 2

  subnet_id      = aws_subnet.ntest.*.id[count.index]
  route_table_id = aws_route_table.ntest.id
}
