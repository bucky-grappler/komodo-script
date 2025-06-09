#!/bin/bash

BACKUP_DIR="$1"
if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: $0 <backup-directory>"
  exit 1
fi

echo "[*] Stopping containers..."
docker-compose down

echo "[*] Restoring Docker volumes..."
VOLUMES=(mongo-data mongo-config repo-cache ssl-certs repos stacks komodo periphery)
for VOL in "${VOLUMES[@]}"; do
  docker volume create ${VOL}
  docker run --rm -v ${VOL}:/volume -v "$PWD/$BACKUP_DIR":/backup alpine \
    sh -c "rm -rf /volume/* && tar -xzf /backup/${VOL}.tar.gz -C /volume"
done

echo "[*] Starting containers..."
docker-compose up -d

echo "[*] Waiting for MongoDB to be ready..."
sleep 10

echo "[*] Restoring Mongo dump..."
docker cp "$BACKUP_DIR/mongodump" $(docker-compose ps -q mongo):/data/dump
docker exec $(docker-compose ps -q mongo) \
  mongorestore --username=admin --password=admin --authenticationDatabase=admin /data/dump

echo "[+] Restore completed from $BACKUP_DIR"
