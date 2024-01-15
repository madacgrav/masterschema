@description('Location for all resources.')
param location string

param keyvaults array


resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = [for kv in keyvaults:{
  name: kv.name
  location: location
  properties: {
    enableSoftDelete: true
    tenantId: subscription().tenantId
    accessPolicies: ((!empty(kv.access_policies)) ? kv.access_policies : [])
    sku: {
      name: kv.sku_name
      family: 'A'
    }
    networkAcls: ((!empty(kv.networkAcls)) ? kv.networkAcls : null)
  }
}
]
