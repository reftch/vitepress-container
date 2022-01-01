ARG TAG=16-alpine
FROM node:$TAG

WORKDIR /app

# Install packages
RUN set -eux; \
    # Clean out directories that don't need to be part of the image
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && \
    npm install -g pnpm

ENTRYPOINT ["/bin/sh"]