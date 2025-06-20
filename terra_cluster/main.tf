#control
resource "yandex_compute_instance" "control" {
  count       = var.resource_nodes.control.count
  name        = "${local.control_name}-${count.index + 1}"
  platform_id = var.control_platform
  zone        = var.zones.zone1
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
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.remoute_ssh_pub}"
  }
  provisioner "file" {
    content     = var.remoute_ssh_priv
    destination = "/home/ubuntu/.ssh/id_ed25519"
    connection {
      type        = "ssh"
      user        = "ubuntu"
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
    inline = [
      "sudo chmod 600 ~/.ssh/id_ed25519 && echo | tee -a /home/ubuntu/.ssh/id_ed25519"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = yandex_compute_instance.control[0].network_interface.0.nat_ip_address
      private_key = var.remoute_ssh_priv
    }
  }
}

#work
resource "yandex_compute_instance" "work-b" {
  count       = var.resource_nodes.work-b.count
  name        = "${local.work-b_name}-${count.index + 1}"
  platform_id = var.work_platform
  zone        = var.zones.zone2
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
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone2.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${var.remoute_ssh_pub}"
  }
}
resource "yandex_compute_instance" "work-d" {
  count       = var.resource_nodes.work-d.count
  name        = "${local.work-d_name}-${count.index + 1}"
  platform_id = var.work_platform
  zone        = var.zones.zone3
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
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.zone3.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${var.remoute_ssh_pub}"
  }
}
