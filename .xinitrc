#!/usr/bin/env sh

model="$(cat /sys/devices/virtual/dmi/id/product_version)"

if [ "$model" = "ThinkPad X240" ]; then
	xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" -0.4
	xinput set-prop "Synaptics TM3075-008" "Synaptics Finger" 0 0 0
	xinput set-prop "Synaptics TM3075-008" "Device Accel Constant Deceleration" "2.75"

	xmodmap -e "keycode 118 = End"

elif [ "$model" = "ThinkPad X230" ]; then
	xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 0
fi




while true; do
	exec $2 2> /dev/null
done



