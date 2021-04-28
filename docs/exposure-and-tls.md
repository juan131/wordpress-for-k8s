# Blog exposure and TLS certificates management and issuance

The solution makes possible to access the WordPress blog outside the cluster. To do so, it propagates in a DNS provider the domain to use to access the blog and generates valid TLS certificates automatically.

This is possible thanks to the capabilities provided by:

- [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/).
- [ExternalDNS](https://github.com/kubernetes-sigs/external-dns)
- [Cert Manager](https://cert-manager.io/).

The following diagram illustrates how these components interact wit each other:

![Exposure and TLS](img/exposure-and-tls.png)

## Nginx Ingress Controller and ExternalDNS

The Nginx Ingress Controller allows using a single external IP to expose all the applications inside the cluster. It acts as a proxy (with load balancing capabilities) that redirects HTTP/HTTPS requests to the corresponding K8s service based on the request's hostname or path. It also manages the TLS termination for these hostnames.

ExternalDNS extends the capabilities of the K8s cluster and makes Kubernetes resources discoverable via public DNS servers by synchronizing Ingresses (or Services) with DNS providers. In this case of this tutorial, we'll extend a GKE cluster with capabilities to synchronize [Cloud DNS](https://cloud.google.com/dns).

> Note: for GKE, the cluster must be created with the required scopes to manage CloudDNS in order to use External DNS.

This tutorial is inspired in [this blog](https://medium.com/swlh/extending-gke-with-externaldns-d02c09157793) to setup ExternalDNS on your GKE cluster. Refer to it for more information about the setup.

## TLS certificates management and issuance

To automatically generate the TLS certificates used by the the Nginx Ingress Controller to manage HTTPS communications, we'll make use of Cert Manager. Cert Manager is a Kubernetes controllers that takes care of automatically issuing certificates (from sources such as [Let's Encrypt](https://letsencrypt.org/)) and keep the up-to-date.

Detailed information about how it works can be found in the [Cert Manager docs site](https://cert-manager.io/docs/).
