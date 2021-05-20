#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Need app name , github url, and workstation ip"
    exit 1
fi

APP_NAME=$1
RESOURCE_GROUP="$APP_NAME-rg"
APP_SERVICE_PLAN="$APP_NAME-asp"
DEPLOYMENT_URL=$2
DB_NAME="$APP_NAME-db"
MY_IP=$3

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
az postgres server create \
--resource-group $RESOURCE_GROUP \
--name $DB_NAME \
--location eastus \
--admin-user $DB_USER \
--admin-password $DB_PASSWORD \
--sku-name B_Gen5_1 \
--ssl-enforcement Disabled \
--public-network-access Disabled \
--version 11 
if [ $? -gt 0 ]; then 
     exit 1
fi

# add firewall rule to allow access from workstation
az postgres server firewall-rule create \
--resource-group $RESOURCE_GROUP \
--server $DB_NAME\
--name AllowMyIP \
--start-ip-address $MY_IP \
--end-ip-address $MY_IP
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

# get ip of web app
WEBAPP_IP=$()

# add firewall rule to allow access to db from web app
az postgres server firewall-rule create \
--resource-group $RESOURCE_GROUP \
--server $DB_NAME\
--name AllowWebApp \
--start-ip-address $WEBAPP_IP \
--end-ip-address $WEBAPP_IP
if [ $? -gt 0 ]; then 
     exit 1
fi

# Set environment variables for web app
az webapp config appsettings set \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--settings \
PG_HOST=$PG_HOST \
PG_PORT=$PG_PORT \
PG_USER=$PG_USER \
PG_PASSWORD=$PG_PASSWORD \
PG_DB=$PG_DB
if [ $? -gt 0 ]; then 
    exit 1
fi
