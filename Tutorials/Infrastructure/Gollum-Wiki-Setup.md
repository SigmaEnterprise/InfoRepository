---

# Gollum: A Practical, Production-Ready Guide

*A lightweight, self-hosted wiki powered by Git.*

> **What is Gollum?**
> Gollum is a lightweight, self-hosted wiki that uses a Git repository as its backend. Every page is a normal text file (Markdown, AsciiDoc, etc.), and every edit becomes a Git commit. That gives you **versioning**, **history**, **rollback**, **branching**, and the freedom to store or mirror your data anywhere Git can live.

---

## Table of Contents

* [Overview](#overview)
* [Installing Gollum](#installing-gollum)

  * [Docker / Docker Compose](#docker--docker-compose)
  * [Manual Installation (Linux)](#manual-installation-linux)
* [Reverse Proxy with Nginx](#reverse-proxy-with-nginx)

  * [HTTP Reverse Proxy](#http-reverse-proxy)
  * [Enable HTTPS with Certbot](#enable-https-with-certbot)
* [Logging & Debugging](#logging--debugging)
* [Backup & Restore](#backup--restore)

  * [File-Based Backups](#file-based-backups)
  * [Automated Backups (cron)](#automated-backups-cron)
* [Updating & Upgrading](#updating--upgrading)

  * [Docker Updates](#docker-updates)
  * [Manual Updates (gem)](#manual-updates-gem)
* [Features & Advanced Options](#features--advanced-options)

  * [Enable API / Uploads](#enable-api--uploads)
  * [Custom CSS / Branding](#custom-css--branding)
* [Why Git Matters](#why-git-matters)
* [Wrapping Up](#wrapping-up)

---

## Overview

Gollum lets you create, update, and manage Markdown-based wikis with full customization and control. Because it rides on Git:

* Every change is versioned.
* You can branch, merge, and review.
* You can host anywhere (local, self-hosted Git, GitHub/Gitea, or even decentralized mirrors).

---

## Installing Gollum

### Docker / Docker Compose

**Docker** keeps dependencies tidy and upgrades simple.

**1) Create `docker-compose.yml`:**

```yaml
version: "3.8"

services:
  gollum:
    image: gollum/ruby:latest
    container_name: gollum
    ports:
      - "4567:4567"
    volumes:
      - ./wiki:/wiki
    working_dir: /wiki
    command: gollum --port 4567
```

This maps your local `./wiki` directory to `/wiki` inside the container and exposes Gollum on port **4567**.

**2) Start it:**

```bash
docker-compose up -d
```

Access: `http://<server-ip>:4567`

**3) Check status:**

```bash
docker ps
```

---

### Manual Installation (Linux)

If you prefer running Gollum directly on the host:

```bash
sudo apt update
sudo apt install -y ruby-full build-essential git
gem install gollum

mkdir -p ~/wiki
cd ~/wiki
git init

gollum --port 4567
```

Access: `http://<server-ip>:4567`

---

## Reverse Proxy with Nginx

### HTTP Reverse Proxy

Serve Gollum under a friendly domain and keep port 80/443 at the edge.

**Create config:**

```bash
sudo nano /etc/nginx/sites-available/gollum
```

**Paste:**

```nginx
server {
    listen 80;
    server_name wiki.example.com;

    location / {
        proxy_pass http://localhost:4567;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Enable & reload:**

```bash
sudo ln -s /etc/nginx/sites-available/gollum /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

> Replace `wiki.example.com` with your domain and ensure DNS points to your server.

---

### Enable HTTPS with Certbot

Secure your wiki with free Let’s Encrypt TLS.

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d wiki.example.com
```

**Dry-run renewals:**

```bash
sudo certbot renew --dry-run
```

---

## Logging & Debugging

**Verbose Gollum logs (manual run):**

```bash
gollum --verbose --port 4567
```

**Docker logs:**

```bash
docker logs gollum
```

**Quick checks:**

```bash
# Is Gollum responding?
curl -I http://localhost:4567

# Nginx config sanity
sudo nginx -t
```

**Directory permissions:**

```bash
ls -ld ~/wiki
```

---

## Backup & Restore

### File-Based Backups

Because your wiki *is a Git repo*, backups are simple.

**Archive the repo:**

```bash
tar -czvf ~/wiki-backup.tar.gz ~/wiki
```

**Restore:**

```bash
tar -xzvf ~/wiki-backup.tar.gz -C ~/
```

> You can also push to a remote Git mirror for offsite backups.

### Automated Backups (cron)

**Create script `backup_gollum.sh`:**

```bash
#!/bin/bash
tar -czvf ~/wiki-backup-$(date +%Y%m%d).tar.gz ~/wiki
```

**Make executable & schedule:**

```bash
chmod +x ~/backup_gollum.sh
crontab -e
```

**Cron entry (daily at midnight):**

```
0 0 * * * /home/<user>/backup_gollum.sh
```

---

## Updating & Upgrading

### Docker Updates

```bash
docker pull gollum/ruby:latest
docker-compose down
docker-compose up -d
```

### Manual Updates (gem)

```bash
gem update gollum
gollum --version
```

Compare with the latest release on the Gollum GitHub page.

---

## Features & Advanced Options

### Enable API / Uploads

Start Gollum with uploads enabled (handy for images/files):

```bash
gollum --port 4567 --allow-uploads dir
```

**Example upload via curl (if you expose a route):**

```bash
curl -X POST -F "file=@example.md" http://localhost:4567/upload
```

> Note: Gollum’s core focuses on wiki editing; file uploads are stored in the repo (or `uploads/` depending on mode). Adjust to your needs.

### Custom CSS / Branding

Use your **`custom.css`** to theme the wiki:

```bash
# If using CLI flags
gollum --css

# Or via config.rb (recommended)
# css: true and commit a file named 'custom.css' at the repo root
```

You can also add a `custom.header` (HTML fragment) for a logo/brand banner and commit assets under `public/` (e.g., `public/assets/logo.png`).

---

## Why Git Matters

Git gives Gollum superpowers:

* **Change history** for every page.
* **Branching & merging** for experiments or draft spaces.
* **Offline-first** edits: clone, edit, commit, push.
* **Portability**: move your wiki between hosts, or mirror to multiple remotes.
* **Freedom**: You’re not tied to any single SaaS or platform.

---

## Wrapping Up

Self-hosting Gollum gives you **full control** and **developer-grade workflows**. With Docker or a manual Ruby install, an Nginx reverse proxy, and Let’s Encrypt TLS, you’ll have a clean, secure, and fast wiki that feels like a private GitHub Wiki—but entirely under your control.

Start with the Docker Compose above, add your **custom.css** for branding, and you’ve got a robust, production-ready knowledge base.

---

### Quick Links (Handy Commands)

```bash
# Start (Docker)
docker-compose up -d

# Start (manual)
gollum --port 4567

# Nginx test & reload
sudo nginx -t && sudo systemctl reload nginx

# Check version
gollum --version
```



---

