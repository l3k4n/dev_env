#!/bin/bash

# Check if playerctl can return a status (i.e., a player is active)
if playerctl status &> /dev/null; then
    echo -n "{\"text\": \"$(playerctl metadata title)\", \"alt\": \"$(playerctl status)\"}" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/\\/\\\\/g' | cat
fi
