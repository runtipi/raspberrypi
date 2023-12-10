#!/bin/bash -e

# Install docker

echo "Installing docker..."

on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker ${FIRST_USER_NAME}
EOF

# Make sure the home directory exists

echo "Making tipi directory..."

mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/"

# Install runtipi

echo "Downloading tipi..."

if [ "${RUNTIPI_VERSION}" = "latest" ]; then
    LATEST_VERSION=$(curl -sL https://api.github.com/repos/runtipi/runtipi/releases/latest | grep tag_name | cut -d '"' -f4)
    VERSION=${LATEST_VERSION}
else
    VERSION=${RUNTIPI_VERSION}
fi

URL="https://github.com/runtipi/runtipi/releases/download/${VERSION}/runtipi-cli-linux-arm64"

wget ${URL} -O "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli" --show-progress -q
chmod +x "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli"

# echo "Setting permissions..."

# on_chroot << EOF
# chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/
# EOF

echo "Starting tipi..."

.${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi/runtipi-cli start

# Enable runtipi on boot 

if [[ "$VERSION" < "v2.2.0" ]]; then # Backwards Compatability
    echo "Install service..."

    install -v files/tipi.service "${ROOTFS_DIR}/etc/systemd/system/tipi.service"

    echo "Make tweaks..."

    sed -i "s|WorkingDirectory=/home/username/runtipi/|WorkingDirectory=/home/${FIRST_USER_NAME}/runtipi/|" "${ROOTFS_DIR}/etc/systemd/system/tipi.service"
    sed -i "s|ExecStart=/home/username/runtipi/runtipi-cli start|ExecStart=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli start|" "${ROOTFS_DIR}/etc/systemd/system/tipi.service"
    sed -i "s|ExecStop=/home/username/runtipi/runtipi-cli stop|ExecStop=/home/${FIRST_USER_NAME}/runtipi/runtipi-cli stop|" "${ROOTFS_DIR}/etc/systemd/system/tipi.service"

    chmod -x "${ROOTFS_DIR}/etc/systemd/system/tipi.service"

    echo "Enable runtipi on boot..."

    on_chroot << EOF
    systemctl enable tipi
EOF
else
    echo "Skipping service install..."
fi

# Verification

# echo "Verify... (debug)"

# ls -la "${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
# ls -la "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/runtipi"
# cat "${ROOTFS_DIR}/etc/systemd/system/tipi.service"
