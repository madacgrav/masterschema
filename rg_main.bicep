targetScope = 'subscription'

@description('The name of the storage account')
param resourceGroupName string

@description('The name of the storage account')
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' {
  name: resourceGroupName
  location: location
}
