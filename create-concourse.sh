#!/bin/bash

export PUBLIC_IP=$(cat terraform.tfstate | jq -r '.modules[0].outputs.external_ip.value')
export INTERNAL_CIDR=$(cat terraform.tfstate | jq -r '.modules[0].outputs.network_cidr.value')
export INTERNAL_GW=$(cat terraform.tfstate | jq -r '.modules[0].outputs.internal_gw.value')
export INTERNALIP=$(cat terraform.tfstate | jq -r '.modules[0].outputs.concourse_internal_ip.value')
export VNET_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.vnet_name.value')
export SUBNET_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.subnet_name.value')
export RESOURCE_GROUP_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.resource_group_name.value')
export STORAGE_ACCOUNT_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.storage_account_name.value')
export DEFAULT_SECURITY_GROUP=$(cat terraform.tfstate | jq -r '.modules[0].outputs.default_security_group.value')
export SUBSCRIPTION_ID=$(cat terraform.tfstate | jq -r '.modules[0].outputs.subscription_id.value')
export TENANT_ID=$(cat terraform.tfstate | jq -r '.modules[0].outputs.tenant_id.value')
export CLIENT_ID=$(cat terraform.tfstate | jq -r '.modules[0].outputs.client_id.value')
export CLIENT_SECRET=$(cat terraform.tfstate | jq -r '.modules[0].outputs.client_secret.value')

export CONCOURSE_DEPLOYMENT=$(dirname "$0")/concourse-bosh-deployment

bosh create-env ${CONCOURSE_DEPLOYMENT}/lite/concourse.yml \
  -o $(dirname "$0")/azure.yml \
  -o ${CONCOURSE_DEPLOYMENT}/lite/jumpbox.yml \
  -o <(sed 's|name=web|name=concourse|g' ${CONCOURSE_DEPLOYMENT}/cluster/operations/tls.yml) \
  -o <(sed 's|name=web|name=concourse|g' ${CONCOURSE_DEPLOYMENT}/cluster/operations/privileged-https.yml) \
  -o <(sed 's|name=web|name=concourse|g' ${CONCOURSE_DEPLOYMENT}/cluster/operations/basic-auth.yml) \
  -o <(cat <<EOF
- type: replace
  path: /instance_groups/name=concourse/jobs/name=atc/properties/external_url
  value: https://((public_ip))
- type: replace
  path: /instance_groups/name=concourse/jobs/name=atc/properties/basic_auth_password?
  value: ((admin_password))
- type: replace
  path: /variables/-
  value:
    name: admin_password
    type: password
EOF) \
  -o ${CONCOURSE_DEPLOYMENT}/cluster/operations/tls-vars.yml \
  -l ${CONCOURSE_DEPLOYMENT}/versions.yml \
  --vars-store concourse-creds.yml \
  -v public_ip=${PUBLIC_IP} \
  -v internal_cidr=${INTERNAL_CIDR} \
  -v internal_gw=${INTERNAL_GW} \
  -v internal_ip=${INTERNALIP} \
  -v vnet_name=${VNET_NAME} \
  -v subnet_name=${SUBNET_NAME} \
  -v subscription_id=${SUBSCRIPTION_ID} \
  -v tenant_id=${TENANT_ID} \
  -v client_id=${CLIENT_ID} \
  -v client_secret=${CLIENT_SECRET} \
  -v resource_group_name=${RESOURCE_GROUP_NAME} \
  -v storage_account_name=${STORAGE_ACCOUNT_NAME} \
  -v default_security_group=${DEFAULT_SECURITY_GROUP} \
  -v atc_basic_auth.username=admin \
  --state concourse-state.json \
