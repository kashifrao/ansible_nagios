#!/bin/bash

echo -e "***************************************************************"
echo -e "   Setting up Nagios Client "
echo -e "***************************************************************"

res=$(systemctl is-active nrpe)

if [[ "$res" == "active" ]]
then
    echo "nrpe is already active and ruuning.. No installation needed."
else
    echo "No nrpe found. Proceed with installation."

sudo dnf install -y gcc glibc glibc-common openssl openssl-devel perl wget
cd /usr/src
sudo rm -rf nrpe-4.0.3.tar.gz*
sudo wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.0.3/nrpe-4.0.3.tar.gz
sudo tar zxf nrpe-*.tar.gz
cd nrpe-4.0.3

sudo ./configure --enable-command-args
sudo make all
sudo make install-groups-users
sudo make install
sudo make install-config

sudo sh -c "echo >> /etc/services"
sudo sh -c "sudo echo '# Nagios services' >> /etc/services"
sudo sh -c "sudo echo 'nrpe    5666/tcp' >> /etc/services"
sudo make install-init
sudo systemctl enable nrpe
#sudo nano /usr/local/nagios/etc/nrpe.cfg

sudo dnf install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release postgresql-devel libdbi-devel openldap-devel mysql-devel mysql-libs bind-utils samba-client fping openssh-clients lm_sensors

sudo dnf config-manager --enable powertools
sudo dnf install -y perl-Net-SNMP
cd /usr/src
sudo rm -rf nagios-plugins.tar.gz
sudo wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.3.3/nagios-plugins-2.3.3.tar.gz
sudo tar zxf nagios-plugins.tar.gz
cd nagios-plugins-*
sudo ./configure
sudo make
sudo make install

sudo systemctl enable nrpe
sudo systemctl start nrpe



fi
