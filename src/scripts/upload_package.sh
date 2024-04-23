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

# Check if the dist directory exists and is valid
if [ -d "$DIST_DIR" ]; then
  echo "$DIST_DIR is a valid directory."
else
  echo "$DIST_DIR is not a directory."
  exit 1
fi

# check if apt-get or apk is installed and install python3-pip/py3
if command -v apt-get &> /dev/null
then
  apt-get update
  apt-get install -y python3-pip
elif command -v apk &> /dev/null
then
  apk add py3-pip
else
  echo "Neither apt-get nor apk is installed. Exiting."
  exit 1
fi

# Install cloudsmith-cli via Cloudsmith
pip install cloudsmith-cli --extra-index-url="$CLOUDSMITH_PIP_INDEX_URL"

# Check there are tar.gz to upload
LS_TAR_GZ_CMD="ls -A ${DIST_DIR}/*.tar.gz"

if [ -z "$($LS_TAR_GZ_CMD)" ]
then
  echo "$DIST_DIR does not contain any tar.gz or files to upload."
  exit 1
fi

# Upload source distribution if present
for filename in "$DIST_DIR"/*.tar.gz
do
  [ -f "$filename" ] || continue

  echo "Uploading source distribution $filename to Cloudsmith repository $CLOUDSMITH_ORGANISATION/$CLOUDSMITH_REPOSITORY ..."

  cloudsmith push npm --verbose --api-key "$CLOUDSMITH_OIDC_TOKEN" "$CLOUDSMITH_ORGANISATION/$CLOUDSMITH_REPOSITORY" "$filename"

  echo ""
  echo "Package upload and synchronisation completed OK."
done
