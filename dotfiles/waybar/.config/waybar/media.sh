#!/bin/bash

# Check if playerctl can return a status (i.e., a player is active)
if playerctl status &> /dev/null; then
    printf "{\"text\": \"$(playerctl metadata title)\", \"alt\": \"$(playerctl status)\"}"
fi
