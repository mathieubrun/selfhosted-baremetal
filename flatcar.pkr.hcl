variable "channel" {
  type = string
  default = "stable"
}

variable "version" {
  type = string
  default = "current"
}

variable "checksum" {
  type = string
  default = "md5:74541c505170b5b4603bb0d927506d7a"
}

source "virtualbox-iso" "flatcar" {
  cpus = 2
  memory = 16384
  guest_os_type = "Linux_64"
  iso_url = "https://${var.channel}.release.flatcar-linux.net/amd64-usr/current/flatcar_production_iso_image.iso"
  iso_checksum = var.checksum
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

  provisioner "file" {
    source = "ignition.json"
    destination =  "/tmp/ignition.json"
  }

  provisioner "shell" {
    inline = ["sudo flatcar-install -d /dev/sda -i /tmp/ignition.json"]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      provider_override   = "virtualbox"
      output = "builds/flatcar-${var.channel}-${var.version}.box"
      vagrantfile_template= "Vagrantfile.template"
    }
  }
}
