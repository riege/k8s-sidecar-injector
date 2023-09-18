# Hacking

## Build

Want to build this thing yourself?

```shell
go build ./...
```

Start the appplication like this:

```shell
bin/k8s-sidecar-injector --help
```

## Tests

```shell
go test ./...
```

## Image build

The image is build automatically, but currently not available from a public registry.
See [/docs/deployment.md](/docs/deployment.md) for how to run this in Kubernetes.

```shell
docker build .
```

## Run By Hand

This needs some special configuration surrounding the TLS certs, but if you have already read [docs/configuration.md](./docs/configuration.md), you can run this manually with:

```shell
bin/k8s-sidecar-injector --tls-port=9000 --config-directory=conf/ --tls-cert-file="${TLS_CERT_FILE}" --tls-key-file="${TLS_KEY_FILE}"
```

NOTE: this is not a supported method of running in production. You are highly encouraged to read [docs/deployment.md](./docs/deployment.md) to deploy this to Kubernetes in The Supported Way.
