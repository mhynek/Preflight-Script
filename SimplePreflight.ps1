
$csv = import-csv '.\emailaddresslist.csv'
$outputfile = '.\preflight-output-1.csv'
$credential= Get-Credential -username 'domain\username' -message "Enter password"

Write-host $csv.count

ForEach ($entry in $csv) {
Write-host "----------------------------"
$email = $entry.EmailAddress
Write-Host $email -foreground red
$obj = New-Object PSObject
$error.clear()
$Message = $null
New-MoveRequest -Remote -RemoteHostName mail.contoso.com -RemoteCredential $credential -Identity $email -TargetDeliveryDomain contoso.mail.onmicrosoft.com -BatchName "PreFlight" -WhatIf
$Message= $Error[0].Exception.Message

$obj | Add-Member NoteProperty 'EmailAddress' ($email)

If ($Message -ne $Null) { 
Write-host "Fail"
$obj | Add-Member NoteProperty 'PassFail' "Fail"
} 
Else 
{
Write-host "Pass"   
$obj | Add-Member NoteProperty 'PassFail' "Pass"
}

$obj | Add-Member NoteProperty 'Message' ($Message)

Write-host "----------------------------"


$Results += @($obj)

}

$Results | Export-CSV $outputfile -notype



             
