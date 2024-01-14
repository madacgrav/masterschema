try {

    $import = Get-Content '.\resources.json' | ConvertFrom-Json
    $location = "eastus"
    $resourceGroupName = $import.resource_group.name

    $deploymentJSONBody = [PSCustomObject][Ordered]@{
        '$schema'        = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"
        "contentVersion" = "1.0.0.0"
        "parameters"     = [PSCustomObject][Ordered]@{
            "storageAccounts" = [PSCustomObject][Ordered]@{
                "value" = $import.storage_accounts
            }
            "blobServices"    = [PSCustomObject][Ordered]@{
                "value" = $import.blob_services
            }
            "containers"      = [PSCustomObject][Ordered]@{
                "value" = $import.storage_containers
            }
            "keyvaults"      = [PSCustomObject][Ordered]@{
                "value" = $import.keyvaults
            }
            "mssqlservers"      = [PSCustomObject][Ordered]@{
                "value" = $import.mssql_servers
            }
            "mssqldatabases"      = [PSCustomObject][Ordered]@{
                "value" = $import.mssql_databases
            }
        }
    }

    $RGdeploymentJSONBody = [PSCustomObject][Ordered]@{
        '$schema'        = "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#"
        "contentVersion" = "1.0.0.0"
        "parameters"     = [PSCustomObject][Ordered]@{
            "rgName" = [PSCustomObject][Ordered]@{
                "value" = $import.resource_group.name
            }
        }
    }

    $RGdeploymentJSONBody |  ConvertTo-Json -Depth 100 | Out-File -FilePath .\rg.deployment.parameters.json

    $deploymentJSONBody |  ConvertTo-Json -Depth 100 | Out-File -FilePath .\deployment.parameters.json

    write-host "az deployment sub create --name bicepSubDeployment --location $location --template-file .\rg_main.bicep --parameters rg.deployment.parameters.json" -ForegroundColor Yellow
    
    write-host "az deployment group create --name bicepRGDeployment --resource-group $resourceGroupName --template-file .\main.bicep --parameters deployment.parameters.json" -ForegroundColor Yellow
}
catch {
    write-host "Error: " + $_
}


