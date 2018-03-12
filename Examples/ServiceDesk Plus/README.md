# PSMicrosoftTeams - ManageEngine ServiceDesk Plus Notification Example

# Description

This example sends a notification when a new ticket is received in SDP.

This is a very basic notification but also includes buttons to access the ticket or pick up the ticket (if the users is a technician).

**NOTE:** I was unable to get this to script to access the module from a different location, the module will need to be store in a subfolder of the script itself

The basic operation is:

* Copy the script and module to the 'Integrations' folder in the SDP program directory
* Create a 'Custom Trigger' in SDP attached to new tickets
* Create a test ticket

## Install

### Requirements

* Fairly recent version of SDP with 'Custom Action' functionality

## Configuration

1. Copy the script and module to the folder '<program files>\ManageEngine\ServiceDesk\integration\custom_scripts'

2. Create a new 'Custom Trigger' - you can use whatever criteria you want, to ensure all tickets are covered I use:

![Example-CustomTrigger](/Examples/ServiceDesk%20Plus/Images/Example-CustomTrigger.jpg)

**Action Type**

```
Execute Script
```

**Script File to Run**

```
cmd /c start /wait powershell.exe -WindowStyle Hidden -file "<path to SDP>\ManageEngine\ServiceDesk\integration\custom_scripts\Send-NewTicketNotification\Send-NewTicketNotification.ps1" -RequestID "$WORKORDERID" -Requester "$REQUESTER" -CreatedTime "$CREATEDTIME" -Subject "$SUBJECT" -SLA "$SLA"
```

3. Save and test with a new ticket

### Example:

![Example-SDPNotification](/Examples/ServiceDesk%20Plus/Images/Example-SDPNotification.jpg)
