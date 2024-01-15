@description('Location for all resources.')
param location string

@description('The list of storage accounts to be created.')
param storageAccounts array 

@description('The list of blob services to be created.')
param blobServices array

@description('The list of containers to be created')
param containers array

resource StorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = [for sa in storageAccounts: {
  name: sa.name
  location: location
  sku: {
    name: sa.sku.name
  }
  kind: sa.kind
  properties: {
    accessTier: ((!empty(sa.accessTier)) ? sa.accessTier : null)
    allowBlobPublicAccess: sa.allowBlobPublicAccess
    allowSharedKeyAccess: sa.allowSharedKeyAccess
    azureFilesIdentityBasedAuthentication: ((!empty(sa.azureFilesIdentityBasedAuthentication)) ? sa.azureFilesIdentityBasedAuthentication : null)
    customDomain: ((!empty(sa.customDomain)) ? sa.customDomain : null)
    defaultToOAuthAuthentication: sa.defaultToOAuthAuthentication
    dnsEndpointType: ((!empty(sa.dnsEndPointType)) ? sa.dnsEndPointType : null)
   // encryption: ((!empty(sa.encryption)) ? sa.encryption : null)
    isHnsEnabled: sa.isHnsEnabled
    isNfsV3Enabled: sa.isNfsV3Enabled
    isSftpEnabled: sa.isSfsEnabled
    keyPolicy: ((!empty(sa.keypolicy)) ? sa.keypolicy : null)
    largeFileSharesState: ((!empty(sa.largeFileSharesState)) ? sa.largeFileSharesState : null)
    networkAcls: ((!empty(sa.networkAcls)) ? sa.networkAcls : null)
    publicNetworkAccess: ((!empty(sa.publicNetworkAccess)) ? sa.publicNetworkAccess : null)
    routingPreference: ((!empty(sa.routingprefrence)) ? sa.routingprefrence : null)
    sasPolicy: ((!empty(sa.sasPolicy)) ? sa.sasPolicy : null)
    supportsHttpsTrafficOnly: sa.supportsHttpsTrafficOnly
  }
}
]


resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = [for blob in blobServices: {
  name: '${blob.storage_account_parent}/default'
  properties: {
    cors: blob.cors
    deleteRetentionPolicy: blob.delete_retention_policy
    isVersioningEnabled: blob.isversioning_enabled
  }
  dependsOn: [
    StorageAccount
  ]
}
]

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for item in containers: {
  name: '${item.storage_account_parent}/default/${item.name}'
  properties: {
    publicAccess: item.publicAccess
   // defaultEncryptionScope: 'default'
    //denyEncryptionScopeOverride: item.denyEncryptionScopeOverride
   // enableNfsV3AllSquash: item.enableNfsV3AllSquash
   // enableNfsV3RootSquash: item.enableNfsV3RootSquash
  }
  dependsOn: [
    blobService
  ]
}
]
