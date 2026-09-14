# Legacy Istio / cert-manager Architecture

This directory preserves the previous production architecture used to expose
the Erfan Resume application on GKE.

## Previous traffic flow

Internet
  |
  v
Google Cloud Load Balancer
  |
  v
Istio Ingress Gateway
  |
  v
Istio Gateway
  |
  v
VirtualService
  |
  v
Service: erfan-resume
  |
  v
NGINX Resume Pods

## TLS architecture

cert-manager
  |
  v
Let's Encrypt ClusterIssuer
  |
  v
Certificate: erfan-resume-tls
  |
  v
Istio Gateway HTTPS listener

## Archived resources

- `web/gateway.yaml`
- `web/virtualservice.yaml`
- `web/namespace-with-istio-injection.yaml`
- `web/kustomization-old.yaml`
- `cert-manager/certificate-erfan-resume-tls.yaml`
- `cert-manager/clusterissuer-letsencrypt-prod.yaml`
- `cert-manager/kustomization.yaml`

## Why this architecture was replaced

The Istio and cert-manager stack provided useful Kubernetes service-mesh and
TLS experience, but it added unnecessary operational overhead for a single
static resume application.

The current production architecture uses:

- GKE Standard
- One e2-small node
- One NGINX application pod
- Kubernetes ClusterIP Service
- GKE Ingress
- Google-managed TLS certificate
- Google Cloud HTTPS Load Balancer
- HTTP-to-HTTPS redirect using FrontendConfig

The legacy manifests are retained for portfolio and learning purposes and
should not be applied to the current production cluster.
