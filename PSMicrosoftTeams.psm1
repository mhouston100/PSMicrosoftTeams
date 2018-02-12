<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	22/11/2017 12:36 PM
	 Created by:   	Matthewh Houston	
	 Organization: 	
	 Filename:     	PSMicrosoftTeams.psm1
	-------------------------------------------------------------------------
	 Module Name: PSMicrosoftTeams
	===========================================================================
	.Synopsis
	Send a message to Micrsoft Teams.

	.Description
	Send a message to a Microsoft Teams 'Webhook' URI. This can include a title, description and details.

	.Parameter messageType
	The type of message to send, valid types are 'Information','Warning','Critical'. This will decide what icon to apply.

	.Parameter messageTitle
	The main message title, this heads up all the sections.

	.Parameter messageBody
	The main details of the message, which will appear below the messageTitle in the Teams card. This parameter is mutually exclusive with messageSummary (you may use one or the other but not both).
	
	.Parameter messageSummary
	The summary of the message, which does NOT appear below the messageTitle in the Teams card. This parameter is mutually exclusive with messageBody (you may use one or the other but not both).

	.Parameter activityTitle
	A sub-heading for sectioning off the message into parts. Currently implemented to separate the 'details' section.
	
	.Parameter activitySubtitle
	A sub-title under activityTitle for further detail.
	
	.Parameter details
	An array of hashtables to display key pairs of names and values. Use this to display specific technical information if required.
	
	.Parameter detailTitle
	A string value that serves as a header describing any details you may include.

	.Parameter Buttons
	An array of hashtables to display key pairs of names and links. Use this to display specific buttons/links below the activity.

	.Parameter URI
	The full URI provided when a webhook is created for an MS Teams channel

	.Example
	# Display a critical message, URI has been obfuscated

    Send-TeamChannelMessage -messageType Critical -messageTitle "Test Title" -messageBody "Test body" -activityTitle "test Activity" -activitySubtitle "Test Activity Subtitle" -URI "PUT YOUR WEBHOOK URI HERE" -details @(@{ name = 'name1'; value = 'value1' }, @{ name = 'name2'; value = 'value2' }, @{ name = 'name3'; value = 'value3' }) -buttons @(@{ name = 'Google'; value = 'https://www.google.com' }, @{ name = 'IT Support Desk'; value = 'https://itsupportdesk.com.au.au' }, @{ name = 'PRTG'; value = 'https://monitoring.com' })

#>

function Escape-JSONString($str){
	if ($str -eq $null) {return ""}
	$str = $str.ToString().Replace('"','\"').Replace('\','\\').Replace("`n",'\n\n').Replace("`r",'').Replace("`t",'\t')
	return $str
}

function Send-TeamChannelMessage
{
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateSet("Information", "Warning", "Critical")]
		[string]$messageType,
		[Parameter(Mandatory = $true)]
		[string]$messageTitle,
		[Parameter(
			Mandatory = $true,
			ParameterSetName='SetBody'
		)]
		[string]$messageBody,
		[Parameter(
			Mandatory = $true,
			ParameterSetName='SetSummary'
		)]
		[string]$messageSummary,
		[string]$activityTitle,
		[string]$activitySubtitle,
		[array]$details = $null,
		[string]$detailTitle,
		[array]$buttons = $null,
		[Parameter(Mandatory = $true)]
		[string]$URI
	)
	
	Switch ($messageType)
	{
		{ $_ -eq "Information" } { $notify = $true; $titleColor = "green"; $image = [convert]::ToBase64String((Get-Content "$PSScriptRoot\Images\Information.jpg" -Encoding byte)) }
		{ $_ -eq "Warning" } { $notify = $true; $titleColor = "orange"; $image = [convert]::ToBase64String((Get-Content "$PSScriptRoot\Images\Warning.jpg" -Encoding byte)) }
		{ $_ -eq "Critical" } { $notify = $true; $titleColor = "red"; $image = [convert]::ToBase64String((Get-Content "$PSScriptRoot\Images\Critical.jpg" -Encoding byte))}
	}
	
	If ($messageBody) {
		$TextOrSummary = 'text'
		$TextOrSummaryContents = $messageBody
	}
	If ($messageSummary) {
		$TextOrSummary = 'summary'
		$TextOrSummaryContents = $messageSummary
	}
	
	$potentialActions = @()
	
	foreach ($button in $buttons)
	{
		$potentialActions += @{
			'@context' = 'http://schema.org'
			'@type'    = 'ViewAction'
			name	   = $($button.Name)
			target	 = @("$($button.Value)")
		}
	}
	$TextOrSummaryContents = Escape-JSONString $($TextOrSummaryContents)
	$body = ConvertTo-Json -Depth 6 @{
		title    			= "$($messageTitle)"
		$($TextOrSummary)	= [System.Text.RegularExpressions.Regex]::Unescape($($TextOrSummaryContents))
		sections = @(
			@{
				activityTitle    = "$($activityTitle)"
				activitySubtitle = "$activitySubtitle"
				activityImage    = "data:image/png;base64,$image"
			},
			@{
				title = $detailTitle
				facts = $details
				potentialAction = @(
					$potentialActions
				)
			}
		)
		
	}
	$body

	Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
}

Export-ModuleMember -Function Send-TeamChannelMessage
