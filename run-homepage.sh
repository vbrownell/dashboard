#!/bin/sh
# Homepage dashboard (replacement for Dashy on :4000). Config: /home/vern/homepage/config
# secrets.env (chmod 600) holds API tokens as HOMEPAGE_VAR_* (Proxmox: root@pam!dashboard, PVEAuditor).
# Pinned version; bump deliberately after checking the release notes.
docker rm -f homepage 2>/dev/null || true
docker run -d --name homepage \
  --restart unless-stopped \
  -p 3000:3000 \
  --dns 10.0.0.8 --dns 10.0.0.9 --dns-search lan \
  -e HOMEPAGE_ALLOWED_HOSTS=nigel:3000,nigel.lan:3000,10.0.0.5:3000,100.97.193.23:3000,localhost:3000 \
  -e PUID=1000 -e PGID=1000 \
  --env-file /home/vern/homepage/secrets.env \
  -v /home/vern/homepage/config:/app/config \
  ghcr.io/gethomepage/homepage:v2.7.0
