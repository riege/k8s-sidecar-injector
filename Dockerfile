FROM golang:1.21.1 AS build

WORKDIR /go/src/k8s-sidecar-injector

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go test ./...

ARG BRANCH
ARG COMMIT
ARG PACKAGE=github.com/riege/k8s-sidecar-injector
ARG VERSION=dev

RUN CGO_ENABLED=0 GOOS=linux go build -o /k8s-sidecar-injector \
    -ldflags "\
    -X '${PACKAGE}/internal/pkg/version.Version=${VERSION}' \
    -X '${PACKAGE}/internal/pkg/version.BuildDate=$(date +%FT%T%z)' \
    -X '${PACKAGE}/internal/pkg/version.Commit=${COMMIT}' \
    -X '${PACKAGE}/internal/pkg/version.Branch=${BRANCH}' \
    -X '${PACKAGE}/internal/pkg/version.Package=${PACKAGE}' \
    " ./cmd

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2-750

ENTRYPOINT ["entrypoint.sh"]
EXPOSE $TLS_PORT $LIFECYCLE_PORT
CMD []

ENV TLS_PORT=9443 \
    LIFECYCLE_PORT=9000 \
    TLS_CERT_FILE=/var/lib/secrets/cert.crt \
    TLS_KEY_FILE=/var/lib/secrets/cert.key

COPY --from=build /k8s-sidecar-injector /bin/k8s-sidecar-injector
COPY ./conf /conf
COPY ./entrypoint.sh /bin/entrypoint.sh

USER 1001
