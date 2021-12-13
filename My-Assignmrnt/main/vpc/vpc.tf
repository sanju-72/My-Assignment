data "aws_availability_zones" "az1" {
  
}
resource "aws_vpc" "vpc1" {
    cidr_block = var.vpc_cidr
}

resource "aws_subnet" "pub-sub" {
  count = length(var.az)
  vpc_id = aws_vpc.vpc1.id
  availability_zone = var.az[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)
  map_public_ip_on_launch=true

  tags = {
      Name = "sub-${count.index}"
  }
}

resource "aws_subnet" "prv-sub" {
  count = length(var.az)
  vpc_id = aws_vpc.vpc1.id
  availability_zone = var.az[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr,8,(count.index+length(var.az)))

  tags = {
      Name = "prv-sub-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id
}

resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "my-nat" {
  subnet_id = aws_subnet.pub-sub.*.id[0]
  allocation_id = aws_eip.eip.id
}

resource "aws_route_table" "rt1-pub" {
  vpc_id = aws_vpc.vpc1.id

  route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "rt2-prv" {
  vpc_id = aws_vpc.vpc1.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.my-nat.id
  }
}



resource "aws_route_table_association" "rt-asso" {
    count = length(var.az)
    route_table_id = aws_route_table.rt1-pub.id
    subnet_id = aws_subnet.pub-sub.*.id[count.index]
}

resource "aws_route_table_association" "rt1-asso" {
    count = length(var.az)
    route_table_id = aws_route_table.rt2-prv.id
    subnet_id = aws_subnet.prv-sub.*.id[count.index]
}

output "v_vpc_id"{
   value=aws_vpc.vpc1.id
}
output "v_sn1"{
   value=aws_subnet.pub-sub.*.id
}
output "v_sn2" {
   value = aws_subnet.prv-sub.*.id
}
output "az" {

  value = data.aws_availability_zones.az1.names
  
}