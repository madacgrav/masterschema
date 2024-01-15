targetScope = 'subscription'

@description('The name of the storage account')
param location string = deployment().location

@description('The name of the storage account')
param resourceGroupName string

var storageAccounts = (loadJsonContent('resources.json')).storage_accounts.storageaccountList
var storageAccountModuleVersion = (loadJsonContent('resources.json')).storage_accounts.moduleVersion

var keyVaultModuleVersion = (loadJsonContent('resources.json')).keyvaults.moduleVersion
var keyvaults = (loadJsonContent('resources.json')).keyvaults.keyvaultList
var blobServices = (loadJsonContent('resources.json')).blob_services
var containers = (loadJsonContent('resources.json')).storage_containers
var storageAccountModuleFileName = './modules/storageAccount_${storageAccountModuleVersion}.bicep'
var keyVaultModuleFileName = './modules/keyvault_${keyVaultModuleVersion}.bicep'


resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// figure out how to make file name dynamic
module stgModule './modules/storageAccount_2022-09-01.bicep' = {
  name: '${deployment().name}-storageDeploy'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    storageAccounts: storageAccounts
    containers: containers
    blobServices: blobServices
    location: location
  }
}

module kvModule './modules/keyvault_2021-11-01-preview.bicep' = {
  name: '${deployment().name}-keyvaultDeploy'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    keyvaults: keyvaults
    location: location
  }
}
