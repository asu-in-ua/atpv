#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

CONFIG=${1:-config.env}

echo "Loading configuration"
source "$CONFIG"

echo "Updating system"
sudo apt update

echo "Installing required packages"
sudo apt install -y curl

echo "Installing Docker if needed"
if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com | sh
fi

sudo systemctl enable docker
sudo systemctl start docker

echo "Waiting for Docker daemon"
until sudo docker info >/dev/null 2>&1
do
    sleep 1
done

echo "Installing docker compose plugin if needed"
if ! sudo docker compose version &> /dev/null
then
    sudo apt install -y docker-compose-plugin
fi

echo "Adding user to docker group"
sudo usermod -aG docker "$USER" || true

echo "Creating data directories"
sudo mkdir -p "$DATA_DIR/nodered-data"
sudo mkdir -p "$DATA_DIR/postgres-data"
sudo mkdir -p "$DATA_DIR/portainer-data"

# Postgres працює від користувача postgres
sudo chown -R 999:999 $DATA_DIR/postgres-data
# Node-RED працює від користувача node-red (uid 1000)
sudo chown -R 1000:1000 $DATA_DIR/nodered-data
# Portainer працює від root
sudo chown -R 0:0 $DATA_DIR/portainer-data

echo "Generating Node-RED password hash"
HASH=$(sudo docker run --rm --entrypoint node nodered/node-red:4.1.1 \
-e "console.log(require('bcryptjs').hashSync(process.argv[1],8))" \
"$NODERED_PASSWORD")

echo "Preparing settings.js"
sed \
-e "s|__NODERED_USER__|$NODERED_USER|g" \
-e "s|__NODERED_PASSWORD_HASH__|$HASH|g" \
-e "s|__NODERED_CREDENTIAL_SECRET__|$NODERED_CREDENTIAL_SECRET|g" \
nodered/settings.js.template \
> "$DATA_DIR/nodered-data/settings.js"

echo "Copying Node-RED flows"
cp nodered/flows.json "$DATA_DIR/nodered-data/" || true
cp nodered/flows_cred.json "$DATA_DIR/nodered-data/" || true

echo "Starting containers"
sudo docker compose --env-file "$CONFIG" up -d --build

echo "Installation completed"
echo "Waiting for containers to start..."
sleep 5

sudo docker ps
echo "Node-RED:  http://$(hostname -I | awk '{print $1}'):1881"
echo "Adminer:   http://$(hostname -I | awk '{print $1}'):8080"
echo "Portainer: http://$(hostname -I | awk '{print $1}'):9000"