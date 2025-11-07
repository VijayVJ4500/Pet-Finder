

LOG_FILE="/app/logs/backend.log"           # Path to the backend log
ALERT_FILE="/app/logs/alerts.log"         # File to store alert messages
ERROR_THRESHOLD=5                          # Max allowed errors per interval
CHECK_INTERVAL=60                          # Interval in seconds to check logs
ROTATE_INTERVAL=7                          # Number of log rotations to keep

ROTATED_LOG_DIR="/app/logs/rotated"       # Directory for rotated logs
mkdir -p "$ROTATED_LOG_DIR"


rotate_logs() {
    timestamp=$(date +"%Y%m%d%H%M%S")
    if [ -f "$LOG_FILE" ]; then
        mv "$LOG_FILE" "$ROTATED_LOG_DIR/backend_$timestamp.log"
        touch "$LOG_FILE"
        echo "$(date) - Rotated logs" >> "$ALERT_FILE"
        
        # Delete old rotated logs beyond ROTATE_INTERVAL
        ls -1t "$ROTATED_LOG_DIR" | tail -n +$((ROTATE_INTERVAL+1)) | while read oldfile; do
            rm -f "$ROTATED_LOG_DIR/$oldfile"
        done
    fi
}


monitor_logs() {
    # Count number of "500" errors in the last interval
    error_count=$(tail -n 1000 "$LOG_FILE" | grep -c "500")
    
    if [ "$error_count" -ge "$ERROR_THRESHOLD" ]; then
        echo "$(date) - ALERT: High error rate detected! $error_count errors in the last minute." >> "$ALERT_FILE"
    fi
}


while true; do
    monitor_logs
    rotate_logs
    sleep "$CHECK_INTERVAL"
done
