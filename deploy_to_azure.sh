#!/bin/bash

APP_NAME=$1
# RESOURCE_GROUP=$1
# APP_SERVICE_PLAN=$2
RESOURCE_GROUP="$APP_NAME-rg"
APP_SERVICE_PLAN="$APP_NAME-asp"

echo "App name is: $APP_NAME"
echo "RESOURCE_GROUP is $RESOURCE_GROUP"
echo "APP_SERVICE_PLAN is $APP_SERVICE_PLAN"

# Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP"
az group create \
--location eastus \
--name $RESOURCE_GROUP

# Create web app
echo "Creating web app"
az webapp up \
--name westleysapp \
--resource-group $RESOURCE_GROUP \
--plan $APP_SERVICE_PLAN \
--runtime "NODE|14-lts" \
--sku P1V2 \
--logs \
--os-type Linux \
--location eastus