# 🦎 Komodo Docker Setup

This repository provides a Docker Compose-based deployment for [Komodo](https://github.com/mbecker20/komodo), including:

- MongoDB (data backend)
- Komodo Core (main server)
- Komodo Periphery (monitoring & control)

It also includes utility scripts for **automated backup**, **restore**, and **full uninstallation**.

---

## 📦 Requirements

- Docker + Docker Compose
- Bash shell (Linux/macOS or WSL)
- Optional: systemd for service management

---

## ⚙️ Installation

```bash
git clone https://github.com/youruser/komodo-docker.git
cd komodo-docker
chmod +x install.sh
./install.sh
```

This sets up the environment and installs Komodo as a systemd service (optional).

---

## 🚀 Start Services

```bash
docker-compose up -d
```

Access Komodo Core UI via:

- `http://localhost:9120` (or your host IP)

---

## 💾 Backup

To create a full backup (MongoDB data + Docker volumes):

```bash
./backup.sh
```

Backups are stored in a folder like `komodo_backup_20250610_153000/`.

---

## ♻️ Restore

To restore from a backup:

```bash
./restore.sh komodo_backup_YYYYMMDD_HHMMSS
```

Make sure the services are down before restore.

---

## 🧹 Uninstall

To remove all containers, volumes, and systemd service (if installed):

```bash
./uninstall.sh
```

This will delete:
- Komodo containers
- All Docker volumes used by the app
- `komodo.service` if installed
- Project files (`.env`, compose file, and scripts)

---

## 📁 Project Structure

```
.
├── docker-compose.yml         # Komodo and Mongo services
├── .env                       # Komodo config variables
├── install.sh                 # Setup installer
├── backup.sh                  # Backup script
├── restore.sh                 # Restore script
├── uninstall.sh               # Full cleanup
├── komodo.service             # Optional systemd unit
└── README.md                  # This documentation
```

---

## 🔐 Configuration

Edit `.env` to modify credentials, poll intervals, OAuth settings, and Komodo behavior.

---

## 🔗 Resources

- [Komodo GitHub](https://github.com/mbecker20/komodo)
- [MongoDB Docs](https://www.mongodb.com/docs/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## 🛠 Credits

Maintained by [bengbeng](https://github.com/bucky-grappler). Contributions welcome!