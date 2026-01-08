#!/bin/bash

# Validate required variables
# ECS
if [ -z "${ecs_cluster_name}" ]; then
  echo "Error: ecs_cluster_name is not set" >&2
  exit 1
fi

if [ -z "${project_name}" ]; then
  echo "Error: project_name is not set" >&2
  exit 1
fi

# Write and validate content files
# DuckDNS
cat << 'SCRIPT' > "/usr/local/bin/update-duckdns.sh"
${update_duckdns_content}
SCRIPT

if [ ! -s "/usr/local/bin/update-duckdns.sh" ]; then
  echo "Error: update_duckdns_content is empty" >&2
  rm "/usr/local/bin/update-duckdns.sh"
  exit 1
fi

# Nginx
mkdir -p "/etc/nginx-config"
cat << 'CONF' > "/etc/nginx-config/default.conf"
${nginx_conf_content}
CONF

if [ ! -s "/etc/nginx-config/default.conf" ]; then
  echo "Error: nginx_conf_content is empty" >&2
  rm "/etc/nginx-config/default.conf"
  exit 1
fi

# Join the cluster
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config

# DuckDNS
chmod +x "/usr/local/bin/update-duckdns.sh"
/usr/local/bin/update-duckdns.sh > /var/log/duckdns.log 2>&1
cat "/var/log/duckdns.log"

# Cron job to update every 5 mins
echo "*/5 * * * * root /usr/local/bin/update-duckdns.sh >> /var/log/duckdns.log 2>&1" > /etc/cron.d/duckdns

# Install Certbot
amazon-linux-extras install epel -y
yum install -y certbot

RETRY_INTERVAL=30

# Wait a bit for DNS propagation
sleep "$RETRY_INTERVAL"

# Request Certificate with retries
# Ensure port 80 is free (it should be on fresh instance)
MAX_RETRIES=5
for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "Attempt $i of $MAX_RETRIES to obtain certificate..."
  certbot certonly --standalone --non-interactive --agree-tos -m "admin@${project_name}.duckdns.org" -d "${project_name}.duckdns.org"
  if [ $? -eq 0 ]; then
    echo "Certificate obtained successfully."
    break
  else
    if [ "$i" -eq "$MAX_RETRIES" ]; then
      echo "Error: Certbot failed after $MAX_RETRIES attempts." >&2
      exit 1
    fi
    echo "Certbot failed. Retrying in $RETRY_INTERVAL seconds..."
    sleep "$RETRY_INTERVAL"
  fi
done
