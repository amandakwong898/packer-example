provider "alicloud" {}

data "alicloud_images" "search" {
  name_regex = "metar_app"
}

data "alicloud_instance_types" "search" {
  instance_type_family = "ecs.xn4"
  cpu_core_count = 1
  memory_size = 1
}

data "alicloud_security_groups" "search" {}

data "alicloud_vswitches" "search" {}

resource "alicloud_instance" "app" {
  instance_name = "metar_app"
  image_id = "${data.alicloud_images.search.images.0.image_id}"
  instance_type = "${data.alicloud_instance_types.search.instance_types.0.id}"

  vswitch_id = "${data.alicloud_vswitches.search.vswitches.0.id}"
  security_groups = [
    "${data.alicloud_security_groups.search.groups.0.id}"
  ]
  internet_max_bandwidth_out = 100

  password = "Test1234!"

  user_data = "${file("user-data")}"
}

output "ip" {
  value = "${alicloud_instance.app.public_ip}"
}