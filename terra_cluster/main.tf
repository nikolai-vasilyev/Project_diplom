#############################################control
resource "yandex_compute_instance" "control" {
  count                     = var.resource_nodes.control.count
  name                      = "${local.control_name}-${count.index + 1}"
  platform_id               = var.control_platform
  zone                      = var.zones.zone1
  allow_stopping_for_update = var.stop_for_update.control
  resources {
    cores         = var.resource_nodes.control.cores
    memory        = var.resource_nodes.control.memory
    core_fraction = var.resource_nodes.control.core_fraction
  }
  scheduling_policy {
    preemptible = var.preemptible_control
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image
      size     = var.resource_nodes.control.size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone1.id
    nat       = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: alma
    groups: sudo
    shell: /bin/bash
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    ssh_authorized_keys:
      - "${var.remoute_ssh_pub}"
EOF
  }
  provisioner "file" {
    content     = var.remoute_ssh_priv
    destination = "/home/alma/.ssh/id_ed25519"
    connection {
      type        = "ssh"
      user        = "alma"
      host        = yandex_compute_instance.control[0].network_interface.0.nat_ip_address
      private_key = var.remoute_ssh_priv
    }
  }
}
resource "null_resource" "remote-exec" {
  # triggers = {
  #   id = timestamp()
  # }
  provisioner "remote-exec" {
    script = "script.sh"
    connection {
      type        = "ssh"
      user        = "alma"
      host        = yandex_compute_instance.control[0].network_interface.0.nat_ip_address
      private_key = var.remoute_ssh_priv
    }
  }
  depends_on = [yandex_compute_instance.control]
}

####################################work
resource "yandex_compute_instance" "work-b" {
  count                     = var.resource_nodes.work-b.count
  name                      = "${local.work-b_name}-${count.index + 1}"
  platform_id               = var.work_platform
  zone                      = var.zones.zone2
  allow_stopping_for_update = var.stop_for_update.work_b
  scheduling_policy {
    preemptible = var.preemptible_work
  }
  resources {
    cores         = var.resource_nodes.work-b.cores
    memory        = var.resource_nodes.work-b.memory
    core_fraction = var.resource_nodes.work-b.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image
      size     = var.resource_nodes.work-b.size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone2.id
    nat       = true
  }
  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: alma
    groups: sudo
    shell: /bin/bash
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    ssh_authorized_keys:
      - "${var.remoute_ssh_pub}"
EOF
  }
}
resource "yandex_compute_instance" "work-d" {
  count                     = var.resource_nodes.work-d.count
  name                      = "${local.work-d_name}-${count.index + 1}"
  platform_id               = var.work_platform
  zone                      = var.zones.zone3
  allow_stopping_for_update = var.stop_for_update.work_d
  scheduling_policy {
    preemptible = var.preemptible_work
  }
  resources {
    cores         = var.resource_nodes.work-d.cores
    memory        = var.resource_nodes.work-d.memory
    core_fraction = var.resource_nodes.work-d.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image
      size     = var.resource_nodes.work-d.size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone3.id
    nat       = true
  }
  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: alma
    groups: sudo
    shell: /bin/bash
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    ssh_authorized_keys:
      - "${var.remoute_ssh_pub}"
EOF
  }
}
