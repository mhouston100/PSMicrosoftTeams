[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [parameter(Mandatory = $true, HelpMessage = "Paste the URI for your webhook")]
	[ValidateNotNullOrEmpty()]
    [string]$URI,
    [parameter(HelpMessage = "Test image")]
	[ValidateNotNullOrEmpty()]
    [string]$messageType = "Success"
)

Import-Module .\PSMicrosoftTeams.psm1

Send-TeamChannelMessage -messageType $messageType -messageTitle "This is a test message Title" -messageBody "This is a test message Body" -activityTitle "This is a test message Activity Title" -activitySubtitle "This is a test message Activity Subtitle" -URI $URI