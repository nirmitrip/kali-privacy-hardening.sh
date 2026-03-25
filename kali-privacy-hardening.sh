#!/bin/bash

# ==========================================
# Kali Linux Privacy Hardening Script
# Based on DIY Linux Privacy Hardening Manual
# Adapted ONLY for Kali Linux
# Author: Nirmit
# ==========================================

clear

echo "Kali Privacy Hardening Script"
echo "This script is ONLY for Kali Linux"
echo

# ---------- Check Kali ----------

if ! grep -qi kali /etc/os-release; then
    echo "This script is only for Kali Linux"
    exit 1
fi

echo "Kali detected"
echo

# ---------- Function ----------

ask() {
    read -p "$1 (y/n): " ans
    [[ $ans == y || $ans == Y ]]
}

# ==========================================
# Step 1 - Firewall
# ==========================================

if ask "Setup UFW firewall?"; then

    sudo apt install ufw -y

    sudo ufw --force reset
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    sudo ufw allow 22/tcp
    sudo ufw allow out 53
    sudo ufw allow out 80
    sudo ufw allow out 443
    sudo ufw allow out 123

    sudo ufw --force enable

fi


# ==========================================
# Step 2 - DNS hardening (Kali adapted)
# ==========================================

if ask "Apply DNS hardening?"; then

    sudo chattr -i /etc/resolv.conf 2>/dev/null
    sudo rm -f /etc/resolv.conf

    echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
    echo "nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf
    echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

    sudo chattr +i /etc/resolv.conf

fi


# ==========================================
# Step 3 - Firefox hardening
# ==========================================

if ask "Harden Firefox profile?"; then

    PROFILE=$(ls ~/.mozilla/firefox | grep default | head -n1)

    USERJS=~/.mozilla/firefox/$PROFILE/user.js

    echo "Creating user.js in $PROFILE"

    cat > $USERJS <<EOF

// Privacy settings

user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);

user_pref("geo.enabled", false);
user_pref("dom.webnotifications.enabled", false);
user_pref("media.navigator.enabled", false);

user_pref("network.cookie.cookieBehavior", 1);

user_pref("webgl.disabled", true);
user_pref("dom.webaudio.enabled", false);

user_pref("beacon.enabled", false);

user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);

user_pref("toolkit.telemetry.enabled", false);

EOF

fi


# ==========================================
# Step 4 - Metadata tools
# ==========================================

if ask "Install metadata cleaning tools?"; then

    sudo apt install exiftool mat2 -y

fi


# ==========================================
# Step 5 - Firejail
# ==========================================

if ask "Install Firejail sandbox?"; then

    sudo apt install firejail firejail-profiles -y
    sudo firecfg

    sudo bash -c 'cat > /etc/firejail/browser-common.local <<EOF
caps.drop all
netfilter
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
private-cache
private-dev
private-tmp
disable-mnt
noexec /tmp
EOF'

fi


# ==========================================
# Step 6 - Sysctl hardening
# ==========================================

if ask "Apply kernel hardening?"; then

    sudo bash -c 'cat > /etc/sysctl.d/99-privacy.conf <<EOF

net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

net.ipv4.conf.all.log_martians = 1
net.ipv4.tcp_syncookies = 1

kernel.randomize_va_space = 2
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1

kernel.unprivileged_bpf_disabled = 1
net.core.bpf_jit_harden = 2

fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.suid_dumpable = 0

EOF'

    sudo sysctl -p /etc/sysctl.d/99-privacy.conf

fi


# ==========================================
# Step 7 - Disable services
# ==========================================

if ask "Disable unnecessary services?"; then

    sudo systemctl disable bluetooth 2>/dev/null
    sudo systemctl disable avahi-daemon 2>/dev/null
    sudo systemctl disable apache2 2>/dev/null
    sudo systemctl disable mariadb 2>/dev/null

fi


# ==========================================
# Audit
# ==========================================

echo
echo "Audit result"
echo

sudo ufw status
cat /etc/resolv.conf
sysctl kernel.randomize_va_space
firejail --list

echo
echo "Done"
