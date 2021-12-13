resource "aws_instance" "Boston" {
  
  subnet_id = var.v_sn1[0]
  ami = "ami-0567e0d2b4b2169ae"
  instance_type = "t2.micro"
  user_data = "${file("./userdata.sh")}"
  key_name = "dec13.pem"
  associate_public_ip_address = true

  tags = {
      Name = "Boston"
  }
}

resource "aws_key_pair" "testkey" {
  key_name   = "dec13.pem"
  public_key = file("./dec13.pub")
}