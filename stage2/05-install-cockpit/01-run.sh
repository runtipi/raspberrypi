#!/bin/bash -e 

# Add 45 drives gpg key and repository (commands from 45drives install script)

wget -qO - https://repo.45drives.com/key/gpg.asc | gpg --pinentry-mode loopback --batch --yes --dearmor -o "${ROOTFS_DIR}/usr/share/keyrings/45drives-archive-keyring.gpg"
curl -sSL https://repo.45drives.com/lists/45drives.sources -o "${ROOTFS_DIR}/etc/apt/sources.list.d/45drives.sources"

# Update apt cache

on_chroot << EOF
apt update
EOF

# Install cockpit modules

on_chroot << EOF
apt install cockpit-file-sharing cockpit-navigator cockpit-identities
EOF 

