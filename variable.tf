variable "hcloud_token" {
  default = "FeA92YQ317VJEC4ou8JUV"
}
variable "my_ssh_key" {
  default = "ssh-rsa AAAAB3Nz4gijSqTfn6qN"

}
variable "access_key" {
  default = "AKIAZMQC"
  type    = string
}
variable "secret_key" {
  default = "u5+nW1"
  type    = string
}
variable "aws_region" {
  default = "us-east-2"
}
variable "domains" {
  type    = list
  default = ["hz1", "hz2"]
}
variable "password" {
  type    = string
  default = "Password123"
}
variable "host" {
  default = "hcloud_server.node1.ipv4_address"
}
