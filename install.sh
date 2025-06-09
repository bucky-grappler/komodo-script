#!/bin/bash
set -e

# clean previous Komodo installation (optional wipe)

# Ensure Docker and Docker Compose
if ! command -v docker &> /dev/null; then
  echo "[!] Docker not found. Please install Docker first."
  exit 1
fi

if ! command -v docker-compose &> /dev/null; then
  echo "[!] Docker Compose not found. Installing..."
  curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

if  [ -f /etc/systemd/system/komodo.service ]; then
  sudo systemctl stop komodo
  sudo systemctl disable komodo
  sudo rm -f /etc/systemd/system/komodo.service
fi



if [ -f  /srv/komodo/docker-compose.yml ]; then
  sudo docker-compose -f /srv/komodo/docker-compose.yml down -v
fi


sudo docker system prune -af
sudo rm -rf /srv/komodo

echo "[*] Installing Komodo Docker Stack..."



# Create install directory


# Copy utility scripts
#cp komodo-backup.sh komodo-restore.sh /opt/komodo/
#chmod +x /opt/komodo/*.sh




# Update system and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker-compose ufw git

# Add user to Docker group (optional)
sudo usermod -aG docker $USER


# Enable UFW and allow only SSH
sudo ufw allow OpenSSH
sudo ufw enable

# Step Launch Komodo Core stack

mkdir -p /srv/komodo
cp $(realpath docker-compose.yml) $(realpath .env) $(realpath uninstall.sh) $(realpath backup.sh) $(realpath restore.sh) /srv/komodo/
cp $(realpath komodo.service /etc/systemd/system/komodo.service)
cd /srv/komodo
sudo docker-compose pull
sudo docker-compose up -d


# Step Enable and start the service
# sudo systemctl daemon-reexec
# sudo systemctl daemon-reload
# sudo systemctl enable komodo
# sudo systemctl start komodo

# Install systemd service
# cp komodo.service /etc/systemd/system/komodo.service
systemctl daemon-reexec
systemctl enable komodo.service
systemctl start komodo.service

# Step 11: Access Komodo UI from your Netbird-connected machine: