<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	22/11/2017 12:36 PM
	 Created by:   	adminMHouston
	 Organization: 	
	 Filename:     	PSMicrosoftTeams.psm1
	-------------------------------------------------------------------------
	 Module Name: PSMicrosoftTeams
	===========================================================================
#>

function Send-TeamChannelMessage
{
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateSet("Information", "Warning", "Critical")]
		[string]$messageType,
		[Parameter(Mandatory = $true)]
		[string]$messageBody,
		[Parameter(Mandatory = $true)]
		[string]$messageTitle,
		[string]$activityTitle,
		[array]$details,
		[Parameter(Mandatory = $true)]
		[string]$URI
	)
	
	Switch ($messageType)
	{
		{ $_ -eq "Information" } { $notify = $true; $titleColor = "green"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/128/green-ok-icon.png" }
		{ $_ -eq "Warning" } { $notify = $true; $titleColor = "orange"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/256/yellow-cross-icon.png" }
		{ $_ -eq "Critical" } { $notify = $true; $titleColor = "red"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/128/red-cross-icon.png" }
	}
	
	$body = ConvertTo-Json -Depth 6 @{
		title    = "$($messageTitle)"
		text	 = " "
		sections = @(
			@{
				activityTitle    = "$($activityTitle)"
				activitySubtitle = " "
				activityImage    = "$imageLink"
			},
			@{
				title = 'Details'
				facts = $details
<#				potentialAction = @(@{
						'@context' = 'http://schema.org'
						'@type'    = 'ViewAction'
						name	   = 'Button Name'
						target	 = @("https://google.com.au")
					}
				)#>
			}
		)
		
	}
	$body
	Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
}

Export-ModuleMember -Function *



