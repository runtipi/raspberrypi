# Runtipi OS ⛺

Runtipi OS is a simple operating system based on Debian Bookworm designed to make the experience of getting
into the self-hosting world as easy as possible and of course as affordable as possible 💵.

> Info 📖: This is a modified version of the raspberry pi [pi-gen](https://github.com/RPi-Distro/pi-gen) tool.

> Warning ⚠️: This is still in development so issues are to be expected please open an issue for any bug you encounter.

## Getting started 🚀

You can install RunTipi on either of these two devices:

- [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)
- [Raspberry Pi 3 Model B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/)

> Support for raspberry pi 5 coming soon!

> Note that the raspberry pi 4 is recommended due to having more ram so when buying choose 4gb of ram or more.

### Instructions

1. You will need these requirements to install Runtipi OS:
   1. A raspberry pi 4 or 3 (of course 😉)
   2. A 16gb or more SD card
   3. An ethernet cable
   4. A computer with an internet connection
   5. An SD card reader
   6. A case

> A fan in the case would be also recommened you can find the official one [here](https://www.raspberrypi.com/products/raspberry-pi-4-case-fan/)

2. Download the latest Runtipi OS image from the [releases page](https://github.com/runtipi/runtipi-raspberrypi/releases)

3. Download and install Raspberry Pi Imager from [here](https://www.raspberrypi.com/software/). Launch Raspberry Pi Imager and select your board. Then select the image you just downloaded and click the write button. The process will take about 5 minutes depending on your SD card.

4. Insert the card into the Raspberry Pi, connect the ethernet cable and then the power cable. Wait around 10-15 minutes for it to download all the requirements and then access the dashboard by going to `tipi.local`.

## SSH 💻

SSH is enabled by default so you can see logs for any issues. Here are the credentials:

- Hostname: `tipi.local`
- User: `tipi`
- Password: `letthatselfhostingroll`

## Build the image yourself 🔨

If you like, you can build the image yourself using these commands:

1. Clone the repo

```Bash
git clone https://github.com/runtipi/runtipi-raspberrypi.git
```

2. Install requirements

You will need both docker which you can install like this:

```Bash
curl -fsSL get.docker.com | sh
```

And now install the apt requirements:

```Bash
sudo apt install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx gpg pigz sed
```

4. Set the current runtipi version in `config`

5. Build

To build the image cd into the repo and run this command:

```Bash
./build-docker.sh
```

This can take from 15 minutes to 30 minutes depending on your hardware and internet connection. When it is done you will have the image inside the `deploy/` folder.

## Contributing ❤️

This image is currently managed by one person (a teenager 😅) and it is hard to build and test every time. It would be extremely helpful for anyone interested in supporting this project to join our discord server [here](https://discord.gg/Bu9qEPnHsc) and help with the development of this project!
