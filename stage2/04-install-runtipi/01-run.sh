#!/bin/bash -e

# Set environment variables

URL="https://github.com/runtipi/cli/releases/download/${RUNTIPI_VERSION}/runtipi-cli-linux-aarch64.tar.gz"
TAR_PATH="${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli-linux-aarch64.tar.gz"
RUNTIPI_PATH="${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi"

# Install docker

echo "Installing docker..."

on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker ${FIRST_USER_NAME}
EOF

# Make sure the home directory exists

echo "Making runtipi directory..."

mkdir -p "${RUNTIPI_PATH}/"

# Install runtipi

echo "Downloading runtipi cli..."

wget "${URL}" -O "${TAR_PATH}"

tar -xzf "${TAR_PATH}" -C "${RUNTIPI_PATH}"
rm -rf "${TAR_PATH}"

mv "${RUNTIPI_PATH}/runtipi-cli-linux-aarch64" "${RUNTIPI_PATH}/runtipi-cli"
chmod +x "${RUNTIPI_PATH}/runtipi-cli"

echo "Setting permissions..."

on_chroot << EOF
chown -R ${FIRST_USER_NAME} "/home/${FIRST_USER_NAME}/runtipi/"
EOF

# Enable runtipi on boot 

echo "Install service..."

install -v files/runtipi.service "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

echo "Make tweaks..."

# sed -i "s|User=username|User=${FIRST_USER_NAME}|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
# Add this: `User=username` to files/runtipi.service under `[Service]` for rootless
sed -i "s|WorkingDirectory=/home/username/runtipi/|WorkingDirectory=/home/${FIRST_USER_NAME}/runtipi|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
sed -i "s|ExecStart=/home/username/runtipi/runtipi-cli start|ExecStart=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli start|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"
sed -i "s|ExecStop=/home/username/runtipi/runtipi-cli stop|ExecStop=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli stop|" "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

chmod -x "${ROOTFS_DIR}/etc/systemd/system/runtipi.service"

echo "Enable runtipi on boot..."

on_chroot << EOF
systemctl enable runtipi
EOF
