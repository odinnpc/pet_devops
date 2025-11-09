#!/bin/bash

# Path to your Nginx log file
LOG_FILE="access.log"

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
echo

echo "Top 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
echo

echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
echo

echo "Top 5 user agents:"
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
echo
