#!/bin/bash -e

echo "Setting version in /etc/runtipi-version"

echo "Runtipi OS ${RUNTIPI_VERSION} based on Debian ${RELEASE^}" > "${ROOTFS_DIR}/etc/runtipi-version.txt"