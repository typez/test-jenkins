#!/bin/bash

# This script perform some OS configuration and install Jenkins from the
# APT repository.

set -uex

# Fix locales
echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment

# Set the Debian frontend to non-interactive to get clean logs
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Fix the
# 'sudo: unable to resolve host <hostname>: Connection timed out' "issue"
privateIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "$privateIP $(hostname)" >> /etc/hosts

# Configure additional network interface
cat <<EOF >> /etc/network/interfaces

auto eth1
iface eth1 inet dhcp
EOF

service networking restart

# Update packages (actually it's better to do it while building an AMI, but I'm
# using the stock Ubuntu AMI for this test task). Upgrade on the instance
# startup is a bit unpredictable and takes a lot of time.
apt-get update
apt-get -y upgrade

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get -y install jenkins

# "Unlock" Jenkins
#
echo "JENKINS_ARGS=\"\$JENKINS_ARGS -Djenkins.install.runSetupWizard=false\"" >> /etc/default/jenkins

mkdir /var/lib/jenkins/init.groovy.d
cat <<EOF > /var/lib/jenkins/init.groovy.d/basic-security.groovy
#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
EOF

service jenkins restart
