# PSMicrosoftTeams

Powershell module for sending rich messages to Microsoft Teams through channel webhooks

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

This module has a required parameter for the URI which is created when adding a webhook to a Microsoft Teams channel.

To enable a webhook on a channel:

1. Open Microsoft Teams
2. Create a new channel or select and existing
3. Press the three dots '...' to open the settings
4. Select 'Connectors'
5. Once the screen loads, select 'Incoming Webhook' by pressing 'Configure'
6. Enter a name and upload and image (if required)

When you select 'Create' the next screen will show a 'URI', make sure you save this somewhere for later use in your script

### Installing

Add the module files to you module path and use:

```
Import-Module PSMicrosoftTeams
```
NOTE:

This script by default uses publicly accessible icons for the messages, it is recommended that you host your own icons

## Contributing

https://github.com/mhouston100/PSMicrosoftTeams


## Authors

* **Matthew Houston** - *Initial work* -

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.


