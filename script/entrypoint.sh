#!/bin/bash

service php5-fpm start
service nginx start

tail -f /var/log/nginx/*.log /var/log/php*.log &

while true; do sleep 1; done
