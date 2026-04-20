FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        man-db \
        manpages \
        coreutils \
        procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY server.sh client.sh configServer.conf ./

RUN chmod +x /app/server.sh /app/client.sh

# Default command starts the server; compose can override this for client runs.
CMD ["/app/server.sh"]
