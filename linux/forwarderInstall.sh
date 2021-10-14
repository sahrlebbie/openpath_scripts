#!/bin/bash

#Set the Deployment Server IP
DEPLOYMENTSERVER_IP=""
PASSWORD=""
APPS_DS_APP="" Name of the app to connect to Deployment Server. This will create it locally and then it can be overridden at the Deploymentserver level.
#Only uncomment this HOSTNAME variable you have  a special name you would like to give your forwarders upon install.
HOSTNAME=""

#Adds the Splunk User if not added. You can sett he password later through automation tool or a script.
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
sudo tar -xvf /tmp/splunkforwarder-8.2.1-ddff1c41e5cf-Linux-x86_64.tgz -C /opt
sudo chown -R splunk:splunk /opt/splunkforwarder/
sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $PASSWORD

#Now let's make sure we enter the correct server name and hostname reporting for Splunk in the UI.


#We will pass the password that you originally set earlier in the script.
#We will also set the default hostname
#Next we will set the default servername
#Finally we enable Splunk Web SSL. Be sure to custom set your certs as this script does not do that.
sudo /opt/splunkforwarder/bin/splunk enable boot-start -user splunk
sudo mkdir /opt/splunkforwarder/etc/apps/$APPS_DS_APP
sudo mkdir /opt/splunkforwarder/etc/apps/$APPS_DS_APP/local
sudo touch /opt/splunkforwarder/etc/apps/$APPS_DS_APP/local/deploymentclient.conf

#Uncomment the lines below to set the host inputs and servername as refected on the DS.
sudo /opt/splunk/bin/splunk set default-hostname $HOSTNAME -auth admin:$PASSSWORD
sudo /opt/splunk/bin/splunk set servername $HOSTNAME -auth admin:$PASSWORD

sudo /opt/splunk/bin/splunk set deploy-poll $DEPLOYMENTSERVER_IP:8089 -auth admin:$PASSWORD
#Let's put in our target Deploymentserver
sudo  echo "[deployment-client]" > /opt/splunkforwarder/etc/apps/$APPS_DS_APP/local/deploymentclient.conf

sudo echo "[target-broker:deploymentServer]" >> /opt/splunkforwarder/etc/apps/$APPS_DS_APP/local/deploymentclient.conf
sudo echo "targetUri= $DEPLOYMENTSERVER_IP:8089" >> /opt/splunkforwarder/etc/apps/$APPS_DS_APP/local/deploymentclient.conf
sudo chown -R splunk:splunk /opt/splunkforwarder/
sudo -u splunk /opt/splunkforwarder/bin/splunk restart
