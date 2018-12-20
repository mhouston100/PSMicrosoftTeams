# PSMicrosoftTeams - Azure VM PowerState Example

# Description

This script checks the powerstate of all VMs in a subscription, or VMs in resource groups provided by the user.

## Requirements

* AzureRM.Compute for Get-AzureRMVM
* AzureRM.Profile for Select-AzureRMSubscription
* PSMicrosoftTeams, of course

## Parameters/Configuration
```powershell
$URI = 'YOUR_WEBHOOK_URI'
$subscription = 'YOUR_AZURE_SUBSCRIPTION'  
$resourceGroups = @()
Import-Module .\PSMicrosoftTeams
.\AzureVM-Check-Powerstate.ps1 -URI $uri -subscription $subscription -resourceGroups $resourceGroups
```

## Example

![Example-AzureVM](/Examples/Azure/Images/Example-AzureVMPowerstate.jpg)