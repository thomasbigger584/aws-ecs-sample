#!/bin/bash

# Validate required variables
if [ -z "${project_name}" ]; then
  echo "Error: project_name is not set" >&2
  exit 1
fi

if [ -z "${duckdns_token}" ]; then
  echo "Error: duckdns_token is not set" >&2
  exit 1
fi

MAX_RETRIES=5
RETRY_INTERVAL=15

for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "Attempt $i of $MAX_RETRIES to update DuckDNS..."
  RESPONSE=$(curl -sS "https://www.duckdns.org/update?domains=${project_name}&token=${duckdns_token}&ip=")

  if [ "$RESPONSE" == "OK" ]; then
    echo "DuckDNS update successful."
    exit 0
  else
    if [ "$i" -eq "$MAX_RETRIES" ]; then
      echo "Error: DuckDNS update failed after $MAX_RETRIES attempts. Last response: $RESPONSE" >&2
      exit 1
    fi
    echo "Update failed (Response: $RESPONSE). Retrying in $RETRY_INTERVAL seconds..."
    sleep "$RETRY_INTERVAL"
  fi
done
