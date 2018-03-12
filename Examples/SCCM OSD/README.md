# PSMicrosoftTeams - SCCM OSD Notification Example

# Description

This example script is run at several points in an SCCM Tasksequence to notify 'Starting', 'Success' and 'Failure' of OSD.

It is configured as a package and must include the scipt itself and the PSMicrosoftTeams module in a subfolder.

The basic operation is:

* Create an SCCM package and distribute content
* Create several 'Run Powershell Script' steps and various points in the OSD
* Run a test OSD

## Install

### Requirements

* Access to SCCM packages and TS
* By default the script requires the local disk have a partition, if you have it at a stage where the disk is blank, make sure you adjust your SCCM settings to reflect this

## Configuration

1. Create a standard SCCM package with the script in the root folder and the module in a subfolder

2. Distribute the package content

3. Edit your task sequence and add the step 'Run PowerShell Script' to the beginning of your TS and select your script package. Enter the details as follows:

**Script Name**

```
Send-BuildNotification.ps1
```

**Parameters**

```
-message Started
```

**NOTE:** Replace 'started' with 'Success' or 'Failed' depending on where you are notifying

### Example:

![Example-SCCMOSD](/Examples/SCCM%20OSD/Images/Example-TaskSequence.png)


4. Create two more steps, one at the very end, replace -message with 'Success' and one in your failure section, replacing -message with 'Failed'

5. Run a test OSD

## Example

![Example-SCCMOSD](/Examples/SCCM%20OSD/Images/Example-SCCMOSD.jpg)