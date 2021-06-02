#!/bin/sh

echo "Start Crontab verification"

CRON_JOB_FILE="/etc/cron.d/automation"

if [ -f $CRON_JOB_FILE ]
then
    echo "Cronjob file exists and skipping the setup"
else
    echo "Cronjob not setup, so setting it up"
    echo "1 * * * * root /root/Automation_Project/automation.sh" > ${CRON_JOB_FILE}
fi
