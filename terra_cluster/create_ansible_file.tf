resource "local_file" "hosts" {
  content = templatefile("${path.module}/template_ansi.tftpl",
    {
      control = yandex_compute_instance.control
      # work-b  = yandex_compute_instance.work-b
      # work-d  = yandex_compute_instance.work-d
    }
  )
  filename = "hosts.cfg"
}