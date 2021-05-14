#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Need app name and github url"
    exit 1
fi

APP_NAME=$1
RESOURCE_GROUP="$APP_NAME-rg"
APP_SERVICE_PLAN="$APP_NAME-asp"
DEPLOYMENT_URL=$2

echo "App name is: $APP_NAME"
echo "RESOURCE_GROUP is $RESOURCE_GROUP"
echo "APP_SERVICE_PLAN is $APP_SERVICE_PLAN"
echo "DEPLOYMENT_URL is $DEPLOYMENT_URL"

# Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP"
az group create \
--location eastus \
--name $RESOURCE_GROUP
if [ $? -gt 0 ]; then 
     exit 1
fi

# Create App Service Plan
echo "Creating app service plan: $APP_SERVICE_PLAN"
az appservice plan create \
 --name $APP_SERVICE_PLAN\
 --resource-group $RESOURCE_GROUP \
 --is-linux \
 --location eastus \
 --sku P1V2 

if [ $? -gt 0 ]; then 
     exit 1
fi

# Create web app
echo "Creating web app"
az webapp create \
 --name $APP_NAME \
 --resource-group $RESOURCE_GROUP \
 --plan $APP_SERVICE_PLAN \
 --deployment-source-branch main \
 --deployment-source-url $DEPLOYMENT_URL \
 --runtime "NODE|14-lts" 
if [ $? -gt 0 ]; then 
    exit 1
fi

# Start web app
echo "Starting web app"
az webapp start \
--name $APP_NAME \
 --resource-group $RESOURCE_GROUP \
 --slot production 
if [ $? -gt 0 ]; then 
    exit 1
fi
