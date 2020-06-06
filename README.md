<center>
    <a href="https://store.steampowered.com/app/700330/SCP_Secret_Laboratory/">
        <img width=100% src="https://steamcdn-a.akamaihd.net/steam/apps/700330/header.jpg"/>
    </a>
</center>

A [Docker](https://www.docker.com/) image to run a dedicated server for [SCP: Secret Lab](https://store.steampowered.com/app/700330/SCP_Secret_Laboratory/).

## Usage

An example sequence could be:

```bash
docker build -t scpsl .
docker run -d -p 7777:7777/udp -v $PWD/scpsl_config:/config scpsl
```

### Volumes

The image exposes one volume at `/config` for the server's configuration files.

### Ports

The image exposes one port, defaulting to `7777/udp` (see below).

### Build Arguments

- `UID` sets the user ID value of the user the server will run under, defaults to `999`.
  You might want to override this for easier directory permission management.
- `PORT` sets the port that the game will be run under.
  **WARNING:** you must still set this in `/config/config_gamplay.txt`

## Licensing

The few files in this repo are licensed under the GPL.

However, SCP: Secret Lab is proprietary software licensed by [Northwood Studios](https://northwoodstudios.org/); no credit is taken for the software in this image.
