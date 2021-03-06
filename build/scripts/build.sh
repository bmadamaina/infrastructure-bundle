#!/usr/bin/env bash

set -e

#  Environment variables:
#    - Required:
#      - AGENT_VERSION: Infra agent version that's being added.
#      - IMAGE_TAG: tag for the Docker image.
#      - WORKSPACE: Local workspace folder for the builder to fetch data from.

# Ensure AGENT_VERSION is set & non-empty
AGENT_VERSION=$(awk -F, '{if ($1 ~ /^newrelic-infra$/) {print $2}}' ${VERSIONS_FILE})
if [ -z "$AGENT_VERSION" ]; then
	echo "AGENT_VERSION is not set or empty"
	exit 1
fi

# Ensure JRE_VERSION is set & non-empty
JRE_VERSION=$(awk -F, '{if ($1 ~ /^jre$/) {print $2}}' ${VERSIONS_FILE})
if [ -z "$JRE_VERSION" ]; then
	echo "JRE_VERSION is not set or empty"
	exit 1
fi

# Ensure IMAGE_TAG is set & non-empty
if [ -z "$IMAGE_TAG" ]; then
	echo "IMAGE_TAG is not set or empty"
	exit 1
fi

# Ensure WORKSPACE is set & non-empty
if [ -z "$WORKSPACE" ]; then
	echo "WORKSPACE is not set or empty"
	exit 1
fi

# Ensure Dockerfile with labels was generated
if [ -z "$WORKSPACE/Dockerfile" ]; then
	echo "WORKSPACE/Dockerfile was not generated"
	exit 1
fi

docker build \
	--no-cache \
	-t $IMAGE_TAG \
	--build-arg agent_version=$AGENT_VERSION \
	--build-arg jre_version=$JRE_VERSION \
	-f ${WORKSPACE}/Dockerfile \
	.
