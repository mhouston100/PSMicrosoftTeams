
param(
    [string]$RequestID,
    [string]$Requester,
    [string]$CreatedTime,
    [string]$Subject,
    [string]$SLA,
    [string]$requestType
)

################
# Configuration 
################

Import-Module "<path to module>\PSMicrosoftTeams"

#Directory for logging
$logDirectory = "D:\Log\customaction.log"

# configure this URL to be your actual webhook URL
$uri = #<insert URI here>
$SDPServer = "https://<your SDP server address>"

# Message Type
$messageType = "Information"
$messageTitle = "$Subject"
$messageBody = "IT Support Desk Ticket Recieved"

If ($SLA -eq '$SLA'){$SLA = "No SLA assigned"}

#region activity
$activityTitle = "A new ticket has been received #$RequestID"
$activitySubtitle = "Requester - $Requester"
#endregion activity

#region details
$details = @(
	@{
		name  = 'Request ID'
		value = $($RequestID)
	},
	@{
		name  = 'Requester'
		value = $($Requester)
	},
	@{
		name  = 'Created Time'
		value = $($CreatedTime)
	},
	@{
		name  = 'Subject'
		value = $($Subject)
	},
	@{
		name  = 'SLA'
		value = $($SLA)
	}
)
#endregion details

#region buttons
$buttons = @(
	@{ name = 'Go to Ticket'; value = @("$SDPServer/WorkOrder.do?woMode=viewWO&woID=$RequestID")},
    @{ name = 'Pickup Ticket'; value = @("$SDPServer/AssignOwner.do?pickup=true&woID=$RequestID")}
)
#endregion buttons

try
{
	Send-TeamChannelMessage -messageType $messageType -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -activitySubtitle $activitySubtitle -details $details -buttons $buttons -URI $URI; exit 0;
}
catch
{
	$ErrorMessage = $_.Exception.Message
	(Get-Date).ToString() + " - " + $ErrorMessage | Out-File -FilePath $LogDirectory -Append
	exit 2;
}