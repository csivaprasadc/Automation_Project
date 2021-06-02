#!/bin/bash

sudo apt update -y

S3_BUCKET_NAME="upgrad-sivaprasad"

echo "Getting Apache2 installation status"

PKG_INSTALLED="$(dpkg-query -W --showformat='${db:Status-Status}' "apache2")"

echo "$PKG_INSTALLED\n"

if [ $PKG_INSTALLED != "installed" ]; then
    echo "Installed Apache2 as it is not installed"
    sudo apt install "apache2" -y
else
    echo "Apache2 already installed"
fi

APACHE_RUNNING="$(service --status-all | grep apache2 | cut -d' ' -f3)"

if [ $APACHE_RUNNING == "+" ]
then
    echo "Apache2 already running, so restarting it"
    sudo systemctl restart apache2
else
    echo "Apache2 not running, so starting it"
    sudo systemctl start apache2
fi

TIMESTAMP=$(date '+%d%m%Y-%H%M%S')
FIRST_NAME="Sivaprasad"
TAR_FILE=${FIRST_NAME}-httpd-logs-${TIMESTAMP}.tar
APACHE_LOG_PATH="/var/log/apache2/*.log"
tar -cvf /tmp/${TAR_FILE} ${APACHE_LOG_PATH}

aws s3 cp /tmp/${TAR_FILE} s3://${S3_BUCKET_NAME}/${TAR_FILE}

SIZE=$(ls -lh /tmp/${TAR_FILE} | awk '{ print $5 }')

INVENTORY_HTML_FILE_NAME="/var/www/html/inventory.html"

if [ -f $INVENTORY_HTML_FILE_NAME ]
then
    echo "Inventory file exists in the www directory"
    sudo echo -e "httpd-logs &emsp; ${TIMESTAMP} &emsp; tar &emsp; ${SIZE} <br />" >> ${INVENTORY_HTML_FILE_NAME}
else
    echo "Inventory file does not exist in the www directory, so create it"
    sudo touch ${INVENTORY_HTML_FILE_NAME}
    sudo echo -e "<b>LogType</b> &emsp;  <b>Time Created</b> &emsp;     <b>Type</b> &emsp; <b>Size</b> <br />" >> ${INVENTORY_HTML_FILE_NAME}
    sudo echo -e "httpd-logs &emsp; ${TIMESTAMP} &emsp; tar &emsp; ${SIZE} <br />" >> ${INVENTORY_HTML_FILE_NAME}
fi
