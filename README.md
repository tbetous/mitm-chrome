# MITM Chrome

This project enables the creation of a man-in-the-middle proxy with minimal setup to easily monitor network traffic while browsing with Chrome.

The repository was created to investigate whether Chrome spellchecks passwords when they are unhidden.

This repository contains a small docker-compose project that creates two containers:

- One container running the official mitmproxy image
- One container with a custom image containing Chrome and a VNC server

## Why this configuration?

The goal was to avoid modifying local Chrome installation, installing fake SSL certificates, and ensure simple setup and teardown. This led to the development of a Docker-based solution.

## How to start

Launch the containers with the following command:

```
docker-compose up
```

Once completed, you can:

- Access Chrome through a VNC client via port `5900`. Password is `password`.
- Access the mitmproxy web interface via ` localhost:8081` and start to observe network.

## Troubleshooting

### Not working on Mac M1, M2, MX

For Mac ARM processors, it is recommended to use colima and run with rosetta.

```
colima start --vm-type vz --vz-rosetta
```
