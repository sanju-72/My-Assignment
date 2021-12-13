resource "aws_lb_target_group" "tg1" {
    count = 2
  name = "target-${count.index}"
  port = var.port
  protocol = var.protocol
  vpc_id = var.v_vpc_id

  health_check {
      interval = var.interval
      port = var.port
      protocol = var.protocol
      healthy_threshold = var.healthy_threshold
      unhealthy_threshold = var.unhealthy_threshold
  }
}


resource "aws_security_group" "alb-sg" {
  vpc_id = var.v_vpc_id
  name =  "alb-sg"
  ingress  {
      from_port = "80"
      to_port = "80"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress  {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_lb" "my-alb" {
  name = "my-alb"
  subnets = slice(var.v_sn1,0,length(var.v_sn1))

}

resource "aws_lb_listener" "my-alb-listener" {
  port = var.port
  protocol = var.protocol
  load_balancer_arn = aws_lb.my-alb.arn
  default_action {
    type = "forward"
    target_group_arn =  aws_lb_target_group.tg1.*.arn[0]
  }
}

resource "aws_lb_listener_rule" "rule1" {
    listener_arn = aws_lb_listener.my-alb-listener.arn

    action {
        type = "forward"
        target_group_arn =  aws_lb_target_group.tg1.*.arn[1]
    }
        condition{
                path_pattern {
                         values = ["*/sanju/*"]
                  }
        }
    
  
}