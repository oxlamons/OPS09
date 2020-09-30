provider "hcloud" {
  token = var.hcloud_token
  #base_url = "https://api.hetzner.cloud/v1/"
}
data "hcloud_ssh_key" "rebrain_ssh_key" {
  name = "REBRAIN.SSH.PUB.KEY"
}
# Add ssh key
resource "hcloud_ssh_key" "anton" {
  name       = "anton ssh_key"
  public_key = var.my_ssh_key
  labels = {
    "module" : "devops"
    "email" : "oxlamons_at_gmail_com"
  }
}

resource "hcloud_server" "node1" {
  name        = "${element(var.domains, count.index)}.oxlamons.devops.rebrain.srwx.net"
  count       = 1
  image       = "ubuntu-18.04"
  server_type = "cx11"
  ssh_keys = [hcloud_ssh_key.anton.id,
  data.hcloud_ssh_key.rebrain_ssh_key.name]

  provisioner "remote-exec" {
    inline = [
    "/bin/echo -e \"${var.password}\n${var.password}\" | /usr/bin/passwd root"]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
  }
  labels = {
    "module" : "devops"
    "email" : "oxlamons_at_gmail_com"
  }
}

# Create a new provider using the SSH key
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}
data "aws_route53_zone" "selected" {
  name = "devops.rebrain.srwx.net"
}
resource "aws_route53_record" "www" {
  count   = 1
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "oxlamons.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${element(hcloud_server.node1.*.ipv4_address, count.index)}"]
}

output "server_ip_node1" {
  value = hcloud_server.node1.*.ipv4_address
}

output "server_id_node1" {
  value       = hcloud_server.node1.*.id
  description = "ID"
}
