resource "aws_instance" "bastion" {
  count = "${var.instances}"

  ami           = "${var.ami[data.aws_region.current.name]}"
  instance_type = "${var.instance-type}"

  user_data = "${data.template_cloudinit_config.config.rendered}"
  key_name  = "${var.ssh-key}"

  subnet_id = "${element(data.aws_subnet_ids.public.ids, count.index % length(data.aws_subnet_ids.public.ids))}"

  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.root-volume-size}"
  }

  tags {
    Name        = "${format("bastion-%s-%s", var.vpc, count.index + 1)}"
    Environment = "${var.vpc}"
    Service     = "bastion"
  }
}
