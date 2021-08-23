#!/bin/bash

#Defining the Cluster Master. DNS or IP can be used here.
CLUSTERMASTER="https://" 
PASSWORD=""
ADMIN_USER=""
PASS_4_SYM=""
#Adds the Splunk User just incase the user is not set. Add the Splunk password later or through some automation tool.
sudo useradd splunk


#Let's give splunk permissions to read basic linux logs from var messages|audit|secure.
sudo setfacl -m u:splunk:r /var/log/messages
sudo setfacl -m u:splunk:r /var/log/audit/audit.log
sudo setfacl -m u:splunk:r /var/log/secure
sudo setfacl -Rm u:splunk:rwx /opt
sudo yum -y install wget tcpdump telnet

#So we are downloading version 8.0.3 Splunk here but you can utilize any version you want.
cd /tmp
wget -O splunk-8.0.3-a6754d8441bf-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.3&product=splunk&filename=splunk-8.0.3-a6754d8441bf-Linux-x86_64.tgz&wget=true'
sudo tar -xvf /tmp/*splunk-8.0.3-* -C /opt
sudo chown -R splunk:splunk /opt/splunk/
sudo -u splunk /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $PASSWORD

#sudo -u splunk /opt/splunk/bin/splunk enable listen 9997
#Now let's make sure we enter the correct server name and hostname resporting for Splunk in the UI.


#We will pass the password that you originally set earlier in the script.
#We will also set the default hostname
#Next we will set the default servername
#Finally we enable Splunk Web SSL. Be sure to custom set your certs as this script does not do that.
sudo -u splunk /opt/splunk/bin/splunk enable boot-start -user splunk
sudo -u splunk /opt/splunk/bin/splunk enable web-ssl -auth $ADMIN_USER:$PASSWORD
sudo -u splunk /opt/splunk/bin/splunk enable listen 9997 -auth admin:Splunk18!
sudo -u splunk /opt/splunk/bin/splunk edit cluster-config -mode slave -secret $PASS_4_SYM -master_uri $CLUSTERMASTER:8089 -replication_port 9887 -auth $ADMIN_USER:$PASSWORD
sudo -u splunk /opt/splunk/bin/splunk restart
