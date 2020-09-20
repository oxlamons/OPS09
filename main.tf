provider "hcloud" {
  token = var.hcloud_token
  #base_url = "https://api.hetzner.cloud/v1/"
}
data "hcloud_ssh_key" "rebrain_ssh_key" {
  name = "REBRAIN.SSH.PUB.KEY"
}
# Add ssh key
resource "hcloud_ssh_key" "my_ssh" {
  name       = "my_ssh"
  public_key = var.my_ssh_key
}
# Create a new provider using the SSH key
resource "hcloud_server" "web" {
  name        = "web"
  image       = "ubuntu-18-04-x64"
  server_type = "cx11"
  location    = "fsn1"
  ssh_keys = [hcloud_ssh_key.my_ssh.id,
  data.hcloud_ssh_key.rebrain_ssh_key.id]
}
