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

npm config set registry="$CLOUDSMITH_NPM_REGISTRY"
npm config set "$CLOUDSMITH_NPM_AUTH_CONFIG"

echo "NPM has been configured with the following:"
echo ""
echo "registry=$CLOUDSMITH_NPM_REGISTRY"
echo "//npm.$CLOUDSMITH_NPM_AUTH_CONFIG"