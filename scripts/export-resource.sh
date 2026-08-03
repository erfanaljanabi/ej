#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <resource> <name> <namespace> <output-file>" >&2
  exit 1
fi

resource="$1"
name="$2"
namespace="$3"
output="$4"

mkdir -p "$(dirname "$output")"

temporary_file=$(mktemp)
trap 'rm -f "$temporary_file"' EXIT

kubectl get "$resource" "$name" \
  --namespace "$namespace" \
  --output yaml |
yq eval '
  del(
    .status,
    .metadata.creationTimestamp,
    .metadata.deletionGracePeriodSeconds,
    .metadata.deletionTimestamp,
    .metadata.generation,
    .metadata.managedFields,
    .metadata.resourceVersion,
    .metadata.selfLink,
    .metadata.uid,
    .metadata.annotations."deployment.kubernetes.io/revision",
    .metadata.annotations."kubectl.kubernetes.io/last-applied-configuration",

    .spec.clusterIP,
    .spec.clusterIPs,
    .spec.healthCheckNodePort,
    .spec.ipFamilies,
    .spec.ipFamilyPolicy,
    .spec.internalTrafficPolicy,
    .spec.sessionAffinity,
    .spec.volumeName
  )
' - > "$temporary_file"

if [[ ! -s "$temporary_file" ]]; then
  echo "Error: generated manifest is empty" >&2
  exit 1
fi

mv "$temporary_file" "$output"
trap - EXIT

echo "Exported $resource/$name to $output"
