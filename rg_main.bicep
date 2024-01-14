targetScope = 'subscription'

@description('The name of the storage account')
param rgName string

@description('The name of the storage account')
param location string = deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}
