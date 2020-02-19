FROM cm2network/steamcmd AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ENV APPID 786920

# Make our config and give it to the steam user
USER root
RUN mkdir -p /scpserver && \
    chown steam:steam /scpserver

# Install the scpsl server
USER steam
RUN $STEAMCMDDIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir /scpserver \
    +app_update $APPID validate \
    +quit

FROM mono AS runner

ENV PORT "7777"
ENV CONFIG_LOC "/config"
ENV INSTALL_LOC "/scpserver"

# Upgrade the system
USER root
RUN apt update && \
    apt upgrade --assume-yes

# Setup directory structure and permissions
RUN groupadd -r scpsl && useradd -mr -s /bin/false -g scpsl scpsl && \
    mkdir -p "/home/scpsl/.config" $CONFIG_LOC $INSTALL_LOC && \
    ln -s "$CONFIG_LOC" "/home/scpsl/.config/SCP Secret Laboratory" && \
    chown -R scpsl:scpsl $INSTALL_LOC $CONFIG_LOC
COPY --chown=scpsl:scpsl --from=steambuild /scpserver $INSTALL_LOC

# I/O
VOLUME /config
EXPOSE $PORT/udp

# Expose and run
USER scpsl
WORKDIR $INSTALL_LOC
ENTRYPOINT ["mono"]
CMD ./LocalAdmin.exe $PORT
