#!/bin/bash

Set few variables variable.
REMOTE_SERVER=<SERVER_TO_INSTALL_TRAPS>
REMOTE_SERVER_LOCATION=<WHERE_TO_INSTALL_REMOTE_SERVER>
REMOTE_USER_NAME=<YOURUSER>
PACKAGE_LOCATION=<TRAPS_LINUX_PACKAGE_LOCATION>
#Let's clear our screen so we can think.
clear

#This script was created to install one or multiple traps agents onto multiple servers. 

###############################################CHECKLIST FOR SCRIPT TO WORK####################################################

#1) You will need to have the Traps Agent install file that will be used to scp to all the other servers.
#2) You will need a host file that will be used to do the multiple traps install. In our script that is called clariumServers.txt.
#Change that File to be whatever host you want it to be. 
#3) The user that runs this script needs to be able to sudo to root to do this installation.There will be a prompt for that. 
#4) Make sure there are no firewalls between the local server you are running this script on and the agents you are attempting to compete the installation. 

echo "                     # _---_"
echo "                    #-       /--__"
echo "               #_--( /     \ )XXXXXXXXXXX"
echo "             #####(   O   O  )XXXXXXXXXXXXXXX"
echo "            ####(       U     )        XXXXXXX"
echo "          #XXXXX(              )--_  XXXXXXXXXXX"
echo "         #XXXXX/ (      O     )   XXXXXX   \XXXXX"
echo "         #XXXX/   /            XXXXXX   \__ \XXXXX"
echo "         #XXXXX_/          XXXXXX         \_---->"
echo "   #_  XXX_/          XXXXXX      \_         /"
echo "   #-  --_/   _/\  XXXXXX            /  __--/="
echo "    #-\    _/    XXXXXX              '--- XXXXXX"
echo "       ######\ XXXXXX                      /XXXXX"
echo "         #XXXXXXXXX   \                    /XXXXX"
echo "          #XXXXXX      >                 _/XXXXX"
echo "            #XXXXX--_/              _-- XXXX"
echo "             #XXXXXXXX---------------  XXXXXX"
echo "                #XXXXXXXXXXXXXXXXXXXXXXXXXX/"
echo "                  #VXXXXXXXXXXXXXXXXXXV"


#First we are going to save two variables. A user check to make sure we run as root and then the exit code after installation.
#The script will prompt you for you password on each agent to sudo as root. 
#You can delete this line if your user can run sudo commands WITHOUT password.
USER_CHECK=$(whoami)
EXIT_CODE=$(echo $?)

#The start of this script looks for the servers we mentioned in the CHECKLIST above. In order to be able to scp you need the list.
#Change /Users/sahr.lebbie/.ssh/ssh_packages/Linux_version_612.sh to the package and location you have downloaded.
#We have decided  to move this package into the /tmp directory. You can change that of course.
for server in $(cat ~/.ssh/clariumServers.txt)
do
  echo "We are going to scp the file from the location you have your package to the remote servers"
  sleep 2s
  scp $PACKAGE_LOCATION $USER_NAME@$REMOTE_SERVER:/$REMOTE_SERVER_LOCATION
  ssh "$USER_NAME@$REMOTE_SERVER" << EOF
echo "Currently you are running as...."
whoami
echo "We are going to SUDO to root user to install Traps as the root user(recommended by documentation)"
sudo su
echo "You are now...."
whoami
echo "on $server."

########################################NEXT PHASE###############################################################################

sleep 4s
export TERM=xterm
echo "Let's wait for a second then clear....."
sleep 4s
  clear
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "------------------------------------------------------------------------------------------------------------------"
  sleep 3s
  clear
  echo "..."
  sleep 1s
  echo "....."
  sleep 1s
  echo "......."
  sleep 1s
  echo "........."
  sleep 1s
  echo "..........."
  sleep 1s
  echo "............."

########################################NEXT PHASE###############################################################################
 
echo "We are now going to begin Traps Installation on $server"
  sleep 3s
  clear
  yum install -y policycoreutils-python
  yum install -y selinux-policy-devel
  mv /tmp/Linux_version_612.sh /opt
  chmod +x /opt/Linux_version_612.sh
  /opt/Linux_version_612.sh
  sleep 3s
  echo "The agent has been installed and will now checkin."
  echo "Please pay attention to the enumeration that occurs."
  echo "If Traps enumerates with serveral PIDs, then installation was successful"
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "------------------------------------------------------------------------------------------------------------------"
  /opt/traps/bin/cytool checkin
  sleep 3s
  /opt/traps/bin/cytool enum
  echo "After the installation, the exit code for $server is $EXIT_CODE."
  echo "The Traps installation has been successfuly completed on $server if the exit code is 0"
  echo "If the exit code is 1 or any other number, then the installation failed."
  echo "If the exit code is 0, please check on the Traps Management Server to see if $server is reporting"
  sleep 5s
  clear
EOF

done

sleep 3s
echo "Congrats, Hopefully Traps is now successfully installed on all your servers."
echo "If so, Go enjoy your day"
echo "If not, back to WORK........."
sleep 3s


echo "                     # _---_"
echo "                    #-       /--__"
echo "               #_--( /     \ )XXXXXXXXXXX"
echo "             #####(   O   O  )XXXXXXXXXXXXXXX"
echo "            ####(       U     )        XXXXXXX"
echo "          #XXXXX(              )--_  XXXXXXXXXXX"
echo "         #XXXXX/ (      O     )   XXXXXX   \XXXXX"
echo "         #XXXX/   /            XXXXXX   \__ \XXXXX"
echo "         #XXXXX_/          XXXXXX         \_---->"
echo "   #_  XXX_/          XXXXXX      \_         /"
echo "   #-  --_/   _/\  XXXXXX            /  __--/="
echo "    #-\    _/    XXXXXX              '--- XXXXXX"
echo "       ######\ XXXXXX                      /XXXXX"
echo "         #XXXXXXXXX   \                    /XXXXX"
echo "          #XXXXXX      >                 _/XXXXX"
echo "            #XXXXX--_/              _-- XXXX"
echo "             #XXXXXXXX---------------  XXXXXX"
echo "                #XXXXXXXXXXXXXXXXXXXXXXXXXX/"
echo "                  #VXXXXXXXXXXXXXXXXXXV"
