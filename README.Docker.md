## Docker Setup (Ubuntu)

This project includes an Ubuntu-based container image tailored for the FIFO client-server Bash application.

### What is included in the image

- Ubuntu 24.04 base image
- Bash runtime
- Linux manual pages and man-db (`man` command)
- Application scripts: `server.sh`, `client.sh`, `configServer.conf`

### Why compose uses a shared volume

The server and client communicate through FIFO files under `/tmp`.

In Docker, each container has its own filesystem by default, so `compose.yaml` mounts a shared volume on `/tmp` for both services. This allows both containers to access the same FIFO files.

### Build image

Run:

```bash
docker compose build
```

### Start server

Run:

```bash
docker compose up -d server
```

Check logs:

```bash
docker compose logs -f server
```

### Run client

Run an interactive client session:

```bash
docker compose run --rm client
```

When prompted, type a Linux command (example: `ls`, `grep`, `ps`).

### Stop services

```bash
docker compose down
```

Optional cleanup of the named volume used for FIFO IPC:

```bash
docker compose down -v
```