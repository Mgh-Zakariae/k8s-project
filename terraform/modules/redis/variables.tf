variable "private_subnet_ids" {
  type = list(string)
}

variable "redis_sg_id" {
  type = string
}

variable "node_type" {
  default = "cache.t3.micro"
}