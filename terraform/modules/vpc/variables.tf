variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "eu-north-1a",
    "eu-north-1b"
  ]
}

variable "public_subnet" {
  type    = string
  default = "10.0.10.0/24"
}

variable "private_subnet" {
  type = list(string)
  default = [
    "10.0.80.0/24",
    "10.0.90.0/24"
  ]
}

