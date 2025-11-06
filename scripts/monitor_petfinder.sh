#!/bin/bash
# monitor_petfinder.sh
# Monitors /var/log/petfinder.log for error spikes and rotates logs

LOG_FILE="/var/log/petfinder.log"
ALERT_FILE="/var/log/petfinder_alerts.log"
THRESHOLD=5

mkdir -p /var/log

# Ensure log file exists
touch $LOG_FILE

# Function to rotate logs
rotate_logs() {
  if [ $(stat -c%s "$LOG_FILE") -gt 10485760 ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date +%Y%m%d%H%M%S)"
    touch "$LOG_FILE"
    echo "$(date): Log rotated" >> $ALERT_FILE
  fi
}

# Main monitoring loop
while true; do
  ERROR_COUNT=$(grep -c "500" "$LOG_FILE")
  if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    echo "$(date): ALERT - $ERROR_COUNT HTTP 500 errors detected!" >> $ALERT_FILE
  fi
  rotate_logs
  sleep 60
done
