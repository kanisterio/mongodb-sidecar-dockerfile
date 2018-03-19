#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

cd /kanister

echo "============================ Create a log file ================================="
touch /var/log/kanister.log

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p ${HOME}/.ssh/
mv config ${HOME}/.ssh/
mv 90forceyes /etc/apt/apt.conf.d/

echo "================= Installing basic packages ==================="
apt-get update
apt-get install curl sudo wget groff

echo "================= Install Mongo Tools ==================="
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
apt-get update
apt-get install mongodb-org-tools mongodb-org-shell
wget https://github.com/Percona-Lab/mongodb_consistent_backup/releases/download/1.1.0/mongodb-consistent-backup_1.1.0-2_amd64.deb
dpkg -i ./mongodb-consistent-backup_1.1.0-2_amd64.deb

echo "================= Installing Python packages ==================="
apt-get install \
  python-pip \
  python-software-properties \
  python-dev
pip install virtualenv
pip install --upgrade pip

echo "================= Adding awscli ============"
pip install awscli

echo "================= Adding gcloud ============"
# Working around https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1583102
chown root:root /tmp && chmod 1777 /tmp
# Copied from https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update
apt-get install google-cloud-sdk

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
