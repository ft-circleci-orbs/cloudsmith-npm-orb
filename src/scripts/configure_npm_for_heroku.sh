#!/bin/bash

# shellcheck disable=SC2016
# shellcheck disable=SC2129

set +e
# Change to working directory (defaults to .)
cd "$WORKING_DIR" || exit

# Check if npm is installed
if ! command -v npm &> /dev/null
then
  echo "npm is not installed. Please install npm before running this script."
  exit 1
fi

# Check if NPM_REGISTRY and NPM_AUTH_CONFIG are set
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

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null
then
    echo "Heroku CLI could not be found. Please install it to proceed."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install it to proceed."
    exit 1
fi

# Check if APP_NAME is set
if [ -z "$APP_NAME" ]
then
  echo "Unable to configure NPM. Env var APP_NAME is not defined. Please specify it as a parameter in your circleci job."
  exit 1
fi

# Set environment variables via Heroku CLI
heroku config:set NPM_REGISTRY="registry=$CLOUDSMITH_NPM_REGISTRY" --app "$APP_NAME"
heroku config:set NPM_TOKEN="$CLOUDSMITH_NPM_AUTH_CONFIG" --app "$APP_NAME" &>/dev/null # Silencing output as it contains an auth token

# Check if package.json exists
if [ ! -f package.json ]; then
    echo "Looking for package.json in $(pwd)"
    echo "Unable to configure heroku-prebuild scripts. package.json does not exist."
    exit 1
fi

# Check if the scripts block exists
scripts_block_exists=$(grep -o '"scripts":' package.json)

# Check if heroku-prebuild exists
heroku_prebuild_exists=$(grep -o '"heroku-prebuild":' package.json)

if [ -n "$scripts_block_exists" ] && [ -n "$heroku_prebuild_exists" ]; then
    echo "heroku-prebuild script already exists. Exiting."
    exit 1
else [ -n "$scripts_block_exists" ]; then
    # Add or create heroku-prebuild to existing scripts block
    echo "Adding heroku-prebuild to scripts."
    jq '.scripts["heroku-prebuild"] = "npm config set $NPM_REGISTRY ; npm config set $NPM_TOKEN"' package.json > package.tmp && mv package.tmp package.json
fi

# Check if the JSON file is valid
if ! jq empty "package.json" >/dev/null 2>&1; then
    echo "could not parse json file. File may be malformed. Exiting."
    exit 1
fi
