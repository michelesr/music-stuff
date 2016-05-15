#!/bin/bash

### configuration
## set jack to use rt features
# jack_control eps realtime true
## set alsa driver
# jack_control ds alsa
# jack_control dps device hw:0
# jack_control dps rate 44100
# jack_control dps nperiods 2
# jack_control dps period 256
### end of config

echo "Starting JACK"
jack_control start

echo "Setting realtime priority to JACK"
sudo schedtool -R -p 20 `pidof jackdbus`

echo "Starting clients"
/usr/bin/a2jmidid -e &
qjackctl &
qsampler ~/Projects/Audio/ls_piano_session.lscp &
calfjackhost --load ~/Projects/Audio/calf_session.xml &
zynaddsubfx -l ~/Projects/Audio/zynaddsubfx_session.xmz &

echo "Setting ALSA output volume to 100%"
pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 100%

sleep 5

echo "Restoring client connections"
aj-snapshot -r ~/Projects/Audio/aj_snapshot.xml
