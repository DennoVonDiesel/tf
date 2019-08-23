data "template_file" "config" {
  template = "${file("${path.module}/cloud-init.cfg")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.config.rendered}"
  }
}
