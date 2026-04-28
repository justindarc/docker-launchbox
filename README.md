# docker-launchbox

Run LaunchBox via Wine inside Docker using Selkies

- No GPU required
- Works on any standard Docker host (Ubuntu, Unraid, etc.)
- Automatically initializes Wine prefix on first run
- Automatically installs LaunchBox if the installer is provided and there is no existing installation

## System requirements

- Docker 20+
- 4GB RAM minimum (8GB recommended)
- 20GB+ storage recommended
- x86_64 CPU

Tested with:
- Ubuntu 24.04 LTS
- Ubuntu 26.04 LTS
- Unraid 7.2.4

## Folder structure

On your host machine create:

```
~/docker-launchbox/
 ├── config/
 ├── launchbox/
```

## Drive mapping

Docker volumes can be mapped to Wine drive letters using `MAP_DRIVE_*` environment variables. The variable name determines the drive letter — for example, `MAP_DRIVE_G` maps to `G:`, `MAP_DRIVE_R` maps to `R:`, and so on:

```
docker run -d \
  -e MAP_DRIVE_G=/games \
  -v ./games:/games \
  -e MAP_DRIVE_R=/roms \
  -v ./roms:/roms \
  ...
```

Each `MAP_DRIVE_*` variable must point to a valid directory inside the container. If the path does not exist, the mapping is skipped and a warning is logged.

## Building the image

```
docker build -t justindarc/launchbox .
```

## Starting the container

```
docker run -d \
  --name launchbox \
  -p 3000:3000 \
  -p 3001:3001 \
  -v ./config:/config \
  -v ./launchbox:/launchbox \
  -e MAP_DRIVE_G=/games \
  -v ./games:/games \
  --shm-size="2gb" \
  --restart unless-stopped \
  justindarc/launchbox:latest
```

## Stopping the container

```
docker stop justindarc/launchbox
```

## Removing the container

```
docker rm justindarc/launchbox
```

## Access LaunchBox

Open your browser:

```
http://YOUR-SERVER-IP:3000/
```

You will see LaunchBox running via Wine.

## First run behavior

On first launch the container will:

1. Initialize a new Wine prefix if it does not yet exist in `./config/wine`
2. Map any `MAP_DRIVE_*` environment variables to Wine drive letters
3. Install LaunchBox if an existing installation is not found and the installer is present in `./launchbox`
4. Run LaunchBox from `./launchbox`

*First boot may take 15 minutes or longer to initialize the Wine prefix and/or install LaunchBox.*

## Installing a new LaunchBox installation

Place installer file such as `LaunchBox-13.26-Setup.exe` into `./launchbox`.

After restarting the container, the installer will automatically run and install LaunchBox to `./launchbox`.

## Using an existing LaunchBox installation

If you already have LaunchBox installed on a Windows machine, copy the entire contents of the installation folder into `./launchbox`.

After restarting the container, LaunchBox will automatically start.

## Troubleshooting

### Blank screen

Right-click to open the context menu and attempt to re-open LaunchBox

### Installer not running

Ensure installer filename matches a `LaunchBox-*.*-Setup.exe` pattern.
