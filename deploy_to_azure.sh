#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Need app name and github url"
    exit 1
fi

APP_NAME=$1
RESOURCE_GROUP="$APP_NAME-rg"
APP_SERVICE_PLAN="$APP_NAME-asp"
DEPLOYMENT_URL=$2
DB_NAME="$APP_NAME-db"

echo "App name is: $APP_NAME"
echo "RESOURCE_GROUP is $RESOURCE_GROUP"
echo "APP_SERVICE_PLAN is $APP_SERVICE_PLAN"
echo "DEPLOYMENT_URL is $DEPLOYMENT_URL"
echo "DB_NAME is $DB_NAME"

# Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP"
az group create \
--location eastus \
--name $RESOURCE_GROUP
if [ $? -gt 0 ]; then 
     exit 1
fi

# create database
az mysql server create \
--resource-group $RESOURCE_GROUP \
--name $DB_NAME \
--location eastus \
--admin-user $DB_USER \
--admin-password $DB_PASSWORD \
--sku-name B_Gen5_1 \
--version 8.0
if [ $? -gt 0 ]; then 
     exit 1
fi
# get host and port from db

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

# Set environment variables for web app

# host
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings MYSQL_HOST=""
if [ $? -gt 0 ]; then 
    exit 1
fi

# port
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings MYSQL_PORT=$DB_PORT
if [ $? -gt 0 ]; then 
    exit 1
fi

# user
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings MYSQL_USER=$DB_USER
if [ $? -gt 0 ]; then 
    exit 1
fi

# password
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings MYSQL_PASSWORD=$DB_PASSWORD
if [ $? -gt 0 ]; then 
    exit 1
fi

# database
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings MYSQL_DB=node_app
if [ $? -gt 0 ]; then 
    exit 1
fi
