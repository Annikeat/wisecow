FROM debian:bookworm-slim

# Install dependencies including netcat-openbsd and fortunes
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bash \
      curl \
      fortune-mod \
      fortunes \
      cowsay \
      netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup -d /app -s /bin/bash appuser

WORKDIR /app

COPY ./wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh && chown -R appuser:appgroup /app

# Ensure fortune is in PATH
ENV PATH="/usr/games:$PATH"

USER appuser
EXPOSE 4499

ENTRYPOINT ["/app/wisecow.sh"]

