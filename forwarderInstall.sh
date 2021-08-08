#!/bin/bash

#Set the Deployment Server IP
DEPLOYMENTSERVER_IP=" "

#Only uncomment this HOSTNAME variable you have  a special name you would like to give your forwarders upon install.
#HOSTNAME="forwarder$RANDOM"

#Adds the Splunk User if not added.
sudo useradd splunk
#Setting the Splunk Password

#Let's give splunk permissions to read basic linux logs from var messages|audit|secure.
sudo setfacl -m u:splunk:r /var/log/messages
sudo setfacl -m u:splunk:r /var/log/audit/audit.log
sudo setfacl -m u:splunk:r /var/log/secure
sudo setfacl -Rm u:splunk:rwx /opt
sudo yum -y install wget tcpdump telnet

#So we are downloading version 8.0.3 Splunk here but you can utilize any version you want.
cd /tmp
wget -O splunkforwarder-8.2.1-ddff1c41e5cf-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.2.1&product=universalforwarder&filename=splunkforwarder-8.2.1-ddff1c41e5cf-Linux-x86_64.tgz&wget=true'
sudo tar -xvf /tmp/splunkforwarder-8.2.1-* -C /opt
sudo chown -R splunk:splunk /opt/splunkforwarder/
sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Splunk18!

#sudo -u splunk /opt/splunkforwarder/bin/splunk enable listen 9997
#Now let's make sure we enter the correct server name and hostname reporting for Splunk in the UI.


#We will pass the password that you originally set earlier in the script.
#We will also set the default hostname
#Next we will set the default servername
#Finally we enable Splunk Web SSL. Be sure to custom set your certs as this script does not do that.
sudo /opt/splunkforwarder/bin/splunk enable boot-start -user splunk
sudo -u splunk mkdir /opt/splunkforwarder/etc/apps/deploymentPoller
sudo -u splunk mkdir /opt/splunkforwarder/etc/apps/deploymentPoller/local
sudo -u splunk touch /opt/splunkforwarder/etc/apps/deploymentPoller/local/deploymentclient.conf

#Uncomment the lines below to set the host inputs and servername as refected on the DS.
#sudo -u splunk /opt/splunk/bin/splunk set default-hostname $HOSTNAME -auth admin:Splunk18!
#sudo -u splunk /opt/splunk/bin/splunk set servername $HOSTNAME -auth admin:Splunk18!

#sudo -u splunk /opt/splunk/bin/splunk set deploy-poll $DEPLOYMENTSERVER_IP:8089 -auth admin:Splunk18!
#Let's put in our target Deploymentserver
sudo -u splunk echo "[deployment-client]" > /opt/splunkforwarder/etc/apps/deploymentPoller/local/deploymentclient.conf

sudo -u splunk echo "[target-broker:deploymentServer]" >> /opt/splunkforwarder/etc/apps/deploymentPoller/local/deploymentclient.conf
sudo -u splunk echo "targetUri= $DEPLOYMENTSERVER_IP:8089" >> /opt/splunkforwarder/etc/apps/deploymentPoller/local/deploymentclient.conf
sudo -u splunk /opt/splunkforwarder/bin/splunk restart
