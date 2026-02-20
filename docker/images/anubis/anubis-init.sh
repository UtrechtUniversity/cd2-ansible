#!/bin/bash

set -o allexport

if [ "$CD2_HOST_PORT" == "433" ]
then CD2_DOMAIN="${CD2_HOST}"
else CD2_DOMAIN="${CD2_HOST}:${CD2_HOST_PORT}"
fi

cat << ANUBIS_ENV > /etc/anubis/cd2catalog.env
BIND=:8080
DIFFICULTY=4
METRICS_BIND=:9090
SERVE_ROBOTS_TXT=0
METRICS_BIND_NETWORK=tcp
POLICY_FNAME=/etc/anubis/botpolicies.yml
TARGET=http://ckan:8080
ED25519_PRIVATE_KEY_HEX="$ANUBIS_ED25519_PRIVATE_KEY"
COOKIE_DYNAMIC_DOMAIN=true
REDIRECT_DOMAINS=${CD2_DOMAIN}
ANUBIS_ENV

while true
do echo "Starting Anubis ..."
   sudo -u anubis bash -c "set -o allexport; source /etc/anubis/cd2catalog.env; set +o allexport; /usr/bin/anubis"
   echo "Anubis terminated. Will attempt restart after five seconds."
   sleep 5
done
