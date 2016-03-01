#!/bin/bash

usermod -u ${DEV_USER_ID} www-data
echo "CHANGED www-data id to ${DEV_USER_ID}"

service php5-fpm start
service nginx start

tail -f /var/log/nginx/*.log /var/log/php*.log &

while true; do sleep 1; done
