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

#Import-Module $env:CamPSModulePath\PSLogging
#Import-Module $env:CamPSModulePath\PSCamdenEmail

function Send-TeamChannelMessage
{
	Param(
		[Parameter(Mandatory = $true)][ValidateSet("Information", "Warning", "Critical")][string]$messageType,
		[Parameter(Mandatory = $true)][string]$messageBody,
		[Parameter(Mandatory = $true)][string]$messageTitle,
		[string]$activityTitle,
		$facts,
		[Parameter(Mandatory = $true)][string]$URI	
	)
	
	Switch ($messageType)
	{
		{ $_ -eq "Information" } { $notify = $true; $titleColor = "green"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/128/green-ok-icon.png" }
		{ $_ -eq "Warning" } { $notify = $true; $titleColor = "orange"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/256/yellow-cross-icon.png" }
		{ $_ -eq "Critical" } { $notify = $true; $titleColor = "red"; $imageLink = "http://icons.iconarchive.com/icons/double-j-design/origami-colored-pencil/128/red-cross-icon.png" }
	}
	
	$facts = @(
		
		@{
			name  = 'name1'
			value = 'value1'
		},
		@{
			name  = 'name2'
			value = 'value2'
		},
		@{
			name  = 'name3'
			value = 'value3'
		}
	)
	
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
				title		   = 'Details'
				facts		   = $facts
				potentialAction = @(@{
						'@context' = 'http://schema.org'
						'@type'    = 'ViewAction'
						name	   = 'Button Name'
						target	 = @("https://google.com.au")
					}
				)
			}
		)
		
	}
	$body
	#Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
}

Export-ModuleMember -Function *



