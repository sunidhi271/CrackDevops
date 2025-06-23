#!/bin/bash

# Log file to store results
log_file="/path/to/logfile.log"

# Get current CPU usage as a percentage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
# Get current memory usage as a percentage
mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Set the threshold for CPU and memory usage
cpu_threshold=80
mem_threshold=80

# Check if CPU usage is greater than the threshold
if (( $(echo "$cpu_usage > $cpu_threshold" | bc -l) )); then
    echo "$(date) - High CPU Usage: ${cpu_usage}% (Threshold: ${cpu_threshold}%)" >> "$log_file"
fi

# Check if memory usage is greater than the threshold
if (( $(echo "$mem_usage > $mem_threshold" | bc -l) )); then
    echo "$(date) - High Memory Usage: ${mem_usage}% (Threshold: ${mem_threshold}%)" >> "$log_file"
fi
