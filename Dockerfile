### Builder
FROM cm2network/steamcmd AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ENV APPID 996560

# Upgrade the system
USER root
RUN apt update && \
    apt upgrade --assume-yes

# Make our config and ensure our unprivileged steam user owns it
RUN mkdir -p /scpserver && \
    chown steam:steam /scpserver

# Install the scpsl server
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

# Grab our server
COPY --from=steambuild /scpserver $INSTALL_LOC

# Make a user to run it and give the server to them
RUN useradd -m scpsl && \
    chown -R scpsl:scpsl $INSTALL_LOC
USER scpsl

# Link the config files into a sane location
RUN mkdir -p "/home/scpsl/.config" && \
    ln -s "$CONFIG_LOC" "/home/scpsl/.config/SCP Secret Laboratory"

# Expose and run
EXPOSE $PORT/udp
WORKDIR $INSTALL_LOC
ENTRYPOINT ./LocalAdmin $PORT
