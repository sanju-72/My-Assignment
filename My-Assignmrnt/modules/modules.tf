
module "my-vpc" {
    source = "../main/vpc"
    vpc_cidr = "10.0.0.0/16"
    v_vpc_id = module.my-vpc.v_vpc_id
    v_sn1 = module.my-vpc.v_sn1
    v_sn2 = module.my-vpc.v_sn2
    az = module.my-vpc.az
}

module "my-alb" {
    source = "../main/elb&asg"
    v_vpc_id = module.my-vpc.v_vpc_id
    v_sn1 = module.my-vpc.v_sn1
    v_sn2 = module.my-vpc.v_sn2
    interval = "10"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    instance_type = "t2.micro"
    desired = 2
    min = 1
    max = 5
    
}