#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #

  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
  fi

  service_install_path="/opt/ec2-auto-shutdown"
  config_install_path="/etc/ec2-auto-shutdown"
  systemd_service_unit_install_path="/etc/systemd/system"

  github_url="https://raw.githubusercontent.com/efang/ec2-auto-shutdown/master"
  service_path="/ec2-auto-shutdown"
  config_path="/ec2-auto-shutdown-config"
  systemd_service_unit_path="/ec2-auto-shutdown.service"


  make_dir_and_verify() {

    mkdir -p $1
    if [ ! -d $1 ]; then
      echo "Unable to create $1"
      exit
    fi

  }

  download_and_verify() {

    curl -o $1 $2

    if [ ! -f $1 ]; then
      echo "Download of $2 failed."
      exit
    fi

  }

  make_dir_and_verify $service_install_path
  make_dir_and_verify $config_install_path

  download_and_verify $service_install_path$service_path $github_url$service_path 
  download_and_verify $config_install_path$config_path $github_url$config_path 
  download_and_verify $systemd_service_unit_install_path$systemd_service_unit_path $github_url$systemd_service_unit_path 

  chmod +x $service_install_path$service_path
  systemctl enable ec2-auto-shutdown.service 
  systemctl start ec2-auto-shutdown.service 

  echo "ec2-auto-shutdown is installed."

} # this ensures the entire script is downloaded #

