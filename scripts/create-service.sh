#!/usr/bin/env bash

set -e

echo "=== Homelab Platform Service Generator ==="

echo
read -p "App name: " APP_NAME

if [ -z "$APP_NAME" ]; then
  echo "App name is required"
  exit 1
fi

echo
echo "Available templates:"
find templates/starter -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort

echo
read -p "Template: " TEMPLATE

if [ -z "$TEMPLATE" ]; then
  echo "Template is required"
  exit 1
fi

if [ ! -d "templates/starter/$TEMPLATE" ]; then
  echo "Template '$TEMPLATE' does not exist"
  exit 1
fi

echo
read -p "Port [8080]: " PORT
PORT=${PORT:-8080}

echo
read -p "Registry [ghcr.io/emmexgdc]: " REGISTRY
REGISTRY=${REGISTRY:-ghcr.io/emmexgdc}

echo
read -p "Enable ingress? (true/false) [true]: " INGRESS
INGRESS=${INGRESS:-true}

HOST=""

if [ "$INGRESS" = "true" ]; then
  echo
  read -p "Hostname: " HOST

  if [ -z "$HOST" ]; then
    echo "Hostname is required when ingress is enabled"
    exit 1
  fi
fi

echo
read -p "Enable monitoring? (true/false) [true]: " MONITORING
MONITORING=${MONITORING:-true}

echo
read -p "Enable secrets? (true/false) [true]: " SECRETS
SECRETS=${SECRETS:-true}

echo
echo "Generating platform service..."

make platform-new-service \
  APP_NAME="$APP_NAME" \
  TEMPLATE="$TEMPLATE" \
  PORT="$PORT" \
  REGISTRY="$REGISTRY" \
  INGRESS="$INGRESS" \
  HOST="$HOST" \
  MONITORING="$MONITORING" \
  SECRETS="$SECRETS"

echo
echo "Done."
