<div align="center">
    <a href="https://store.steampowered.com/app/700330/SCP_Secret_Laboratory/">
        <img width=100% src="https://steamcdn-a.akamaihd.net/steam/apps/700330/header.jpg"/>
    </a>
    <br/>
    <img alt="Travis (.com)" src="https://img.shields.io/travis/com/FragSoc/scpsl-docker?style=flat-square">
    <img alt="GitHub" src="https://img.shields.io/github/license/FragSoc/barotrauma-docker?style=flat-square">
</div>

---

A [Docker](https://www.docker.com/) image to run a dedicated server for [SCP: Secret Lab](https://store.steampowered.com/app/700330/SCP_Secret_Laboratory/).

## Usage

An example sequence could be:

```bash
docker build -t scpsl https://github.com/FragSoc/scpsl-docker.git && \
    docker run -d -p 7777:7777/udp -v $PWD/scpsl_config:/config scpsl
```

The image exposes one volume at `/config` for the server's configuration files.

The image exposes one port, defaulting to `7777/udp` (see below).

### Build Arguments

Argument Key | Default Value | Description
---|---|---
`UID` | `999` | Desired user ID of the user the server will run as. You might want to override this for easier directory permission management.
`GID` | `999` | Twin to `UID`, setting the primary group id of the user.
`APPID` | `996560` | The appid to pass to `steamcmd`. Default should be fine for the vast majority of cases.
`PORT` | `7777` | Port that the game will be run under. **WARNING:** you must still set this in `/config/config_gamplay.txt`

## Licensing

The few files in this repo are licensed under the GPL.

However, SCP: Secret Lab is proprietary software licensed by [Northwood Studios](https://northwoodstudios.org/); no credit is taken for the software in this image.
