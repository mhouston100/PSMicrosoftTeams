# PSMicrosoftTeams - PRTG Notification Example

# Description

This example script is to replace or suplement email notifications in PRTG. The notification includes state and sensor details as well as action buttons for responding tothe alert.

This is configured as a PRTG 'EXE' notification.

**NOTE:** I was unable to get it to reference the module stored elswere, the only way I could get it to work was storing the module in a sub-folder of the script itself.

The basic operation is:

* Copy script and module to PRTG the PRTG notification folder
* Configure with EXE notification command
* Attach to sensors

## Install

### Requirements

* EXE / Script notification configured and working for PRTG

## Configuration

1. Copy the script and module to the PRTG 'Notifications' directory:

```
<program files>\PRTG\Application\PRTG Network Monitor\Notifications\EXE
```

2. Create a new notification through 'Setup --> Account Settings --> Notifications'

3. Select the Execute Program section as:

**'Program File'**

```
Send-SensorNotification.ps1
```

**Parameter**

```
-sensor '%sensor' -sensorID %sensorid -status '%status' -message '%message' -since '%since' -lastup '%lastup' -device '%device' -sensorURL '%linksensor' -deviceURL '%linkdevice' -serviceURL '%serviceurl'
```

4. Attach the new notification to the sensors


## Example

![Example-PRTGNotification](/Examples/PRTG/Images/Example-PRTGNotification.jpg)