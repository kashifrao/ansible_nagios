#!/bin/bash

echo -e "***************************************************************"
echo -e "   Setting up Nagios Server "
echo -e "***************************************************************"

res=$(systemctl is-active nagios)

if [[ "$res" == "active" ]]
then
    echo "Nagios is already active and ruuning.. No installation needed."
else
    echo "No Nagios found. Proceed with installation."


MO=$(date +'%m' -d 'last month')
sudo rm -rf  /usr/local/nagios/var/archives/nagios-$MO*
sudo dnf -y install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip wget gettext autoconf net-snmp-utils epel-release postfix automake
sudo dnf config-manager --enable powertools
sudo dnf -y install perl-Net-SNMP

cd /usr/src
#sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
sudo rm -rf nagios*
sudo rm -rf nrpe-4.0.3*
#sudo wget https://go.nagios.org/get-core/4-5-1/nagios-4.5.1.tar.gz
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
sudo tar zxf nagios-*.tar.gz
cd nagioscore-nagios-*/
sudo ./configure


sudo make all
sudo make install-groups-users
sudo usermod -a -G nagios apache
sudo make install
sudo make install-commandmode

sudo make install-config
sudo make install-webconf

sudo systemctl restart httpd
sudo make install-daemoninit

# sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

sudo systemctl restart httpd
sudo dnf install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release postgresql-devel libdbi-devel openldap-devel mysql-devel mysql-libs bind-utils samba-client fping openssh-clients lm_sensors

sudo dnf config-manager --enable powertools
sudo dnf install -y perl-Net-SNMP
cd /usr/src
sudo wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.3.3/nagios-plugins-2.3.3.tar.gz
sudo tar zxf nagios-plugins.tar.gz
cd nagios-plugins-*
sudo ./configure
sudo make
sudo make install


cd /usr/src
sudo wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.0.3/nrpe-4.0.3.tar.gz
sudo tar zxf nrpe-*.tar.gz
cd nrpe-4.0.3
sudo ./configure
sudo make check_nrpe
sudo make install-plugin

sudo mkdir /usr/local/nagios/etc/servers
sudo systemctl enable nagios
sudo systemctl start nagios


fi
