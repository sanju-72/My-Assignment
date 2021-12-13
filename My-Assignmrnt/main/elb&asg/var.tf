variable "interval" {
  default = 10
}

variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "healthy_threshold" {
  default = 3
}

variable "unhealthy_threshold" {
  default = 3
}


variable "v_sn1" {

}

variable "v_sn2" {

}

variable "v_vpc_id" {
}

variable "instance_type" {
  default = []
}

variable "desired" {
    default = []
  
}

variable "min" {
  default = []
}
variable "max" {
  default = []
}
