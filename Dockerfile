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

ARG PORT="7777"

ENV CONFIG_LOC "/config"
ENV INSTALL_LOC "/scpserver"

# Upgrade the system
USER root
RUN apt update && \
    apt upgrade --assume-yes

# Setup directory structure and permissions
RUN useradd -m -s /bin/false scpsl && \
    mkdir -p "/home/scpsl/.config/SCP Secret Laboratory/config" $CONFIG_LOC $INSTALL_LOC && \
    ln -s $CONFIG_LOC "/home/scpsl/.config/SCP Secret Laboratory/config/$PORT" && \
    chown -R scpsl:scpsl $INSTALL_LOC $CONFIG_LOC
COPY --chown=scpsl:scpsl --from=steambuild /scpserver $INSTALL_LOC

# I/O
VOLUME /config
EXPOSE $PORT/udp

# Expose and run
USER scpsl
WORKDIR $INSTALL_LOC
CMD ./LocalAdmin $PORT
