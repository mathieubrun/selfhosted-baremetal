source "virtualbox-iso" "flatcar" {
  cpus = 2
  memory = 16384
  guest_os_type = "Linux_64"
  iso_url = "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_iso_image.iso"
  iso_checksum = "md5:74541c505170b5b4603bb0d927506d7a"
  boot_wait = "20s"
  ssh_username = "core"
  ssh_password = "packer"
  boot_command = [
      "echo 'core:packer' | sudo chpasswd<enter><wait>",
      "sudo systemctl start sshd.service<enter>"
  ]
  shutdown_command = "sudo poweroff"
}
 
build {
  sources = ["sources.virtualbox-iso.flatcar"]
}
