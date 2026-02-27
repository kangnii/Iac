terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
  backend "s3" {
    bucket                      = "iac-wisdom-terraform-state"
    key                         = "terraform.tfstate"
    region                      = "gra"
    endpoint                    = "https://s3.gra.io.cloud.ovh.net"
    force_path_style            = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

# Utilise les variables OS_* (source openrc-etudiant.sh)
provider "openstack" {
  # Auth via variables d'environnement (OS_AUTH_URL, OS_USERNAME, etc.)
}

variable "ssh_public_key" {
  description = "SSH public key for OpenStack keypair"
  type        = string
  # Pas de default → force TF_VAR_ssh_public_key en CI
}

locals {
  ssh_public_key_effective = trimspace(var.ssh_public_key)
}

resource "openstack_compute_keypair_v2" "main" {
  name       = "my-keypairo-wisdom"
  public_key = local.ssh_public_key_effective
}

resource "openstack_compute_instance_v2" "main" {
  name            = "iac-wisdom-vm"
  image_name      = "Ubuntu 24.04"
  flavor_name     = "d2-2"
  key_pair        = openstack_compute_keypair_v2.main.name
  security_groups = ["default"]

  network {
    name = "Ext-Net"
  }
}

output "instance_ip" {
  description = "Public IPv4 of the provisioned VM"
  value = coalesce(
    try(openstack_compute_instance_v2.main.access_ip_v4, null),
    try(openstack_compute_instance_v2.main.network[0].fixed_ip_v4, null)
  )
}

output "instance_name" {
  description = "VM name"
  value       = openstack_compute_instance_v2.main.name
}
