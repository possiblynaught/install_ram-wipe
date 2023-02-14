#!/bin/bash

# Debug
#set -x
set -Eeo pipefail

# Update packages in prep
sudo apt-get update
sudo apt-get full-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y
# Check for/install curl
if ! command -v curl >/dev/null; then
  sudo apt-get install -y --no-install-recommends curl
fi
# Check for/install dracut
if ! command -v dracut >/dev/null; then
  sudo apt-get install -y --no-install-recommends dracut
fi
# Add Kicksecure keys
TEMP_KEY=/tmp/derivative.asc
[ -f "$TEMP_KEY" ] && rm -f "$TEMP_KEY"
curl --tlsv1.3 --proto =https --max-time 180 -o "$TEMP_KEY" https://www.kicksecure.com/keys/derivative.asc
sudo mv "$TEMP_KEY" /usr/share/keyrings/derivative.asc
# Add Kicksecure apt repo
echo "deb [signed-by=/usr/share/keyrings/derivative.asc] https://deb.kicksecure.com bullseye main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list
# Update package lists and install ram-wipe
sudo apt-get update
sudo apt-get install --no-install-recommends -y ram-wipe
