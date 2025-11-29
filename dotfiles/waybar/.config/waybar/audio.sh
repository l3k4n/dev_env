#!/bin/bash

bluetoothctl info | awk -F': ' '
/Name:/ {name=$2}
/Battery Percentage:/ {gsub(/.*\(|\).*/, "", $2); battery=$2}
END {
    if (name && battery)
        printf "{\"text\": \"%s %s%%\"}\n", name, battery
    else
        printf ""
}'
