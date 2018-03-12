<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	5/03/2018 2:06 PM
	 Created by:   	
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
	[parameter(Mandatory = $true, HelpMessage = "Specify Started, Failed or Success")]
	[ValidateNotNullOrEmpty()]
	[string]$message
	
)

Import-Module ".\PSMicrosoftTeams"

#region Variables

$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment

$URI = #<insert URI here>

# Date and Time
$DateTime = Get-Date -Format g #Time

# Time
$Time = get-date -format HH:mm

# Computer Make
$Make = (Get-WmiObject -Class Win32_BIOS).Manufacturer

# Computer Model
$Model = (Get-WmiObject -Class Win32_ComputerSystem).Model

# Computer Name 
If ($tsenv.Value("_SMSTSInWinPE"))
{
	$Name = $tsenv.Value("OSDComputerName")
}
else
{
	$Name = (Get-WmiObject -Class Win32_ComputerSystem).Name
}

# Computer Serial Number
[string]$SerialNumber = (Get-WmiObject win32_bios).SerialNumber

# IP Address of the Computer
$IPAddress = (Get-WmiObject win32_Networkadapterconfiguration | Where-Object{ $_.ipaddress -notlike $null }).IPaddress | Select-Object -First 1
#endregion Variables

switch ($message) {
	Started {
		$messageType = "Information"
		$messageTitle = "$name - OS Build Started"
		$messageBody = "The build for machine $Name has started."
		
	}
	Failed {
		$messageType = "Failed"
		$messageTitle = "$name - OS Build Failed!"
		$messageBody = "The build for machine $Name has failed."
	}
	Success {
		$messageType = "Success"
		$messageTitle = "$name - OS Build Completed"
		$messageBody = "The build for machine $Name has started."
	}
}

$activityTitle = "Build Name : $($tsenv.Value("_SMSTSPackageName"))"
$activitySubtitle = "Description : $($tsenv.Value("OSDImageDescription"))"
$details = @(
		@{
			name  = 'Name'
			value = $Name
		},
		@{
			name  = "Time"
			value = "$DateTime"
		},
		@{
			name  = 'IP Addresss'
			value = $IPAddress
		},
		@{
			name  = 'Make'
			value = $Make
		},
		@{
			name  = 'Model'
			value = $Model
		},
		@{
			name  = 'Serial'
			value = $SerialNumber
		}
	)

Send-TeamChannelMessage -messageType $messageType -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -details $details -URI $URI
