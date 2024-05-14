#!/bin/bash

# shellcheck disable=SC2016
# shellcheck disable=SC2129

set +e

if [ -z "$CLOUDSMITH_NPM_REGISTRY" ]
then
  echo "Unable to configure NPM. Env var CLOUDSMITH_NPM_REGISTRY is not defined. Please run the set_env_vars_for_npm command first."
  exit 1
fi
if [ -z "$CLOUDSMITH_NPM_AUTH_CONFIG" ]
then
  echo "Unable to configure NPM. Env var CLOUDSMITH_NPM_AUTH_CONFIG is not defined. Please run the set_env_vars_for_npm command first."
  exit 1
fi

npm config set audit false registry="$CLOUDSMITH_NPM_REGISTRY"
npm config set audit false "$CLOUDSMITH_NPM_AUTH_CONFIG"

echo "NPM has been configured to use Cloudsmith registry with $CLOUDSMITH_NPM_REGISTRY."
