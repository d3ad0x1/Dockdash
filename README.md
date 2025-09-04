# 🐳 Dockdash

A colorful **terminal dashboard** for managing Docker containers.  
Built in pure **Bash**, lightweight, and works anywhere Docker does.  

---

## ✨ Features
- 📋 **Container overview**
  - Name
  - Status (active / stopped)
  - Image (trimmed if too long)
  - Ports
- 🔄 **Auto-refresh** every 5 seconds
- 🖥️ **Interactive management menu**
  - Restart
  - Start
  - Stop
  - View logs (last 30 lines)
  - Open interactive bash shell inside container
- ⌨️ **Simple navigation**
  - Enter container number → open management menu
  - `q` → quit
  - `r` → refresh list
  - `b` → back to container list

---

## 🚀 Installation & Usage
Clone the repository and run the script:

```bash
git clone https://github.com/d3ad0x1/dockdash.git
cd dockdash
chmod +x dockdash.sh
./dockdash.sh
```

---

## 📌 Requirements

  - Linux / macOS
  - [Docker](https://www.docker.com/) installed & running
  - Bash 4+

## 📷 Preview

```bash
=== Docker Container Manager ===
(refreshes every 5 seconds)

 No | Name                 | Status     | Image                          | Ports
-------------------------------------------------------------------------------------
  1 | web-server           | active     | nginx:latest                   | 8080
  2 | db-postgres          | active     | postgres:14                    | 5432
  3 | redis-cache          | stopped    | redis:alpine                   | N/A
  4 | test-app             | active     | myregistry.local/test:1.2.3    | 3000,3001

Enter the container number to manage
or q to quit, r to refresh:
```

## 💡 Why Dockdash?

Because sometimes you just want a lightweight, colorful, interactive Docker manager
without heavy GUI tools. Dockdash is a single Bash script that works anywhere you have Docker.

## 🔖 GitHub Topics
![docker](https://img.shields.io/badge/topic-docker-blue?logo=docker)
![bash](https://img.shields.io/badge/topic-bash-green?logo=gnu-bash)
![tui](https://img.shields.io/badge/topic-tui-orange)
![cli](https://img.shields.io/badge/topic-cli-lightgrey)
![docker-manager](https://img.shields.io/badge/topic-docker--manager-blueviolet)
![docker-tools](https://img.shields.io/badge/topic-docker--tools-success)
![sysadmin](https://img.shields.io/badge/topic-sysadmin-informational)
![devops](https://img.shields.io/badge/topic-devops-critical)

## 📄 License

This project is licensed under the [MIT License](LICENSE).