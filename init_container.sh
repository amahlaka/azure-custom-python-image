#!/usr/bin/env bash

cat >/etc/motd <<EOL 

  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 

A P P   S E R V I C E   O N   L I N U X
With modifications by Arttu Mahlakaarto
Documentation: http://aka.ms/webapp-linux

EOL
cat /etc/motd

service ssh start


# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)

echo "$@" > /opt/startup/startupCommand
chmod 755 /opt/startup/startupCommand
if [[ $APPSETTING_CUSTOM_VENV  ]]; then
        echo "Custom Virtual enviroment set"
        cd /home/site/wwwroot/
        if [ ! -d $APPSETTING_CUSTOM_VENV  ]; then
                echo "Installing python venv $APPSETTING_CUSTOM_VENV "
                python -m venv $APPSETTING_CUSTOM_VENV 
                . $APPSETTING_CUSTOM_VENV /bin/activate
        fi
        if [ -f "requirements.txt" ]; then
                echo "Running pip install"
                pip install -r requirements.txt
        fi
fi
echo "Running python /usr/local/bin/entrypoint.py"

eval "exec python -u /usr/local/bin/entrypoint.py"