FROM golang:1.21.2

WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go test ./...
RUN go build -v -o /usr/local/bin/ ./...


FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2-750

ENTRYPOINT ["entrypoint.sh"]
EXPOSE $TLS_PORT $LIFECYCLE_PORT
CMD []

ENV TLS_PORT=9443 \
    LIFECYCLE_PORT=9000 \
    TLS_CERT_FILE=/var/lib/secrets/cert.crt \
    TLS_KEY_FILE=/var/lib/secrets/cert.key

COPY --from=0 /usr/local/bin/cmd /bin/k8s-sidecar-injector
COPY ./conf /conf
COPY ./entrypoint.sh /bin/entrypoint.sh

USER 1001
