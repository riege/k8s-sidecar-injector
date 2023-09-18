# k8s-sidecar-injector

Uses MutatingAdmissionWebhook in Kubernetes to inject sidecars into new deployments at resource creation time.

## What is this?

The Riege engineering staff has forked the k8s-sidecar-injector repository from Tumblr and taken it into their own maintenance.

The original repository can be found here: <https://github.com/tumblr/k8s-sidecar-injector>

k8s-sidecar-injector is a small service that runs in each Kubernetes cluster, and listens to the Kubernetes API via webhooks. For each pod creation, the injector gets a (mutating admission) webhook, asking whether or not to allow the pod launch, and if allowed, what changes we would like to make to it. For pods that have special annotations on them (i.e. `injector.riege.com/request=logger:v1`), we rewrite the pod configuration to include the containers, volumes, volume mounts, host aliases, init-containers and environment variables defined in the sidecar `logger:v1`'s configuration.

We are currently using the software to add obeservation sidecars to our deployments.

## Configuration

See [/docs/configuration.md](/docs/configuration.md) to get started with setting up your sidecar injector's configurations.

## Deployment

See [/docs/deployment.md](/docs/deployment.md) to see what a sample deployment may look like for you!

## How it works

1. A pod is created. It has annotation `injector.riege.com/request=logger:v1`
2. K8s webhooks out to this service, asking whether to allow this pod creation, and how to mutate it
3. If the pod is annotated with `injector.riege.com/status=injected`: Do nothing! Return "allowed" to pod creation
4. Pull the "logger:v1" sidecar config, patch the resource, and return it to k8s
5. Pod will launch in k8s with the modified configuration

A crappy ASCII diagram will help :)

```plain
                                                                  +-----------------+
     +------------------------------+          +----------------+ |                 |
     |                              |          |                | |  Sidecar        |
     |   MutatingAdmissionWebhook   |          |   Sidecar      | |  configuration  |
     |                              |          |   ConfigMaps   | |  files on disk  |
     +------------+-----------------+          |                | |                 |
                  |                            +--------+-------+ +------+----------+
discover injector |                                     |                |
endpoints         |                    watch ConfigMaps |                | load from disk
                  |                                     |                |
          +-------v--------+    pod launch          +---v----------------v-----+
          |                +------------------------>                          |
          |   Kubernetes   |                        |   k8s-sidecar-injector   |
          |   API Server   <------------------------+                          |
          |                |    mutated pod spec    +--------------------------+
          +----------------+
```

## Run

See [/docs/deployment.md](/docs/deployment.md) for how to run this in Kubernetes.

### By hand

This needs some special configuration surrounding the TLS certs, but if you have already read [docs/configuration.md](./docs/configuration.md), you can run this manually with:

```shell
bin/cmd --tls-port=9000 --config-directory=conf/ --tls-cert-file="${TLS_CERT_FILE}" --tls-key-file="${TLS_KEY_FILE}"
```

*NOTE*: this is not a supported method of running in production. You are highly encouraged to read [docs/deployment.md](./docs/deployment.md) to deploy this to Kubernetes in The Supported Way.

## Hacking

See [hacking.md](/docs/hacking.md)

## License

[Apache 2.0](/LICENSE.txt)

Copyright 2019-2022, Tumblr, Inc.
Copyright 2022-2023, Riege Software International GmbH
