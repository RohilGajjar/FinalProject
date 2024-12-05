Clear-Host
$benchmark = @()
$Current = @()
$cv = @()
$err = @()
Write-Host "2.2 User rights assignment "
Write-Host "2.2.1 Access Credential Manager  "
$privileges = Get-Privilege
$specificPrivilege = "SeTrustedCredManAccessPrivilege"
$acmPrivilege = $privileges | Where-Object {$_.Privilege -eq $specificPrivilege}
if($acmPrivilege){
    $assigned = $acmPrivilege.Accounts
    $cv += "$assigned"
   
if($assigned.Count -eq 0){
    Write-Host "Access Credential Manager as a trusted caller is set to No One "
    $cv += "Access Credential Manager as a trusted caller is set to No One "
    }
else{
    Write-Warning "Access Credential Manager as a trusted caller is set to $acmPrivilege.Accounts  "
    $cv += "Access Credential Manager as a trusted caller is set to $acmPrivilege.Accounts  "
    $err += "Access Credential Manager as a trusted caller is set to $acmPrivilege.Accounts  "
    }
}

else { 
    $cv += "Not able to retrieve this benchmark"
    $err += "Not able to retrieve 2.2.1 Access Credential Manager benchmark"
}
$benchmark += "Access Credential Manager as a trusted caller"
#access this computer from network privilege
$acn = $privileges | Where-Object {$_.Privilege -eq "SeNetworkLogonRight"}
if($acn -ne $null){
    $assigned = $acn.Accounts
    if($assigned -contains "BUILTIN\Users" -and $assigned -contains  "BUILTIN\Administrators" -and $assigned.Count -eq 2){
        Write-Host "Access this computer from the network is set to Administrators, Remote Desktop Users "
        $cv += "Access this computer from the network is set to Administrators, Remote Desktop Users"
    }
else{
    $cv += "Access this computer from the network is set to Administrators, Remote Desktop Users. "
    $err += "2.2.2 Access this computer from the network is set to Administrators, Remote Desktop Users. "
}
}
else{
    $cv += "Error reading or retrieving this benchmark"
    $err += "2.2.2 Error reading or retrieving this benchmark"
   
}
$benchmark += "Acces this computer from the network"
#will be retrieved from Enterprise OS
$actAsOS = $privileges | Where-Object {$_.Privilege -eq "SeTcbPrivilege"}
if($actAsOS){
    $assigned = $actAsOS.Accounts
    if($assigned.Count -eq 0){
        $cv += "Act as part of the operating system is set to No One"
    }
    else{
        $cv += "Act as part of the operating system is not set to No One"
        $err += "2.2.3 Act as part of the operating system is not set to No One"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.3 Error reading or retrieving!!"
}

$benchmark += "Act as part of Operating system"

Write-Host "2.2.4 Adjust Memory quotas for process"
$memQuota = $privileges | Where-Object {$_.Privilege -eq "SeIncreaseQuotaPrivilege"}
if($memQuota){
    $assigned = $memQuota.Accounts
   if($memQuota){
        if($assigned -contains "BUILTIN\Administrators" -and $assigned -contains "NT AUTHORITY\LOCAL SERVICE" -and $assigned -contains "NT AUTHORITY\NETWORK SERVICE" -and $assigned -eq 3){
            $cv += "Adjust memory quotas for a process is set to Administrators, LOCAL SERVICE, NETWORK SERVICE"
        }
    else{
        $cv += "Adjust memory quotas for a process is not set to Administrators, LOCAL SERVICE, NETWORK SERVICE"
        $err += "2.2.4 Adjust memory quotas for a process is not set to Administrators, LOCAL SERVICE, NETWORK SERVICE"
    }
   }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.4 Error reading or retrieving!!"
}  

$benchmark += "Adjust Memory quota for process"

Write-Host "2.2.5 Allow log on locally "
$allowLog = $privileges | Where-Object {$_.Privilege -eq "SeInteractiveLogOnRight"}
if($allowLog){
    $assigned = $allowLog.Accounts
    if($assigned -contains "BUILTIN\Administrators"-and $assigned -contains "BUILTIN\Users" -and $assigned.Count -eq 2){
        $cv += "Allow log on locally is set to Administrators,Users"
    }
else{
    $cv += "Allow log on locally is not set to Administrators,Users"
    $err += "2.2.5 Allow log on locally is not set to Administrators,Users"
}
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.5 Error reading or retrieving!!"
}
$benchmark += "Allow log on locally"
#13
Write-Host "Optimal value is Administrator, Users" -ForegroundColor Green
Write-Host "Default value is Administrator, Backup operators, Guests and Users " -ForegroundColor Yellow


Write-Host "2.2.6 Allow log on through Remote Desktop Services"
$remoteLogon = $privileges | Where-Object {$_.Privilege -eq "SeRemoteInteractiveLogonRight"}
if($remoteLogon){
    $assigned = $remoteLogon.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned -contains "BUILTIN\Remote Desktop Users" -and $assigned.Count -eq 2){
        $cv += "Allow log on through Remote Desktop Services is set to Administrators, Remote Desktop Users"
    }
    else{
        $cv += "Allow log on through Remote Desktop Services is not set to Administrators, Remote Desktop Users"
        $err += "2.2.6 Allow log on through Remote Desktop Services is not set to Administrators, Remote Desktop Users"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.6 Error reading or retrieving!!"

}
$benchmark += "Allow log on through Remote Desktop Services"


Write-Host "2.2.7 Backup Files and Directories  "
$backupPrivilege = $privileges | Where-Object {$_.Privilege -eq "SeBackupPrivilege"}
if($backupPrivilege){
    $assigned = $backupPrivilege.Accounts
    if($assigned  -contains "BUILTIN\Administrators" -and $assigned.Count -eq 2){
        $cv += "Back up files and directories is set to Administrators"
    }
    else{
        $cv += "Back up files and directories is not set to Administrators"
        $cv += "2.2.7 Back up files and directories is not set to Administrators"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.7 Error reading or retrieving!!"
}

$index += "2.2.7"
$benchmark += "Backup files and directories"
Write-Host "2.2.8 Change the system time  "
$changeSystemTime = $privileges | Where-Object {$_.Privilege -eq "SeSystemtimePrivilege"}
if($changeSystemTime){
    $assigned = $changeSystemTime.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned -contains "NT AUTHORITY\LOCAL SERVICE" -and $assigned.Count -eq 2){
    $cv += "Change the system time is set to Administrators, LOCAL SERVICE"
}
else{
    $cv += "Change the system time is not set to Administrators, LOCAL SERVICE"
    $err += "2.2.8 Change the system time is not set to Administrators, LOCAL SERVICE"
}
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.8 Error reading or retrieving!!"

}
$benchmark += "Change the system time"
Write-Host "2.2.9 Change the time zone  "
$timeZone = $privileges | Where-Object {$_.Privilege -eq "SeTimeZonePrivilege"}
if($timeZone){
    $assigned = $timeZone.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned -contains "NT AUTHORITY\LOCAL SERVICE" -and $assigned -contains "BUILTIN\Users" -and  $assigned.Count -eq 3){
        $cv += "Change the time zone is set to Administrators, LOCAL SERVICE, Users"
    }
    else{
        $cv += "Change the time zone is not set to Administrators, LOCAL SERVICE, Users"
        $err += "2.2.9 Change the time zone is not set to Administrators, LOCAL SERVICE, Users"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.9 Error reading or retrieving!!"
}
$benchmark += "Change the system time"
Write-Host "2.2.10 Create a pagefile  "
$pageFile = $privileges | Where-Object {$_.Privilege -eq "SeCreatePagefilePrivilege"}
if($pageFile){
    $assigned = $pageFile.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned.Count -eq 1){
        $cv += "Create a pagefile is set to Administrator"
    }
    else{
        $cv += "Create a pagefile is not set to Administrator"
        $err += "2.2.10 Create a pagefile is not set to Administrator"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.10 Error reading or retrieving!!"
}
$benchmark += "Create a pagefile"

Write-Host "2.2.11 Create a token object "
$createToken = $privileges | Where-Object {$_.Privilege -eq "SeCreateTokenPrivilege"}
if($createToken){
    $assigned = $createToken.Accounts
    if($assigned.Count -eq 0){
        $cv += "Create a token object is set to No One"
    }
    else{
        $cv += "Create a token object is not set to No One"
        $err += "2.2.11 Create a token object is not set to No One"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.11 Error reading or retrieving!!"
}
$benchmark += "Create a token object"
Write-Host "2.2.12 Create global objects"
$globalPrivilege = $privileges | Where-Object{$_.Privilege -eq "SeCreateGlobalPrivilege"}
if($globalPrivilege){
    $assigned = $globalPrivilege.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned -contains "NT AUTHORITY\NETWORK SERVICE" -and $assigned -contains "NT AUTHORITY\LOCAL SERVICE" -and $assigned -contains "NT AUTHORITY\SERVICE" -and  $assigned.Count -eq 4){
        $cv += "Create global objects is set to Administrators,LOCAL SERVICE, NETWORK SERVICE, SERVICE"
    }
    else{
        $cv += "Create global objects is not set to Administrators,LOCAL SERVICE, NETWORK SERVICE, SERVICE"
        $err += "Create global objects is not set to Administrators,LOCAL SERVICE, NETWORK SERVICE, SERVICE"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.12 Error reading or retrieving!!"
}
$benchmark += "Create global objects"
Write-Host "2.2.13 Create permanent shared objects  "
$permanentObj = $privileges | Where-Object {$_.Privilege -eq "SeCreatePermanentPrivilege"}
if($permanentObj){
    $assigned = $permanentObj.Accounts
    if($assigned.Count -eq 0){
        $cv += "Create permanent shared objects is set to No One"
    }
    else{
        $cv += "Create permanent shared objects is not set to No One"
        $err += "2.2.13 Create permanent shared objects is not set to No One"
    }
}
else {
    $cv += "Error reading or retrieving!!"
    $err += "2.2.12 Error reading or retrieving!!"
}
$benchmark += "Create permanent shared objects"
Write-Host "2.2.14 Create symbolic links"
$symbolic = $privileges | Where-Object {$_.privilege -eq "SeCreateSymbolicLinkPrivilege"}
if($symbolic){
    $assigned = $symbolic.Accounts
    if($assigned -contains"BUILTIN\Administrators" -and $assigned -contains "NT VIRTUAL MACHINE\Virtual Machines"){
        $cv += "Create Symbolic links benchmarks is in its recommended state"
    }
    else{
        $cv += "Create Symbolic links benchmarks is not in its recommended state"
        $err += "Create Symbolic links benchmarks is not in its recommended state"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.13 Error reading or retrieving!!"
}
$index += "2.2.14"
$benchmark += "Create symbolic links"
Write-Host "2.2.15 Debug Programs"
$debugPrivilege = $privileges | Where-Object {$_.Privilege -eq "SeDebugPrivilege"}
if($debugPrivilege){
    $assigned = $debugPrivilege.Accounts
    if($assigned -contains "BUILTIN\Administrators" -and $assigned.Count -eq 1){
        $cv += "Debug programs is set to Administrators"
    }
    else{
        $cv += "Debug programs is not set to Administrators"
        $err += "2.2.15 Debug programs is not set to Administrators"
    }
}
else{
    $cv += "Error reading or retrieving!!"
    $err += "2.2.15 Error reading or retrieving!!"
}
$benchmark += "Debug Programs"
Write-Host $cv.Count
Write-Host $err.Count

$jsonCurrentValue = $cv | ConvertTo-Json
$jsonCurrentValue | Out-File "project\JSON\rights\rights_CurrentValue.json" -Encoding utf8
$jsonError = $err | ConvertTo-Json
$jsonError | Out-File "project\JSON\rights\rights_error.json" -Encoding utf8


