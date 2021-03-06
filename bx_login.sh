#!/bin/sh

if [ -z $CF_ORG ]; then
  CF_ORG="$BLUEMIX_ORG"
fi
if [ -z $CF_SPACE ]; then
  CF_SPACE="$BLUEMIX_SPACE"
fi

if [ -z "$BLUEMIX_API_KEY" ]; then
  echo "Standard user-pass login"
else
  if [ -z "$BLUEMIX_USER" ] || [ -z "$BLUEMIX_PASSWORD" ] || [ -z "$BLUEMIX_ACCOUNT" ]; then
   echo "Define all required environment variables and rerun the stage."
   exit 1
  fi
fi
echo "Deploy pods"

echo "bx login -a $CF_TARGET_URL"
if [ -z "$BLUEMIX_API_KEY" ]; then
  bx login -a "$CF_TARGET_URL" -u "$BLUEMIX_USER" -p "$BLUEMIX_PASSWORD" -c "$BLUEMIX_ACCOUNT" -o "$CF_ORG" -s "$CF_SPACE" -a "$BLUEMIX_API_URL"
else
  bx login --apikey "$BLUEMIX_API_KEY" -o "$CF_ORG" -s "$CF_SPACE" -a https://api.eu-de.bluemix.net
fi
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to Bluemix"
  exit 1
fi

# Init container clusters
echo "bx cs init"
bx cs init
if [ $? -ne 0 ]; then
  echo "Failed to initialize to Bluemix Container Service"
  exit 1
fi
