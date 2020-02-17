FROM cm2network/steamcmd

ENV CONFIG_LOC "/config"
ENV INSTALL_LOC "/home/steam/scpserver"
ENV PORT "7777"

# Upgrade the system
# Install gdb because scp has some unlisted dependency that it shares with gdb
# that I coincidentally found while installing gdb to try to test the server
# Removing gdb *will* break the server
USER root
RUN apt update && \
    apt upgrade --assume-yes && \
    apt install --assume-yes gdb

# Make our config and ensure our unprivileged steam user owns it
RUN mkdir -p $CONFIG_LOC && \
    chown steam:steam $CONFIG_LOC

USER steam
WORKDIR /home/steam

# Install the scpsl server
RUN $STEAMCMDDIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $INSTALL_LOC \
    +app_update 996560 \
    +app_update 996560 validate \
    +quit

# Link the config files into a sane location
RUN mkdir -p "/home/steam/.config" && \
    ln -s "$CONFIG_LOC" "/home/steam/.config/SCP Secret Laboratory"

EXPOSE $PORT/udp
WORKDIR $INSTALL_LOC
CMD ["./LocalAdmin", "$PORT"]
