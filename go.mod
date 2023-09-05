module github.com/riege/k8s-sidecar-injector

go 1.15

require (
	github.com/dyson/certman v0.2.1
	github.com/ghodss/yaml v1.0.0
	github.com/golang/glog v1.1.2
	github.com/gorilla/handlers v1.5.1
	github.com/gorilla/mux v1.8.0
	github.com/imdario/mergo v0.3.11 // indirect
	github.com/nsf/jsondiff v0.0.0-20230430225905-43f6cf3098c1
	github.com/prometheus/client_golang v1.16.0
	gopkg.in/yaml.v2 v2.4.0
	gopkg.in/yaml.v3 v3.0.1
	k8s.io/api v0.28.1
	k8s.io/apimachinery v0.28.1
	k8s.io/client-go v0.28.1
)
