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
# Create a new provider using the SSH key
resource "hcloud_server" "node1" {
  name        = "node1"
  image       = "ubuntu-18.04"
  server_type = "cx11"
  ssh_keys = [hcloud_ssh_key.anton.id,
  data.hcloud_ssh_key.rebrain_ssh_key.name]
  labels = {
    "module" : "devops"
    "email" : "oxlamons_at_gmail_com"
  }
}
output "server_ip_node1" {
  value = "hcloud_server.node1.ipv4_address"
}
