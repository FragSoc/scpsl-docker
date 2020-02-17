# SCP:Secret Lab Dedicated Server

A [Docker](https://www.docker.com/) image to run a dedicated server for [SCP: Secret Lab](https://store.steampowered.com/app/700330/SCP_Secret_Laboratory/).

## Usage

- Mount the folder you want the server configuration to reside in under `/config` within the container
- The server will run on port `7777` on UDP, so remember to forward this to the container!
- SCPSL is proprietary software and therefore no ready-built images are available, you must build the image yourself

An example command could be:

```bash
docker build -t scpsl . ; docker run -d -p 7777:7777/udp -v scpsl_config:/config scpsl
```
