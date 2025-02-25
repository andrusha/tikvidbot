FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/node:14-alpine

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package.json ./package.json
RUN yarn

# Copy app source
COPY . .

# Run app
CMD [ "yarn", "start" ]
