#!/bin/bash

echo "Applying configmap ${YAML_TEMPLATE_FILE}"

cat ${YAML_TEMPLATE_FILE} | envsubst  | kubectl apply -f -
