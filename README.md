# Homepage dashboard (nigel:3000)

Home lab dashboard, replacing Dashy (nigel:4000). Runs [Homepage](https://gethomepage.dev)
as a Docker container on nigel.

- Start / restart: `sudo sh ~/homepage/run-homepage.sh`
- Config: `config/*.yaml` (Homepage reloads `services.yaml` changes without a restart;
  `settings.yaml`, env vars and secrets need a restart)
- Image pinned to `ghcr.io/gethomepage/homepage:v2.7.0`; bump deliberately.

## Secrets

`secrets.env` (chmod 600, not in git) is loaded with `--env-file` and referenced in the
config as `{{HOMEPAGE_VAR_*}}`:

| Variable | What |
|----------|------|
| `HOMEPAGE_VAR_PVE_TOKEN_ID` / `_SECRET` | Proxmox token `root@pam!dashboard` (PVEAuditor on `/`, read-only) |
| `HOMEPAGE_VAR_HA_TOKEN` | Home Assistant long-lived access token |
| `HOMEPAGE_VAR_PIHOLE1_KEY` | Pi-hole v6 app password, primary (10.0.0.8) |
| `HOMEPAGE_VAR_PIHOLE2_KEY` | Pi-hole v6 app password, backup (10.0.0.9) |
| `HOMEPAGE_VAR_PORTAINER_KEY` | Portainer token (on hold: user `vern` has no environments) |

## Notes

- The container uses the Pi-holes for DNS (`--dns 10.0.0.8/9 --dns-search lan`) so `.lan`
  and short names resolve. `.local` (mDNS) names can't be resolved, so those tiles have no
  status check.
- `HOMEPAGE_ALLOWED_HOSTS` must list every hostname:port used to open the page.
- Grotto (RV) tiles use pi-camper's Tailscale IP (100.86.42.43): nigel doesn't accept
  Tailscale subnet routes, so the camper LAN (10.0.1.x) isn't reachable from here.
- KiwiSDR uses a ping check (its HTTP reply is non-standard and breaks siteMonitor).
- WeatherLink Live is davis.lan = 10.0.0.11 (ping check: it rejects HTTP HEAD with 400). 10.0.0.133 is the Garage Hub switch (nigel's
  ~/hosts.pihole.lan is stale on this).
- Switches group mirrors NETGEAR_SWITCHES in ~/bin/check-connections on the mini.
