FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# Selkies environment variables
ENV TITLE=LaunchBox
ENV NO_FULL=false
ENV NO_GAMEPAD=true
ENV PIXELFLUX_WAYLAND=true
ENV SELKIES_COMMAND_ENABLED=false
ENV SELKIES_ENABLE_SHARING=false
ENV SELKIES_FILE_TRANSFERS=false
ENV SELKIES_FRAMERATE=30-60
ENV SELKIES_GAMEPAD_ENABLED=false
ENV SELKIES_MICROPHONE_ENABLED=false
ENV SELKIES_SECOND_SCREEN=false
# ENV SELKIES_IS_MANUAL_RESOLUTION_MODE=true
# ENV SELKIES_MANUAL_WIDTH=2560
# ENV SELKIES_MANUAL_HEIGHT=1440
# ENV SELKIES_SCALING_DPI=144
ENV SELKIES_UI_SHOW_CORE_BUTTONS=false
ENV SELKIES_UI_SIDEBAR_SHOW_APPS=false
ENV SELKIES_UI_SIDEBAR_SHOW_AUDIO_SETTINGS=false
ENV SELKIES_UI_SIDEBAR_SHOW_FILES=false
ENV SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=false
ENV SELKIES_UI_SIDEBAR_SHOW_SHARING=false
# ENV SELKIES_USE_CSS_SCALING=true

# Wine environment variables
ENV WINEPREFIX=/config/wine
ENV WINEFSYNC=1

# Install Wine and tools
RUN dpkg --add-architecture i386 \
  && apt update \
  && apt install -y --install-recommends \
    wget \
  && mkdir -p /etc/apt/keyrings \
  && wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key \
  && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources \
  && apt update \
  && apt install -y --install-recommends \
    cabextract \
    fonts-wine \
    wget \
    winbind \
    winehq-staging \
    winetricks \
    zenity \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

# Initialize Wine
RUN mkdir -p "${WINEPREFIX}"

# Add local files
COPY /root /

# Ports and volumes
EXPOSE 3000
EXPOSE 3001

VOLUME /config
VOLUME /launchbox
