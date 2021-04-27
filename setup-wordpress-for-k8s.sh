#!/usr/bin/env bash
#
# Setup WordPress for K8s script
#
# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Copyright (c) 2021 Bitnami
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# Constants
ROOT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd)"
CHARTS=(
    "external-dns"
    "kube-prometheus"
    "grafana-operator"
    "elasticsearch"
    "kibana"
    "fluentd"
    "nginx-ingress-controller"
    "mariadb-galera"
    "memcached"
    "wordpress"
    "cert-manager"
)

# Load Libraries
. "${ROOT_DIR}/lib/liblog.sh"
. "${ROOT_DIR}/lib/libutil.sh"

# Axiliar functions
print_menu() {
    local script
    script=$(basename "${BASH_SOURCE[0]}")
    log "${RED}NAME${RESET}"
    log "    $(basename -s .sh "${BASH_SOURCE[0]}")"
    log ""
    log "${RED}SYNOPSIS${RESET}"
    log "    $script [${YELLOW}-uh${RESET}] [${YELLOW}--disable-dns-and-certs${RESET}] [${YELLOW}--disable-ingress${RESET}] [${YELLOW}--disable-logging${RESET}] [${YELLOW}--disable-monitoring${RESET}]"
    log ""
    log "${RED}DESCRIPTION${RESET}"
    log "    Script to setup WordPress on your K8s cluster."
    log ""
    log "    The options are as follow:"
    log ""
    log "      ${YELLOW}-h, --help${RESET}                Print this help menu."
    log "      ${YELLOW}--disable-dns-and-certs${RESET}   Disable deploying external-dns & cert-manager resources."
    log "      ${YELLOW}--disable-ingress${RESET}         Disable deploying ingress controller resources."
    log "      ${YELLOW}--disable-logging${RESET}         Disable deploying the logging resources."
    log "      ${YELLOW}--disable-monitoring${RESET}      Disable deploying the monitoring resources."
    log "      ${YELLOW}-u, --dry-run${RESET}             Enable \"dry run\" mode."
    log ""
    log "${RED}EXAMPLES${RESET}"
    log "      $script --help"
    log "      $script --disable-monitoring"
    log ""
}

help_menu=0
dry_run=0
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            help_menu=1
            ;;
        -u|--dry-run)
            dry_run=1
            ;;
        --disable-dns-and-certs)
            for c in "${!CHARTS[@]}"; do
                [[ "${CHARTS[c]}" =~ ^(cert-manager|external-dns)$ ]] && unset 'CHARTS[c]'
            done
            ;;
        --disable-ingress)
            for c in "${!CHARTS[@]}"; do                    
                [[ "${CHARTS[c]}" = "nginx-ingress-controller" ]] && unset 'CHARTS[c]'
            done
            ;;
        --disable-logging)
            for c in "${!CHARTS[@]}"; do                    
                [[ "${CHARTS[c]}" =~ ^(elasticsearch|kibana|fluentd)$ ]] && unset 'CHARTS[c]'
            done
            ;;
        --disable-monitoring)
            for c in "${!CHARTS[@]}"; do                    
                [[ "${CHARTS[c]}" =~ ^(kube-prometheus|grafana-operator)$ ]] && unset 'CHARTS[c]'
            done
            ;;
        *)
            error "Invalid command line flag $1" >&2
            exit 1
            ;;
    esac
    shift
done

if [[ "$help_menu" -eq 1 ]]; then
    print_menu
    exit 0
fi
if [[ "$dry_run" -eq 1 ]]; then
    info "DRY RUN mode enabled!"
    info "Charts to deploy:"
    for c in "${CHARTS[@]}"; do
        namespace="$(get_chart_namespace "$c")"
        info "Chart bitnami/${c} into namespace '$namespace'"
    done
    exit 0
fi

info "Adding 'bitnami' and 'jetstack' chart repositories..."
silence helm repo add bitnami https://charts.bitnami.com/bitnami
silence helm repo add jetstack https://charts.jetstack.io
info "Updating chart repositories..."
silence helm repo update
for c in "${CHARTS[@]}"; do
    namespace="$(get_chart_namespace "$c")"
    silence kubectl create ns "$namespace" || true
    info "Installing $c in namespace '$namespace'..."
    if [[ "$c" = "cert-manager" ]]; then
        silence helm install --wait "$c" "jetstack/${c}" -f "${ROOT_DIR}/values/${c}-values.yaml" -n "$namespace"
        clusterIssuer="$(cat << EOF
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: juan@bitnami.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
)"
        silence kubectl apply -f <(echo "$clusterIssuer")
    else
        silence helm install --wait "$c" "bitnami/${c}" -f "${ROOT_DIR}/values/${c}-values.yaml" -n "$namespace"
    fi
done
