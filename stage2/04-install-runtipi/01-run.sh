#!/bin/bash -e

# Install docker

echo "Installing docker..."

on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker ${FIRST_USER_NAME}
EOF

# Make sure the home directory exists

echo "Making runtipi directory..."

mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/"

# Install runtipi

echo "Downloading runtipi cli..."

URL="https://github.com/runtipi/cli/releases/download/v${RUNTIPI_VERSION}/runtipi-cli-linux-aarch64.tar.gz"

curl --location "${URL}" -o "${ROOTFS_DIR}/tmp/runtipi/runtipi-cli-linux-aarch64.tar.gz"
tar -xvf "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli-linux-aarch64.tar.gz" -C "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/"
rm -rf "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli-linux-aarch64.tar.gz"
mv "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli-linux-aarch64" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli"
chmod +x "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli"

echo "Setting permissions..."

on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/runtipi/
EOF

# Enable runtipi on boot 

echo "Install service..."

install -v files/runtipi.service "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

echo "Make tweaks..."

sed -i "s|User=username|User=${FIRST_USER_NAME}|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
sed -i "s|WorkingDirectory=/home/username/runtipi/|WorkingDirectory=/home/${FIRST_USER_NAME}/runtipi/|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
sed -i "s|ExecStart=/home/username/runtipi/runtipi-cli start|ExecStart=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli start|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
sed -i "s|ExecStop=/home/username/runtipi/runtipi-cli stop|ExecStop=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli stop|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

chmod -x "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

echo "Enable runtipi on boot..."

on_chroot << EOF
systemctl enable runtipi
EOF
