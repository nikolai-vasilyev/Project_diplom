###########################################Network cluster
resource "yandex_vpc_network" "network" {
  name = local.network
}

resource "yandex_vpc_subnet" "zone1" {
  name           = local.zone1_name
  zone           = var.zones.zone1
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.zones_cidr.zone1
  route_table_id = yandex_vpc_route_table.route-table.id
}
resource "yandex_vpc_subnet" "zone2" {
  name           = local.zone2_name
  zone           = var.zones.zone2
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.zones_cidr.zone2
  route_table_id = yandex_vpc_route_table.route-table.id
}
resource "yandex_vpc_subnet" "zone3" {
  name           = local.zone3_name
  zone           = var.zones.zone3
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.zones_cidr.zone3
  route_table_id = yandex_vpc_route_table.route-table.id
}

# ########################################table_route
resource "yandex_vpc_route_table" "route-table" {
  name       = var.route_name
  network_id = yandex_vpc_network.network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.gateway.id
  }
}
resource "yandex_vpc_gateway" "gateway" {
  folder_id = var.folder_id
  name      = "cluster-gateway"
  shared_egress_gateway {}
}

######################################################NLB
resource "yandex_lb_network_load_balancer" "lb-cluster-web" {
  name       = "lb-${local.network}-web"
  depends_on = [yandex_lb_network_load_balancer.lb-cluster-monitoring]
  listener {
    name        = "listener-web-servers"
    port        = 80
    target_port = 30007
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.cluster.id

    healthcheck {
      name = "test-web-app"
      tcp_options {
        port = 30007
      }
    }
  }
}
resource "yandex_lb_network_load_balancer" "lb-cluster-monitoring" {
  name       = "lb-${local.network}-prometheus"
  depends_on = [yandex_compute_instance.control, yandex_compute_instance.work-b, yandex_compute_instance.work-d]
  listener {
    name        = "listener-web-servers"
    port        = 80
    target_port = 32459
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.cluster.id

    healthcheck {
      name = "prometheus"
      tcp_options {
        port = 32459
      }
    }
  }
}
resource "yandex_lb_target_group" "cluster" {
  name = "${local.network}-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.control
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }

  dynamic "target" {
    for_each = yandex_compute_instance.work-b
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }

  dynamic "target" {
    for_each = yandex_compute_instance.work-d
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}
