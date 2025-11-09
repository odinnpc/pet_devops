#!/usr/bin/env bash
# server-stats.sh
# Quick, portable server performance summary for Linux.
# Gives: total CPU usage, memory usage, disk usage, top 5 CPU procs, top 5 MEM procs.
# Stretch: OS info, uptime, load average, logged in users, failed login attempts (best-effort).

set -u

bold() { printf "\e[1m%s\e[0m\n" "$1"; }
sep()  { printf '%*s\n' 60 '' | tr ' ' -; }

# ---- CPU usage (%) computed from /proc/stat over 1s ----
cpu_usage() {
  if [[ -r /proc/stat ]]; then
    read -r _ user nice system idle iowait irq softirq steal guest < /proc/stat
    prev_total=$((user+nice+system+idle+iowait+irq+softirq+steal+guest))
    prev_idle=$((idle + iowait))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal guest < /proc/stat
    total=$((user+nice+system+idle+iowait+irq+softirq+steal+guest))
    idle2=$((idle + iowait))

    total_diff=$((total - prev_total))
    idle_diff=$((idle2 - prev_idle))

    if (( total_diff > 0 )); then
      # use awk for floating math
      cpu_percent=$(awk -v t="$total_diff" -v i="$idle_diff" 'BEGIN { printf "%.1f", (1 - i/t) * 100 }')
    else
      cpu_percent="0.0"
    fi

    printf "%s\n" "$cpu_percent"
  else
    echo "N/A"
  fi
}

# ---- Memory usage ----
mem_usage() {
  # Prefer 'free' because it's almost everywhere
  if command -v free >/dev/null 2>&1; then
    # show human-friendly and percentages
    free -h | awk 'NR==1{print $0} NR==2{printf "Memory: Used: %s / Total: %s (%.1f%%)\n", $3, $2, ($3/$2)*100}'
  elif [[ -r /proc/meminfo ]]; then
    # fallback quick parse
    mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    mem_free=$(awk '/MemFree/ {print $2}' /proc/meminfo)
    mem_avail=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
    mem_used=$((mem_total - mem_avail))
    perc=$(awk -v u="$mem_used" -v t="$mem_total" 'BEGIN{printf "%.1f", (u/t)*100}')
    printf "Memory: Used: %s KB / Total: %s KB (%s%%)\n" "$mem_used" "$mem_total" "$perc"
  else
    echo "Memory: N/A"
  fi
}

# ---- Disk usage ----
disk_usage() {
  # Show mounted root filesystems and overall
  df -h --total 2>/dev/null | awk 'NR==1{print $0} /\/$/ || /total/ {print}'
  # If df doesn't support --total, show df -h top lines
}

# ---- Top processes ----
top_procs() {
  echo "Top 5 processes by CPU:"
  # ps is portable. Show PID, %CPU, %MEM, RSS, COMMAND
  ps aux --no-heading --sort=-%cpu 2>/dev/null | head -n5 | awk '{printf "%-8s %-6s %-6s %-8s %s\n",$2,$3,$4,$6,$11}'
  echo
  echo "Top 5 processes by Memory:"
  ps aux --no-heading --sort=-%mem 2>/dev/null | head -n5 | awk '{printf "%-8s %-6s %-6s %-8s %s\n",$2,$3,$4,$6,$11}'
}

# ---- Stretch stats ----
stretch_stats() {
  echo
  bold "Stretch / extra quick facts"
  if command -v lsb_release >/dev/null 2>&1; then
    lsb_release -a 2>/dev/null
  else
    uname -srmo
  fi

  echo -n "Uptime: "
  if command -v uptime >/dev/null 2>&1; then
    uptime -p 2>/dev/null || uptime
  else
    awk '{print int($1/86400)"d "int(($1%86400)/3600)"h "int(($1%3600)/60)"m"}' /proc/uptime
  fi

  echo -n "Load average: "
  awk '{printf "%.2f %.2f %.2f\n", $1, $2, $3}' /proc/loadavg

  echo -n "Logged-in users: "
  who | awk '{print $1}' | sort -u | xargs -r echo || echo "none"

  # Best-effort failed login attempts in last 24h (may need elevated perms)
  echo
  echo "Failed login attempts (last 24h) — best-effort:"
  if [[ -r /var/log/auth.log ]]; then
    grep -i "failed" /var/log/auth.log | tail -n 20 || echo "No matches"
  elif [[ -r /var/log/secure ]]; then
    grep -i "failed" /var/log/secure | tail -n 20 || echo "No matches"
  elif command -v journalctl >/dev/null 2>&1; then
    journalctl _SYSTEMD_UNIT=sshd.service -o short-iso --since "24 hours ago" 2>/dev/null | grep -i "failed" | tail -n 20 || echo "No matches"
  else
    echo "Cannot access auth logs on this system (permission or file not present)."
  fi
}

# ---- Main output ----
bold "Server performance summary"
sep

# CPU
cpu_pct=$(cpu_usage)
printf "Total CPU usage: %s%%\n" "$cpu_pct"

sep
# Memory
bold "Memory"
mem_usage

sep
# Disk
bold "Disk usage"
disk_usage

sep
# Top processes
bold "Processes"
top_procs

sep
stretch_stats

# End
sep
printf "Script runtime: %s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
