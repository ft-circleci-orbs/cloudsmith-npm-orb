#!/bin/bash

# shellcheck disable=SC2016
# shellcheck disable=SC2129

set +e

if [ -z "$CLOUDSMITH_SERVICE_ACCOUNT" ] || [ -z "$CLOUDSMITH_OIDC_TOKEN" ]
then
  echo "Unable to find an OIDC token to use. Please ensure the cloudsmith-oidc/authenticate_with_oidc command has been run before this command."
  exit 1
fi

if [ -z "$CLOUDSMITH_REPOSITORY" ]
then
  echo "Unable to set environment variables for npm. Env var CLOUDSMITH_REPOSITORY is not defined."
  exit 1
fi

if [ -z "$CLOUDSMITH_DOWNLOADS_DOMAIN" ]
then
  echo "Unable to set environment variables for npm. Env var CLOUDSMITH_DOWNLOADS_DOMAIN is not defined."
  exit 1
fi

CLOUDSMITH_NPM_DOWNLOADS_DOMAIN="npm.$CLOUDSMITH_DOWNLOADS_DOMAIN"
CLOUDSMITH_NPM_REGISTRY="https://$CLOUDSMITH_NPM_DOWNLOADS_DOMAIN/$CLOUDSMITH_REPOSITORY/"
CLOUDSMITH_NPM_AUTH_CONFIG="//$CLOUDSMITH_NPM_DOWNLOADS_DOMAIN/$CLOUDSMITH_REPOSITORY/:_authToken=$CLOUDSMITH_OIDC_TOKEN"
CLOUDSMITH_NPM_REGISTRY_WITH_AUTH_CONFIG="$CLOUDSMITH_NPM_REGISTRY --$CLOUDSMITH_NPM_AUTH_CONFIG"

echo "export CLOUDSMITH_NPM_REGISTRY=\"$CLOUDSMITH_NPM_REGISTRY\"" >> "$BASH_ENV"
echo "export CLOUDSMITH_NPM_AUTH_CONFIG=\"$CLOUDSMITH_NPM_AUTH_CONFIG\"" >> "$BASH_ENV"
echo "export CLOUDSMITH_NPM_REGISTRY_WITH_AUTH_CONFIG=\"$CLOUDSMITH_NPM_REGISTRY_WITH_AUTH_CONFIG\"" >> "$BASH_ENV"

echo "The following environment variables have been exported. Note, the OIDC token has been masked below."
echo ""
echo "CLOUDSMITH_NPM_REGISTRY=https://$CLOUDSMITH_NPM_DOWNLOADS_DOMAIN/$CLOUDSMITH_REPOSITORY/"
echo "CLOUDSMITH_NPM_AUTH_CONFIG=//$CLOUDSMITH_NPM_DOWNLOADS_DOMAIN/$CLOUDSMITH_REPOSITORY/:_authToken=************"
echo "CLOUDSMITH_NPM_REGISTRY_WITH_AUTH_CONFIG=$CLOUDSMITH_NPM_REGISTRY --//$CLOUDSMITH_NPM_DOWNLOADS_DOMAIN/$CLOUDSMITH_REPOSITORY/:_authToken=************"
