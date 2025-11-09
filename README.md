# pet_DevOps
# server-stats

A small, portable Bash script that gathers basic server performance stats:
- Total CPU usage
- Total memory usage (free vs used, with percentage)
- Total disk usage (free vs used, with percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

Stretch stats:
- OS/version info
- Uptime
- Load average
- Logged-in users
- Recent failed login attempts (best-effort; may require root)

## Files
- server-stats.sh — the main script (make executable).

## Quick run (local)
bash
chmod +x server-stats.sh
./server-stats.sh

# Log Archive Tool

A small CLI tool to archive log directories (e.g. `/var/log`) into timestamped `tar.gz` files and record each archive in a log file.

## Features
- Archive a logs directory into `logs_archive_YYYYMMDD_HHMMSS.tar.gz`
- Store archives in a separate directory (default: `<log-dir>/archives`)
- Record each archive action to `archive.log` with timestamp, source dir, archive path and size
- Optional `--keep DAYS` to delete older archives
- `--dry-run` mode to preview actions without making changes

## Files
- `log-archive` — the executable Bash script
- `README.md` — this file
- `.gitignore` — (optional)
- `LICENSE` — MIT

## Usage
Make executable:
bash
chmod +x log-archive


Basic run:
bash
./log-archive /var/log


Specify output directory and keep 30 days of archives:
bash
./log-archive /var/log --out-dir /var/log/archives --keep 30


Dry-run example (no changes):
bash
./log-archive /var/log --dry-run


Crontab example (run daily at 2:10am):
cron
10 2 * * * /path/to/log-archive /var/log --out-dir /var/log/archives --keep 90 >> /var/log/log-archive-cron.log 2>&1


Notes
- If the `--out-dir` is inside the source log directory, the script will exclude it from the archive to avoid recursion.
- The script uses `tar` and `gzip`. It should work on most Linux distributions.
- Archiving `/var/log` usually requires root privileges to read all files; run with `sudo` in that case.
# Nginx Log Analyzer

A simple command-line tool to analyze Nginx access logs and get quick statistics about your server traffic.

## Features

The script provides the following information from an Nginx log file:

* Top 5 IP addresses with the most requests
* Top 5 most requested paths
* Top 5 response status codes
* Top 5 user agents

## Requirements

* Linux or macOS terminal
* Bash shell
* Basic Unix commands: `awk`, `sort`, `uniq`, `head`

## Installation

1. Clone or download this repository.
2. Place your Nginx access log file in the same directory (or update the script path).
3. Make the script executable:

bash
chmod +x nginx_log_analyzer.sh


## Usage

Run the script by passing your log file path:

bash
./nginx_log_analyzer.sh


Or edit the `LOG_FILE` variable inside the script to point to your log file:

bash
LOG_FILE="access.log"


### Example Output


Top 5 IP addresses with the most requests:
178.128.94.113 - 50 requests
142.93.136.176 - 20 requests
138.68.248.85 - 15 requests
159.89.185.30 - 10 requests
45.76.135.253 - 5 requests

Top 5 most requested paths:
/v1-health - 60 requests
/cgi-bin/luci/;stok=/locale - 10 requests
/ - 5 requests
/api/v1/users - 3 requests
/api/v1/orders - 2 requests

Top 5 response status codes:
200 - 70 requests
404 - 10 requests
500 - 3 requests
401 - 2 requests
304 - 1 request

Top 5 user agents:
DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com) - 65 requests
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ... - 5 requests
```

## How It Works

* **IP addresses** – extracted from the first field of the log.
* **Request paths** – extracted from the 7th field.
* **Status codes** – extracted from the 9th field.
* **User agents** – extracted from the 6th quoted field using `awk -F\"`.

All results are sorted in descending order by frequency, showing the top 5 entries.

## Stretch Goals

* Experiment with using `grep` and `sed` instead of `awk` to extract fields.
* Add more statistics like requests per hour, average response size, or referrer analysis.
