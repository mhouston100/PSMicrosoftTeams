# PSMicrosoftTeams - GPO Notification Example

# Description

This example script will periodically check for any changes to current GPO's. A teams notification will be sent if it has been changed within X minutes, sending the GPO details and the name of the editor.

The basic operation is:

* Schedule script to run every 5 minutes
* Script checks if there have been any GPO changes in the last 5 minutes
* Notify Teams with any changes found

## Install

### Requirements

* Access to create scheduled tasks
* GPO Tools role or RSAT installed
* Service account with access to read GPO's

## Configuration

Configure this script as a scheduled task, by default every 5 minutes with the command:

**Program / Script**

```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

**Parameters**

```
-command "& '<path to script>\Send-GPOChangeNotification.ps1"'
```

## Example

![Example-GPONotification](/Examples/Group%20Policy/Images/Example-GPONotification.jpg)