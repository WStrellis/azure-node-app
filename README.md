An app for learning azure

Create environment  variables for connecting to Azure Mysql DB
```
az webapp config appsettings set --name <app-name> --resource-group myResourceGroup --settings MONGODB_URI="mongodb://<cosmosdb-name>:<primary-master-key>@<cosmosdb-name>.documents.azure.com:10250/mean?ssl=true"
```

Enable console logs for AZ Web App
```
az webapp log config --resource-group <resource-group-name> --name <app-name> --application-logging true --level Verbose
```

See log stream for AZ web app
```
az webapp log tail --resource-group <resource-group-name> --name <app-name>
```