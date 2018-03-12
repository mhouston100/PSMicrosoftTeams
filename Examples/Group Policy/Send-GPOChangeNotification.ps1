Import-Module "#<Insert module folder here>\PSMicrosoftTeams"

$URI= #<insert URI HERE>

$allGPO = get-controlledGPO

foreach($gpo in $allGPO){

    $submitDate = [DateTime]::parseexact($gpo.Deployed, 'd/M/yyyy h:mm:ss tt', $null)
    $requestAge = (get-date)-$submitDate

	if ($gpo.State -eq "CHECKED_IN"){
	    Switch ($requestAge.TotalMinutes ){
	        {$_ -lt 5} {$notify=$true;$messageType = "Success"}
	        {$_ -gt 5}{$notify=$false;$messageType = "Information"}
	    }             
	}
	else {
	    $notify = $false
		}
	
$messageTitle = "A change has occured to policy $($gpo.Name)"
$messageBody = " "
$activityTitle = "$($gpo.Name) - $($gpo.ChangedBy)"
$details = @(
	@{
		name  = 'GPO Name'
		value = $gpo.Name
	},
	@{
		name  = 'User'
		value = $gpo.ChangedBy
	},
	@{
		name  = 'Modified Time'
		value = $gpo.Deployed
	}
)
	
   If ($notify){
		Send-TeamChannelMessage -messageType $messageType -messageTitle $messageTitle -messageBody $messageBody -activityTitle $activityTitle -details $details -URI $URI
    }
}