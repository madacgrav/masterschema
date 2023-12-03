@description('Location for all resources.')
param location string = resourceGroup().location

@description('The array of objects used to define a storage account')
param storageAccounts array = []

@description('The array of objects used to define a blob service within a storage account')
param blobServices array = []

@description('The array of objects used to define a containers within a blob serice')
param containers array = []

resource StorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = [for sa in storageAccounts: {
  name: sa.name
  location: location
  sku: {
    name: sa.sku.name
  }
  kind: sa.kind
  properties: ((!empty(sa.properties)) ? sa.properties : null)
}
]

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = [for blob in blobServices: {
  name: '${blob.storage_account_parent}/default'
  dependsOn: [
    StorageAccount
  ]
}
]

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for item in containers: {
  name: '${item.storage_account_parent}/default/${item.name}'
  properties: ((!empty(item.properties)) ? item.properties : null)
  dependsOn: [
    blobService
  ]
}
]
