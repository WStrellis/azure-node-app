An app for learning azure
Create Resource Group

Create App Service Plan

Create web app
```
az webapp up \
--name westleysapp
--resource-group $RESOURCE_GROUP \
--runtime "NODE|14-lts" \
--logs \
--os-type Linux \
--sku P1V2 \
--location eastus
```