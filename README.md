# kali-privacy-hardening.sh
Interactive Kali Linux privacy hardening script based on DIY Linux Privacy Hardening Manual (firewall, DNS, Firefox, sysctl, firejail, metadata tools)

# Kali Linux Privacy Hardening Script

This project is an interactive automation script that follows the steps from the DIY Linux Privacy Hardening Manual, adapted specifically for Kali Linux.

The script applies multiple security and privacy hardening configurations including firewall setup, DNS hardening, Firefox privacy settings, kernel hardening, sandboxing, and metadata protection.

⚠️ This script is designed ONLY for Kali Linux.
It may break other distributions.

---

## Features

- UFW firewall configuration
- DNS leak protection (Kali compatible method)
- Firefox privacy hardening using user.js
- Metadata cleaning tools (mat2, exiftool)
- Firejail sandbox setup
- Kernel hardening using sysctl
- Disable unnecessary services
- Interactive prompts before each step
- Final audit output

---

## Why this project?

I created this script while studying Linux privacy hardening and adapting the manual for Kali Linux, since many guides assume Ubuntu or Debian with systemd-resolved.

This script makes the process reproducible and easier for security labs and virtual machines.

---

## Usage
chmod +x kali-privacy-hardening.sh
./kali-privacy-hardening.sh

Run as a normal user with sudo privileges.

---

## Tested on

- Kali Linux Rolling
- Kali VM (VMware)
- GNOME & XFCE

Not tested on:

- Ubuntu
- Debian
- Arch
- Parrot

---

## Warning

This script modifies system configuration files.

Recommended to use inside:

- Virtual Machine
- Lab environment
- Testing system

Do NOT run on production systems without understanding the changes.

---

## Author

Nirmit  
CyberSecurity professional | Penetration Testing | System Hardening
