#!/bin/bash

## Only include mailpit rev proxy configuration is mailpit is enabled.
if [ "$MTA_ROLE" == "mailpit" ]
then cat /etc/nginx/nginx.site.part1 /etc/nginx/nginx.site.part-mailpit /etc/nginx/nginx.site.part2 > /etc/nginx/conf.d/nginx.conf
else cat /etc/nginx/nginx.site.part1 /etc/nginx/nginx.site.part2 > /etc/nginx/conf.d/nginx.conf
fi

# Import certificates if available in import bind mount. Otherwise generate
# a self-signed certificate

CERTIFICATE_IMPORTDIR=/etc/import-certificates
CERTIFICATE_DIR=/etc/certificates
cd "$CERTIFICATE_DIR"

if [ -f "${CERTIFICATE_IMPORTDIR}/cd2.pem" ] && [ -f "${CERTIFICATE_IMPORTDIR}/cd2.key" ]
then echo "Importing TLS certificate ..."
     cp "${CERTIFICATE_IMPORTDIR}/cd2.pem" "${CERTIFICATE_DIR}/cd2.pem"
     cp "${CERTIFICATE_IMPORTDIR}/cd2.key" "${CERTIFICATE_DIR}/cd2.key"
else if [ -f "cd2.pem" ]
     then echo "Skipping certificate generation, because certificate files are already present."
     else echo "Generating certificates for reverse proxy  at https://$CD2_HOST ..."
	  export CD2_HOST="$CD2_HOST"
          perl -pi.bak -e '$cd2_host=$ENV{CD2_HOST}; s/CD2_HOST/$cd2_host/ge' /etc/certificates/cd2.cnf
          openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout cd2.key -out cd2.pem -config cd2.cnf
     echo "Certificate generation complete."
     fi
fi

if [ -f "dhparams.pem" ]
then echo "Skipping DHParam generation, because DHParam file is already present."
else echo "Generating DHParam configuration..."
     openssl dhparam -dsaparam -out "${CERTIFICATE_DIR}/dhparams.pem" 4096
     echo "DHParam generation complete."
fi

# Configure host header for reverse proxy
if [ "$CD2_HOST_PORT" -eq "443" ]
then export HOST_HEADER="${CD2_HOST}"
else export HOST_HEADER="${CD2_HOST}:${CD2_HOST_PORT}"
fi
perl -pi.bak -e '$host_header=$ENV{HOST_HEADER}; s/PUT_HOST_HEADER_HERE/"$host_header"/ge' "/etc/nginx/conf.d/nginx.conf"

# Configure configuration for determing real IP address of request
if [ "$CD2_BEHIND_LOADBALANCER" -eq "1" ]
then export REALIPCONFIG="real_ip_header X-Forwarded-For;"
else export REALIPCONFIG="proxy_set_header X-Real-IP \$remote_addr;"
fi
perl -pi.bak -e '$realipconfig=$ENV{REALIPCONFIG}; s/PUT_REAL_IP_DIRECTIVE_HERE/$realipconfig/ge' "/etc/nginx/conf.d/nginx.conf"

## Run Nginx
nginx -g "daemon off;"
