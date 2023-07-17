#!/bin/bash

# Get the current usage of CPU and memory
cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')
memUsage=$(free -m | awk '/Mem/{print $3}')

# Print the usage
echo "CPU Usage: $cpuUsage%"
echo "Memory Usage: $memUsage MB"
df -H
  
exec gcc "$@"
