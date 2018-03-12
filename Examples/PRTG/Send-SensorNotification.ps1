#PRTG Sensor Notification Example:


param(
    [string]$sensor,
    [string]$sensorid,
    [string]$status,
    [string]$message,
    [string]$device,
    [string]$since,
    [string]$lastup,
    [string]$sensorURL,
    [string]$deviceURL,
    [string]$serviceURL
)

################
# Configuration 
################

Import-Module "<path to module>\PSMicrosoftTeams"

#PRTG Server, e.g. http://prtg.paessler.com
$PRTGServer = "https://server/"
$PRTGUsername = "admin"
$PRTGPasshash  = #<enter your password hash>

#Acknowledgement Message for alerts ack'd via Teams
$ackmessage = "Problem has been acknowledged via Teams chat."
$pauseMessage = "Sensor has been paused via Teams chat"

#Directory for logging
$logDirectory = "C:\temp\prtg-notifications-msteam.log"

# configure this URL to be your actual webhook URL
$uri = #<enter your URL>

# the acknowledgement URL 
$ackURL = [string]::Format("{0}/api/acknowledgealarm.htm?id={1}&ackmsg={2}&username={3}&passhash={4}", $PRTGServer, $sensorID, $ackmessage, $PRTGUsername, $PRTGPasshash);

$pauseURL = [string]::Format("{0}/api/pauseobjectfor.htm?id={1}&duration=60&pausemsg={2}&username={3}&passhash={4}", $PRTGServer, $sensorID, $pauseMessage, $PRTGUsername, $PRTGPasshash);


#region type
# set the type of message, decides the image type included
switch ($status)
{
	"Down ended (now: Paused)" { $messageType = "Information" }
	"Down (Acknowledged)"  { $messageType = "Warning" }
	"Down ended (now: Warning)" { $messageType = "Warning" }
	"Up" { $messageType = "Success" }
	"Down ESCALATION"  { $messageType = "Critical" }
	"Down"  { $messageType = "Critical" }
	Default
	{
		$messageType = "Information"
	}
}
#endregion type

#region title
# the title of your message, different templates for not up, up and acknowledged
if ($status -ne "Up")
{
	$messageTitle = [string]::Format("Device {0} is reported in a {1} state!", $device, $status)
	$messageBody = [string]::Format("{0} on {1} is in a {2} state!", $sensor, $device, $status)
}
elseif ($status -eq "Up")
{
	$messageTitle = [string]::Format("Device {0} has returned to an {1} state!", $device, $status)
	$messageBody = [string]::Format("{0} on {1} is up again!", $sensor, $device); $ackURL = "";
}
elseif ($status -eq "Acknowledged")
{
	$messageTitle = [string]::Format("Device {0} has has been {1} by a technician.", $device, $status)
	$messageBody = [string]::Format("The problem with {0} on {1} has been acknowledged.", $sensor, $device); $ackURL = "";
}
#endregion title

#region activity
$activityTitle = "There has been a sensor state change on device $device"
$activitySubtitle = "Please see below for details and action buttons."
#endregion activity

#region details
$details = @(
	@{
		name  = 'Current State'
		value = $($status)
	},
	@{
		name  = 'Message'
		value = $($message)
	},
	@{
		name  = 'Since'
		value = $($since)
	},
	@{
		name  = 'Last up'
		value = $($lastup)
	},
	@{
		name  = 'Sensor'
		value = $($sensorURL)
	},
	@{
		name  = 'Device'
		value = $($deviceURL)
	}
)
#endregion details

#region buttons
$buttons = @(
	@{ name = 'Sensor Page'; value = @($sensorURL) },
	@{ name   = 'Device Page'; value = @($deviceURL)},
	@{ name   = 'Service URL'; value = @($serviceURL)},
	@{ name = 'Acknowledge Alert'; value = @($ackURL) }
	@{ name = 'Pause Sensor (1h)'; value = @($pauseURL) }
)
#endregion buttons

try
{
	Send-TeamChannelMessage -messageType $messageType -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -details $details -buttons $buttons -URI $URI; exit 0;
}
catch
{
	$ErrorMessage = $_.Exception.Message
	(Get-Date).ToString() + " - " + $ErrorMessage | Out-File -FilePath $LogDirectory -Append
	exit 2;
}