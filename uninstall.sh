#!/bin/bash

echo "[*] Stopping Komodo containers..."
docker-compose down --volumes --remove-orphans

echo "[*] Removing Docker volumes..."
docker volume rm mongo-data mongo-config repo-cache ssl-certs repos stacks 2>/dev/null

echo "[*] Removing unused Docker volumes..."
docker volume prune -f

echo "[*] Removing Komodo systemd service (if any)..."
if [ -f /etc/systemd/system/komodo.service ]; then
  sudo systemctl stop komodo
  sudo systemctl disable komodo
  sudo rm /etc/systemd/system/komodo.service
  sudo systemctl daemon-reexec
  sudo systemctl daemon-reload
  echo "[+] Removed komodo.service"
fi

echo "[*] Cleaning up environment files and scripts..."
rm -rf /srv

echo "[+] Komodo environment fully removed."
