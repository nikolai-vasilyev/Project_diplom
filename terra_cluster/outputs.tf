output "cluster" {
  value = [
    { control = [for i in yandex_compute_instance.control : "${i.name}: ssh alma@${i.network_interface.0.nat_ip_address} , ssh alma@${i.network_interface.0.ip_address} "] },
    { work-b = [for i in yandex_compute_instance.work-b : "${i.name}: ssh alma@${i.network_interface.0.nat_ip_address} , ssh alma@${i.network_interface.0.ip_address} "] },
    { work-d = [for i in yandex_compute_instance.work-d : "${i.name}: ssh alma@${i.network_interface.0.nat_ip_address} , ssh alma@${i.network_interface.0.ip_address} "] },
    { NLB-test-app = yandex_lb_network_load_balancer.lb-cluster-web.listener.*.external_address_spec[0].*.address },
    { NLB-prometheus = yandex_lb_network_load_balancer.lb-cluster-monitoring.listener.*.external_address_spec[0].*.address }
  ]
}
