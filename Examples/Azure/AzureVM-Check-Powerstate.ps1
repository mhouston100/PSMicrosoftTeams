#Requires -modules AzureRM.Compute, AzureRM.Profile, PSMicrosoftTeams
param (
    [parameter(Mandatory,HelpMessage = "URI for your MS Teams Channel Webhook")]
    [string]$URI,
    [parameter(Mandatory,HelpMessage = "Azure Tenant subscription, can be subscription name or GUID")]
    [string]$subscription,
    [parameter(HelpMessage = "Optionally provide VM resource groups to search, otherwise all VMs from all RGs will be returned")]
    [string[]]$resourceGroups
)

try {
    Write-Host "Selecting subscription $subscription..." -NoNewline
    Select-AzureRmSubscription $subscription -ErrorAction Stop| Out-Null
    Write-Host "Success"
}
catch { Write-Host "Fail" -ForegroundColor Red; $_ }

try {
    Write-Host "Gathering VM PowerStates..." -NoNewline
    $vm = Get-AzureRMVM -Status -ErrorAction Stop   
    Write-Host "Success"
    #filter VMs by resource group if user provided
    if ($resourceGroups) {
        $vm = $vm | Where-Object {$_.ResourceGroupName -in $resourceGroups}        
    }
    #Return all unique resourcegroupnames to use for count
    else {
        $resourceGroups = $vm.ResourceGroupName | sort -Unique
    }
}
catch { Write-Host "Fail" -ForegroundColor Red; $_  }

$powerState = $vm | group powerstate

#Burning money on a Guest OS shutdown
if ($powerstate.name -contains "VM stopped"){
    $messageType = "Warning"
    $activityTitle = "Power States include stopped VMs"
}
#Deallocated VMs, why
elseif ($powerState.Name -contains "VM deallocated"){    
    $messageType = "Information"
    $activityTitle = "Power States include deallocated VMs"
}
#Servers UP
else {
    $activityTitle = "Power State - Running"
    $messageType = "Success"
}

$messageTitle = "VM status in $subscription"
$messageBody = "$($vm.Count) VMS in $($resourceGroups.Count) Resource Groups"
$details = $powerState | foreach {  
    if ($_.Name -notmatch "running")
    {
        @{
            name  = $_.Name
            value = ("$($_.Count)" + " - " + "$($_.Group.name -join ',')")
        }
    }
    else
    { 
        @{
            name  = $_.Name
            value = $_.Count
        }
    }
}
try {
    Write-Host "Sending Team Channel Message..." 
    Send-TeamChannelMessage -messageType $messageType -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -details $details -URI $URI -ErrorAction Stop    
}
catch {
    Write-Host "Fail" -ForegroundColor Red; $_ 
}