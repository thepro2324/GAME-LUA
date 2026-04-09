FROM alpine:latest
RUN apk add --no-cache lua5.3 lua-libsocket
COPY . /app
WORKDIR /app
CMD ["lua5.3", "server.lua"]
