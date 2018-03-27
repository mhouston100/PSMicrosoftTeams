# PSMicrosoftTeams - SCCM Applicaiton Request Example

# Description

This example script is run on the SCCM site server on a schedule to notify admins of new software install requests made by users.

It is configured as a scheduled task on the site server and queries the SCCM database via WMI.

The basic operation is:

* Create a scheduled task to run the script every hour (can be modified)
* Test by requesting an application from the SCCM Software Centre on a client PC.

## Install

### Requirements

* The script must be run on the Site server as that is the only machine with the requried WMI endpoints.
* CIM Cmdlets

## Configuration

1. Create a scheduled task that executes the powershell script.

**Script Name**

```
SCCM-Check-Software-Requests.ps1
```

**Parameters**

```
None
```

### Example:

![Example-SCCMAPPREQ](/Examples/SCCM%20Application%20Request/Images/SCCM-Check-Software-Requests-Example.png)

