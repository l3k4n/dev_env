PERCENTAGE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')
STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')

if [ $STATE = "pending-charge" ]; then
  echo "⚡"$PERCENTAGE [battery]
elif [ $STATE = "charging" ]; then
  echo "⚡"$PERCENTAGE [battery]
else
  echo $PERCENTAGE [battery]
fi

