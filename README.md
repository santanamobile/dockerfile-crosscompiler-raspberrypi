# Cross-Compiling Environment for Raspberry Pi

This repository contains a Dockerfile for setting up a cross-compiling environment for the Raspberry Pi on an x86 machine.

This work is based on [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/computers/linux_kernel.html#cross-compile-the-kernel) about kernel compiling.

## Container Specs

- Linux Distro (on Dockerfile): Ubuntu 22.04
- Toolchains: crossbuild-essential-armhf, crossbuild-essential-arm64

## Requirements

Before start, you must have the Docker runtime installed on your machine. You can obtain the instructions [here](https://docs.docker.com/get-docker/).

## Build Container

This is the command to build the Docker image:

```bash
docker build --no-cache --build-arg "HOST_UID=$(id -u)" --build-arg "HOST_GID=$(id -g)" --rm -f "Dockerfile" -t compiler-raspberry-pi:v1.0 .
```

Check the result image:

```bash
$ docker image ls

REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
compiler-raspberry-pi    v1.0      85c6737ca559   25 seconds ago   917MB
```

## How to use

Choose an empty folder on your machine, download sources and run the container.

```bash
mkdir -p ~/src/raspberrypi
cd ~/src/raspberrypi
```

Download the source code for the latest Raspberry Pi kernel:

```bash
git clone --depth=1 https://github.com/raspberrypi/linux
```

```bash
cd linux
```

Run the container

```bash
docker run -it --rm -v $(pwd):/project compiler-raspberry-pi:v1.0
```

## Creating default configuration

Before compiling the kernel and modules you must create the appropriate configuration for your target architecture/board model.

For 64 bit architecture and these boards, enter the command below.

- Raspberry Pi 3
- Raspberry Pi Compute Module 3
- Raspberry Pi 3+
- Raspberry Pi Compute Module 3+
- Raspberry Pi Zero 2 W
- Raspberry Pi 4
- Raspberry Pi 400
- Raspberry Pi Compute Module 4
- Raspberry Pi Compute Module 4S

```bash
cd linux
KERNEL=kernel8
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
```

- Raspberry Pi 5

```bash
cd linux
KERNEL=kernel_2712
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
```

For 32 bit architecture and these boards, enter the command below

- Raspberry Pi 1
- Raspberry Pi Compute Module 1
- Raspberry Pi Zero
- Raspberry Pi Zero W

```bash
cd linux
KERNEL=kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig
```

- Raspberry Pi 2
- Raspberry Pi 3
- Raspberry Pi Compute Module 3
- Raspberry Pi 3+
- Raspberry Pi Compute Module 3+
- Raspberry Pi Zero 2 W

```bash
cd linux
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
```

- Raspberry Pi 4
- Raspberry Pi 400
- Raspberry Pi Compute Module 4
- Raspberry Pi Compute Module 4S

```bash
cd linux
KERNEL=kernel7l
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
```

## Using menuconfig

To modify the default configuration to customise it to our needs, so we use menuconfig tool to do this.

- For 64-bit kernel

```bash
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
```

- For 32-bit kernel

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```

## Build Kernel

- Run the following command to build a 64-bit kernel:

```bash
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
```

- Run the following command to build a 32-bit kernel:

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
```

## Work In Progress

Explain how to install kernel and modules.

You'll find more details about install kernel and modules [here](https://www.raspberrypi.com/documentation/computers/linux_kernel.html#cross-compile-the-kernel).

## Contribution

Contributions are welcome! Feel free to open issues or pull requests.

## Author

[santanamobile](https://www.github.com/santanamobile)

## License

[MIT](https://choosealicense.com/licenses/mit/)
