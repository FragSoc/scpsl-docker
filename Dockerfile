FROM steamcmd/steamcmd AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ARG APPID=996560

# Make our config and give it to the steam user
USER root

# Install the scpsl server
RUN mkdir -p /scpserver
RUN steamcmd \
    +login anonymous \
    +force_install_dir /scpserver \
    +app_update $APPID validate \
    +quit

FROM mono AS runner

ARG PORT=7777
ENV GAME_PORT $PORT
ARG UID=999

ENV CONFIG_LOC "/config"
ENV INSTALL_LOC "/scpserver"
ENV GAME_CONFIG_LOC "/home/scpsl/.config/SCP Secret Laboratory/config"

# Upgrade the system
USER root
RUN apt update && \
    apt upgrade --assume-yes

# Setup directory structure and permissions
RUN useradd -m -s /bin/false -u $UID scpsl && \
    mkdir -p "$GAME_CONFIG_LOC" $CONFIG_LOC $INSTALL_LOC && \
    ln -s $CONFIG_LOC "$GAME_CONFIG_LOC/$PORT" && \
    chown -R scpsl:scpsl $INSTALL_LOC $CONFIG_LOC /home/scpsl/.config
COPY --chown=scpsl:scpsl --from=steambuild /scpserver $INSTALL_LOC
COPY docker-entrypoint.sh /docker-entrypoint.sh

# I/O
VOLUME /config
EXPOSE $PORT/udp

# Expose and run
USER scpsl
WORKDIR $INSTALL_LOC
ENTRYPOINT /docker-entrypoint.sh
