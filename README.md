# MySql Server and NodeJS running in App Service on Azure

https://docs.microsoft.com/en-us/azure/app-service/quickstart-nodejs?tabs=windows&pivots=development-environment-vscode
https://docs.microsoft.com/en-us/azure/app-service/provision-resource-t
https://docs.microsoft.com/en-us/azure/app-service/provision-resource-terraformerraform
https://gist.github.com/simonbrady/ca39e44f15f09f03778dc88fc2f86b72
https://docs.microsoft.com/en-us/azure/app-service/scripts/terraform-secure-backend-frontend?source=recommendations

## ACR
<!-- docker login crfptcpacr.azurecr.io
docker tag api crfptcpacr.azurecr.io/api:latest
docker push crfptcpacr.azurecr.io/api:latest -->
az acr login --name crfptcpacr
docker-compose up --build -d
docker-compose down
docker-compose push