#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./komodo_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "[*] Dumping MongoDB..."
docker exec $(docker-compose ps -q mongo) \
  mongodump --username=admin --password=admin --authenticationDatabase=admin --out=/data/dump

echo "[*] Copying Mongo dump..."
docker cp $(docker-compose ps -q mongo):/data/dump "$BACKUP_DIR/mongodump"

echo "[*] Backing up Docker volumes..."
VOLUMES=(mongo-data mongo-config repo-cache ssl-certs repos stacks komodo periphery)
for VOL in "${VOLUMES[@]}"; do
  docker run --rm -v ${VOL}:/volume -v "$PWD/$BACKUP_DIR":/backup alpine \
    tar -czf /backup/${VOL}.tar.gz -C /volume .
done

echo "[+] Backup completed at $BACKUP_DIR"
