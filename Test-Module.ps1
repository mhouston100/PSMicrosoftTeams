<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	22/11/2017 12:36 PM
	 Created by:   	adminMHouston
	 Organization: 	
	 Filename:     	Test-Module.ps1
	===========================================================================
	.DESCRIPTION
	The Test-Module.ps1 script lets you test the functions and other features of
	your module in your PowerShell Studio module project. It's part of your project,
	but it is not included in your module.

	In this test script, import the module (be careful to import the correct version)
	and write commands that test the module features. You can include Pester
	tests, too.

	To run the script, click Run or Run in Console. Or, when working on any file
	in the project, click Home\Run or Home\Run in Console, or in the Project pane, 
	right-click the project name, and then click Run Project.
#>


#Explicitly import the module for testing
Import-Module '\\fs-qnap-p01.thehouston.com.au\Media\UserData\RedirectedFolders\matthewh\Documents\GitHub\PSMicrosoftTeams\PSMicrosoftTeams\PSMicrosoftTeams' -force

Send-TeamChannelMessage -messageType Information -messageTitle "Test Title" -messageBody "Test body" -activityTitle "test Activity" -URI "https://outlook.office.com/webhook/6baddf78-41a3-4ba0-b479-fb357dd47057@d1e33136-aca7-471f-8644-90aaf576707e/IncomingWebhook/e6ca0efd46134724924679802f61be65/9e950bad-60eb-4262-929a-be438d0cf6c3" -details @(@{ name = 'name1'; value = 'value1' }, @{ name = 'name2'; value = 'value2' }, @{ name = 'name3'; value = 'value3' }) -buttons @(@{ name = 'Google'; value = 'https://www.google.com' }, @{ name = 'IT Support Desk'; value = 'https://itsupportdesk.camden.nsw.gov.au' }, @{ name = 'PRTG'; value = 'https://prtg.camden.nsw.gov.au' })
	
Remove-Module 'PSMicrosoftTeams'