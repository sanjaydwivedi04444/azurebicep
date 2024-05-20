param name string
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'appServiceTrick1234'
  location: resourceGroup().location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  dependsOn:[
    appServicePlan
  ]
  name: name
  location: resourceGroup().location
  properties: { serverFarmId: resourceId('Microsoft.Web/serverfarms','appServiceTrick1234') }
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'teststorage123sanjay'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'testlogicapp'
  location: resourceGroup().location
  properties: {
    definition: {
      '': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
    }
  }
}

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: 'testappinsights'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: 'testfunctionapp'
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms','appServiceTrick1234')
    siteConfig: {
      appSettings: [
        
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('name')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('testappinsights', '2015-05-01').InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}
