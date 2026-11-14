variable "instance_type" {
  default = "t3.micro"
}

variable "webapp_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = string
}

variable "secret_key" {
  default = "hhhhhhhhhhhhhhhhhhhhh-easy"
}

variable "redis_host" {
  type = string
}

variable "image_tag" {
  type = string
}