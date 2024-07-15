# Your SSH Key, needed for the file transfer and also access if you need to SSH to the server.
resource "hcloud_ssh_key" "my-ssh-key" {
  name       = "My-SSH-Key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Your Server Resource
resource "hcloud_server" "appwrite-server" {
  depends_on  = [hcloud_ssh_key.my-ssh-key]
  name        = "appwrite-server"
  image       = "docker-ce"
  server_type = "cpx31"
  ssh_keys    = [hcloud_ssh_key.my-ssh-key.id]
  datacenter  = "ash-dc1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  # Initalizing Local->Server Connection to Provision and Execute Commands
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = self.ipv4_address
  }
  # Installs Docker Compose, creates an appwrite user, makes the directory for appwrite config, and chowns perms there
  provisioner "remote-exec" {
    inline = [
      "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      "useradd -m -s /bin/bash appwrite",
      "usermod -aG docker appwrite",
      "mkdir -p /home/appwrite/appwrite-config",
      "chown appwrite:appwrite /home/appwrite/appwrite-config"
    ]
  }

  # Transfer the local appwrite directory
  provisioner "file" {
    source      = "./appwrite-config"
    destination = "/home/appwrite/"
  }

  # Set correct permissions and run docker-compose
  provisioner "remote-exec" {
    inline = [
      "chown -R appwrite:appwrite /home/appwrite/appwrite-config",
      "cd /home/appwrite/appwrite-config",
      "docker-compose up -d"
    ]
  }
}

# Output the server's IP address
output "server_ip" {
  value = hcloud_server.appwrite-server.ipv4_address
}
