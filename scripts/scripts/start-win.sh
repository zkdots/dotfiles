#!/bin/bash

# 1. Start the VM
virsh --connect qemu:///system start win11-dev

# 2. Wait for the RDP service to wake up (5-8 seconds is usually the sweet spot)
echo "Waking up the 9800X3D... waiting for RDP service."
sleep 6

# 3. Connect directly to your specific profile
# Note: Remmina often uses the full path to the .remmina file
remmina -c $HOME/.local/share/remmina/group_rdp_windows-dev_192-168-122-128.remmina &

# 4. Detach from terminal so closing the terminal doesn't kill the VM window
disown
