FROM alpine AS builder
RUN apk update && apk add nodejs npm yarn git

COPY excalidraw /excalidraw
WORKDIR /excalidraw

RUN npm install
RUN npm run build:app:docker

FROM nginx:alpine
COPY --from=builder /excalidraw/build /usr/share/nginx/html

HEALTHCHECK --start-period=5s CMD curl -f http://localhost/ || exit 1
