#!/usr/bin/env bash

docker run -i --rm quay.io/coreos/butane:release --pretty --strict < flatcar.config.yml > ignition.json
packer build -force .
cd builds
vagrant up
vagrant ssh
vagrant destroy --force
cd -