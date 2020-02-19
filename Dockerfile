### Builder
FROM cm2network/steamcmd AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ENV INSTALL_LOC "/scpserver"

# Upgrade the system
# Install gdb because scp has some unlisted dependency that it shares with gdb
# that I coincidentally found while installing gdb to try to test the server
# Removing gdb *will* break the server
USER root
RUN apt update && \
    apt upgrade --assume-yes && \
    apt install --assume-yes gdb

# Make our config and ensure our unprivileged steam user owns it
RUN mkdir -p $CONFIG_LOC $INSTALL_LOC && \
    chown steam:steam $CONFIG_LOC $INSTALL_LOC

# Install the scpsl server
RUN $STEAMCMDDIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $INSTALL_LOC \
    +app_update 996560 \
    +app_update 996560 validate \
    +quit

FROM mono AS runner

ENV PORT "7777"
ENV CONFIG_LOC "/config"
ENV INSTALL_LOC "/scpserver"

USER root

COPY --from=steambuild $INSTALL_LOC $INSTALL_LOC

RUN useradd -m scpsl && \
    chown -R scpsl:scpsl $INSTALL_LOC

USER scpsl

# Link the config files into a sane location
RUN mkdir -p "/home/scpsl/.config" && \
    ln -s "$CONFIG_LOC" "/home/scpsl/.config/SCP Secret Laboratory"

EXPOSE $PORT/udp
WORKDIR $INSTALL_LOC
ENTRYPOINT ./LocalAdmin $PORT
