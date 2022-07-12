#!/usr/bin/env bash

cat flatcar.config.yml | docker run --rm -i ghcr.io/flatcar-linux/ct:latest > ignition.json
packer build -force .