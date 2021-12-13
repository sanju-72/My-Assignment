resource "aws_launch_configuration" "my-lc" {
  name = "my-lc"
  image_id = "ami-0567e0d2b4b2169ae"
  instance_type = "t2.micro"
  user_data = "${file("./userdata.sh")}"
  security_groups = [aws_security_group.alb-sg.id]
  key_name = "dec13.pem"
}

resource "aws_launch_configuration" "my-lc1" {
  name = "my-lc1"
  image_id = "ami-0567e0d2b4b2169ae"
  instance_type = var.instance_type
  user_data = "${file("./userdata1.sh")}"
  security_groups = [aws_security_group.alb-sg.id]
  key_name = "dec13.pem"
}

resource "aws_autoscaling_group" "my-asg1" {
  name = "my-asg"
  launch_configuration = aws_launch_configuration.my-lc.id
  vpc_zone_identifier = slice(var.v_sn2,0,length(var.v_sn2))
  target_group_arns = [aws_lb_target_group.tg1.*.arn[0]]
  desired_capacity = var.desired
  max_size = var.max
  min_size = var.min
}

resource "aws_autoscaling_group" "my-asg2" {
  name = "my-asg"
  launch_configuration = aws_launch_configuration.my-lc1.id
  vpc_zone_identifier = slice(var.v_sn1,0,length(var.v_sn2))
  target_group_arns = [aws_lb_target_group.tg1.*.arn[1]]
  desired_capacity = var.desired
  max_size = var.max
  min_size = var.min
}