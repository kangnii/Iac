terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
}
 
# Utilise clouds.yaml pour GRA9
provider "openstack" {
  cloud = "ovh-gra9"
}
 
resource "openstack_compute_keypair_v2" "main" {
  name       = "my-keypair-wisdom"
  public_key = file("/home/wisdom-follygan/Téléchargements/ssh-key-2026-02-19.key.pub")
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
  value       = coalesce(
    try(openstack_compute_instance_v2.main.access_ip_v4, null),
    try(openstack_compute_instance_v2.main.network[0].fixed_ip_v4, null)
  )
}

output "instance_name" {
  description = "VM name"
  value       = openstack_compute_instance_v2.main.name
}
