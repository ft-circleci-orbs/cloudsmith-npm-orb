#!/bin/bash

# shellcheck disable=SC2016
# shellcheck disable=SC2129

# Check required environment variables are set and look valid
if [ -z "$CLOUDSMITH_ORGANISATION" ]
then
  echo "Unable to upload package. Env var CLOUDSMITH_ORGANISATION is not defined."
  exit 1
fi
if [ -z "$CLOUDSMITH_REPOSITORY" ]
then
  echo "Unable to upload package. Env var CLOUDSMITH_REPOSITORY is not defined."
  exit 1
fi
if [ -z "$CLOUDSMITH_OIDC_TOKEN" ]
then
  echo "Unable to upload package. Env var CLOUDSMITH_OIDC_TOKEN is not defined."
  exit 1
fi

# Check if the dist directory exists and is valid
if [ -d "$DIST_DIR" ]; then
  echo "$DIST_DIR is a valid directory."
else
  echo "$DIST_DIR is not a directory."
  exit 1
fi

# Check there are tgz to upload
LS_TAR_GZ_CMD="ls -A ${DIST_DIR}/*.tgz"

if [ -z "$($LS_TAR_GZ_CMD)" ]
then
  echo "$DIST_DIR does not contain any tgz or files to upload."
  exit 1
fi

# Upload package if present
for filename in "$DIST_DIR"/*.tgz
do
  [ -f "$filename" ] || continue

  echo "Uploading npm package $filename to Cloudsmith repository $CLOUDSMITH_ORGANISATION/$CLOUDSMITH_REPOSITORY ..."

  cloudsmith push npm --verbose --api-key "$CLOUDSMITH_OIDC_TOKEN" "$CLOUDSMITH_ORGANISATION/$CLOUDSMITH_REPOSITORY" "$filename"

  echo ""
  echo "Package upload and synchronisation completed OK."
done
