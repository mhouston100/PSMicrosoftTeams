#requires -version 2
<#
.SYNOPSIS
  Checks for new Software requests in SCCM and reports to Teams / Email for actioning
.DESCRIPTION
  Checks for new Software requests in SCCM and reports to Teams / Email for actioning
.PARAMETER <Parameter_Name>
   <None>
.INPUTS
  <None>
.OUTPUTS
  <None>
 
.EXAMPLE
  .\SCCM-Check-Software-Requests.ps1
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Import PSMicrosoftTeams Module - See https://github.com/mhouston100/PSMicrosoftTeams

Import-Module PSMicrosoftTeams

#Import CimCmdlets For handling WMI easier

import-module CimCmdlets

# Proxy

$global:PSDefaultParameterValues = @{
                                        'Invoke-RestMethod:Proxy'='http://CorpProxy:3128'
                                        'Invoke-WebRequest:Proxy'='http://CorpProxy:3128'
                                        '*:ProxyUseDefaultCredentials'=$true
                                    }

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

# How often to check in minutes - Should match how often the script is run for 
$Delay = 60 

#Site Code
$SiteCode = '<SCCM Site Code>'

#Webhook
$TeamsURI = "<Webhook URI>"


#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Query Site Server via WMI for Pending Requests

$Requests = Get-CimInstance -Namespace "root/SMS/site_$SiteCode" -Query "select * from SMS_UserApplicationRequest Where CurrentState = 1"

# Loop through requests
foreach ($Request in $Requests)
{
    #Check datetime and filter out old requests
    $Timespan = New-TimeSpan -Minutes $Delay
    if ($Request.LastModifiedDate -gt (Get-Date) - $timespan) 
    {
        #Variables for Teams Notification

        $messageTitle = "An Application has been requested by $($request.LastModifiedBy)"
        $messageBody = " "
        $activityTitle = "$($request.Application) - $($request.LastModifiedBy)"
        $details = @(
	                   @{
		                    name  = 'Application Name'
		                    value = $request.Application
	                    },
	                   @{
		                    name  = 'User'
		                    value = $request.LastModifiedBy
	                    },
	                   @{
		                    name  = 'Modified Time'
		                    value = Get-Date($request.LastModifiedDate) -Format g
	                    }
                    )

        #Send a Team Notification

        Send-TeamChannelMessage -messageType Information -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -details $details -URI $TeamsURI
    }
}
