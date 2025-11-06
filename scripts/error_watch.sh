#!/bin/bash
#
# error_watch.sh
# Monitors Docker container logs for error patterns
# and triggers alerts if error rate exceeds threshold.

# === Configuration ===
CONTAINER_NAME="petfinder-backend"
LOG_DIR="./logs"                      # <-- changed from /var/log/petfinder
LOG_FILE="$LOG_DIR/petfinder.log"
ALERT_FILE="$LOG_DIR/petfinder.alerts"
THRESHOLD=5                           # Max allowed errors per minute
MAX_LOG_SIZE=1048576                  # 1MB for rotation

# === Setup ===
mkdir -p "$LOG_DIR"
touch "$LOG_FILE" "$ALERT_FILE"

echo "🐳 Monitoring logs for container: $CONTAINER_NAME"
echo "Logs stored at: $LOG_FILE"
echo "Alert threshold: $THRESHOLD errors/minute"
echo "------------------------------------------"

# === Helper function for log rotation ===
rotate_logs() {
  local size
  size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
  if [ "$size" -gt "$MAX_LOG_SIZE" ]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    echo "🌀 Rotating logs... (size: $size bytes)"
    mv "$LOG_FILE" "$LOG_FILE.$ts"
    touch "$LOG_FILE"
  fi
}

# === Monitoring Loop ===
while true; do
  # Get logs from the last minute
  docker logs --since 60s "$CONTAINER_NAME" 2>&1 | tee -a "$LOG_FILE" | grep -iE "error|exception|fail|fatal|500" > /tmp/error_matches.log

  # Count number of errors
  ERROR_COUNT=$(wc -l < /tmp/error_matches.log)

  if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    ALERT_MSG="🚨 ALERT: $ERROR_COUNT errors detected in the last minute for container '$CONTAINER_NAME' at $(date)"
    echo "$ALERT_MSG" | tee -a "$ALERT_FILE"
  fi

  rotate_logs

  # Wait for next cycle
  sleep 60
done
