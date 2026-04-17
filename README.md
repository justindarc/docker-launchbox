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
- Ubuntu 22.04

## Folder structure

On your host machine create:

```
~/docker-launchbox/
 ├── config/
 ├── games/
 ├── installer/
 ├── launchbox/
```

## Building the image

```
docker build -t launchbox .
```

## Starting the container

```
docker run -d \
  --name launchbox \
  -p 3000:3000 \
  -v ./config:/config \
  -v ./games:/games \
  -v ./installer:/installer \
  -v ./launchbox:/launchbox \
  --restart unless-stopped \
  launchbox
```

## Stopping the container

```
docker stop launchbox
```

## Removing the container

```
docker rm launchbox
```

## Rebuilding and recreating the container

```
docker stop launchbox
docker rm launchbox
docker build -t launchbox .
docker run -d \
  --name launchbox \
  -p 3000:3000 \
  -v ./config:/config \
  -v ./games:/games \
  -v ./installer:/installer \
  -v ./launchbox:/launchbox \
  --restart unless-stopped \
  launchbox
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
2. Create a symbolic link to map the `R:` drive in the Wine prefix to the `./games` folder
3. Install LaunchBox (if the installer is present in `./installer`) if an existing LaunchBox installation cannot be found in `./launchbox`
4. Run LaunchBox

First boot may take 5–10 minutes.

## Installing a new LaunchBox installation

Place installer file such as `LaunchBox-13.26-Setup.exe` into `./installer`.

After restarting the container, the installer will automatically run and install LaunchBox to `./launchbox`.

## Using an existing LaunchBox installation

If you already have LaunchBox installed on a Windows machine, copy the entire contents of the installation folder into `./launchbox`.

After restarting the container, LaunchBox will automatically start.

## Troubleshooting

### Blank screen

Wait up to 2–3 minutes on first run.

### Installer not running

Ensure installer filename matches a `LaunchBox-*.*-Setup.exe` pattern.
