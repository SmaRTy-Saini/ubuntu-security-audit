#!/bin/bash
# Ubuntu Security Audit Script - Hacker Style
# Author: SmaRTy Saini Corp
# License: MIT

# Color codes
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Typing simulation
type_out() {
    text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep 0.01
    done
    echo
}

clear
echo -e "${CYAN}"
cat << "EOF"
   _____       _        _         _           _       
  / ____|     (_)      | |       | |         (_)      
 | (___  _ __  _  ___  | |_ ___  | |     __ _ _  ___  
  \___ \| '_ \| |/ _ \ | __/ _ \ | |    / _\` | |/ _ \ 
  ____) | |_) | |  __/ | ||  __/ | |___| (_| | | (_) |
 |_____/| .__/|_|\___|  \__\___| |______\__,_|_|\___/ 
        | |                                           
        |_|        by SmaRTy Saini Corp
EOF
echo -e "${NC}"

type_out "${GREEN}=== Ubuntu Security Audit Script Starting ===${NC}"
echo -e "${CYAN}Date: $(date)"
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo -e "${NC}"

# 1. Security Updates
type_out "${YELLOW}>>> Checking for security updates...${NC}"
sleep 0.5
sudo apt update -qq
sudo unattended-upgrade --dry-run -d | grep -i "security"

# 2. Firewall Status
echo
type_out "${YELLOW}>>> Checking UFW firewall status...${NC}"
sleep 0.5
sudo ufw status verbose

# 3. Open Ports
echo
type_out "${YELLOW}>>> Listing open ports...${NC}"
sleep 0.5
sudo ss -tuln

# 4. chkrootkit
echo
type_out "${YELLOW}>>> Checking for rootkits with chkrootkit...${NC}"
if ! command -v chkrootkit &> /dev/null; then
    echo -e "${RED}chkrootkit not found. Installing...${NC}"
    sudo apt install -y chkrootkit
fi
sleep 0.5
sudo chkrootkit

# 5. rkhunter
echo
type_out "${YELLOW}>>> Running rkhunter scan...${NC}"
if ! command -v rkhunter &> /dev/null; then
    echo -e "${RED}rkhunter not found. Installing...${NC}"
    sudo apt install -y rkhunter
fi
sleep 0.5
sudo rkhunter --update
sudo rkhunter --check --sk

# 6. Active Services
echo
type_out "${YELLOW}>>> Listing active services...${NC}"
sleep 0.5
systemctl list-units --type=service --state=running

echo
type_out "${GREEN}=== Audit Complete. Stay Safe! ===${NC}"
