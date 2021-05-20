An app for learning azure

create a database for local testing:  
```
dk run -d --name postgres11 \
-e POSTGRES_PASSWORD=$PG_PASSWORD \
-e POSTGRES_DB=$PG_DB \
-e POSTGRES_USER=$PG_USER \
-p 5432:5432 \
-v $(pwd)/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
-v $(pwd)/scripts:/scripts \
postgres:11
```

Create environment  variables for connecting to Azure Mysql DB
```
az webapp config appsettings set --name <app-name> --resource-group myResourceGroup \
--settings PG_HOST=$PG_HOST \
PG_DB=$PG_DB \
PG_USER=$PG_USER \
PG_PASSWORD=$PG_PASSWORD 
```

Enable console logs for AZ Web App
```
az webapp log config --resource-group <resource-group-name> --name <app-name> --application-logging true --level Verbose
```

See log stream for AZ web app
```
az webapp log tail --resource-group <resource-group-name> --name <app-name>
```