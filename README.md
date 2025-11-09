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


