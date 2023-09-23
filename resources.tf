resource "digitalocean_tag" "main" {
  name = "tailscale-exit-node"
}

# Create a new SSH key
resource "digitalocean_ssh_key" "main" {
  name       = "Tailscale Exit Node SSH Key"
  public_key = file(var.ssh_key_pub)
}

# Create a new Droplet
resource "digitalocean_droplet" "main" {
  image    = "debian-12-x64"
  name     = "tailscale-xn-001"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.main.fingerprint]
  tags     = [digitalocean_tag.main.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.ssh_key)
  }

  # Install and configure tailscale
  provisioner "remote-exec" {
    inline = [
      # wait for other droplet initial processes to finish",
      "sleep 20",
      # https://tailscale.com/download/linux/debian-bookworm
      "curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null",
      "curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list",
      "sudo apt-get update -y",
      "sudo apt-get install tailscale -y",
      # https://tailscale.com/kb/1103/exit-nodes/#configuring-an-exit-node
      "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf",
      "echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf",
      "sudo sysctl -p /etc/sysctl.d/99-tailscale.conf",
      "sudo tailscale up --advertise-exit-node --authkey=${var.tailscale_key}"
    ]
  }
}

resource "digitalocean_firewall" "tailscale" {
  depends_on = [
    digitalocean_droplet.main
  ]

  name = "only-tailscale"

  tags = [digitalocean_tag.main.id]

  inbound_rule {
    protocol         = "udp"
    port_range       = "3478"
    source_addresses = ["100.64.0.0/10"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "41641"
    source_addresses = ["100.64.0.0/10"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
