Clear-Host
$pcName = $env:COMPUTERNAME
$mac = (Get-NetAdapter -Name Ethernet).MacAddress
$timeStamp = Get-Date
$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress
Import-Module -Name ImportExcel
$outputFile = "$env:USERPROFILE\DESKTOP\secedit_output.txt"
# Export the current security policy settings to a file
secedit /export /cfg $outputFile
$seceditContent = Get-Content $outputFile
#Arrays for input feed

$index = @()
$benchmark = @()
$OptimalValue = @()
$DefaultValue = @()
$cv = @()
$err = @()



Write-Host "`n"
Write-Host "2.3 Security Options`n"
Write-Host "2.3.1 Accounts`n"
Write-Host "`n"


Write-Host "2.3.1.1 Block Microsoft Accounts"
# Read the value of NoConnectedUser
try {
    $noConnectedUserValue = (Get-Content $outputFile | Select-String 'NoConnectedUser' | Select-Object -ExpandProperty Line).Split(',')[1]
    if($noConnectedUserValue -ne $null){
        if ($noConnectedUserValue -eq "1") {
            # NoConnectedUser is enabled
            $cv += "Accounts: Block Microsoft accounts is set to Users cant add or log on with Microsoft accounts"
        } else {
            # NoConnectedUser is disabled
            $cv += "Accounts: Block Microsoft accounts is not set to Users cant add or log on with Microsoft accounts"
            $err += "Accounts: Block Microsoft accounts is not set to Users cant add or log on with Microsoft accounts"
        }
    }
    else {
        $cv += "Block Microsoft Accounts Value was not recognized or not configured"    
        $err += "2.3.1.1 Block Microsoft Accounts Value was not recognized or not configured"    
    }
}
catch {
    <#Do this if a terminating exception happens#>
    $cv += = "Value was not found"
    $err += "2.3.1.1 Value was not found"
}
$index += "2.3.1.1"
$benchmark += "Block Microsoft Accounts"
$OptimalValue += "Users cant add or log on with Microsoft accounts"
$DefaultValue += "Users are able to use Microsoft accounts with Windows"
Write-Host "Default Value is: Users are able to use Microsoft accounts with Windows`n" -ForegroundColor Yellow




Write-Host "2.3.1.2 Guest account status"
try {
    $guestAccountValue = $adminLockout -replace "EnableGuestAccount\s*=\s*", ""
    # Convert the value to an integer
    $EnableGuestAccount = [int]$EnableGuestAccount
    if($EnableGuestAccount -ne $null){
        if($EnableGuestAccount -eq 1){
            $cv += "Accounts: Guest account status is set to Enabled "
            $err += "2.3.1.2 Accounts: Guest account status is set to Enabled "
        }
        else{
            $cv += "Accounts: Guest account status is set to Disabled "
        }
    }
    else {
        $cv += "Value was not recognized or not configured"    
        $err += "2.3.1.2 Value was not recognized or not configured"    
    }
}
catch {
    $cv += "Value was not found"
    $err += "2.3.1.2 Value was not found"
}
$index += "2.3.1.2"
$benchmark += "Guest account status"
$OptimalValue += "Disabled"
$DefaultValue += "Disabled"
Write-Host "Default Value is Disabled`n" -ForegroundColor Yellow


Write-Host "2.3.1.3 Local Account use of Blank Passwords"
try {
    $blankPasswordValue = (Get-Content $outputFile | Select-String 'LimitBlankPasswordUse' | Select-Object -ExpandProperty Line).Split(',')[1]
    if($blankPasswordValue -ne $null){
    if($blankPasswordValue -eq 1){
        $cv += "Accounts: Limit local account use of blank passwords to console logon only is set to Enabled"
    }
    else{
        $cv += "Accounts: Limit local account use of blank passwords to console logon only is set to Disabled"
        $err += "2.3.1.3 Accounts: Limit local account use of blank passwords to console logon only is set to Disabled"
    }
    }
    else {
        $cv += "Value was not recognized or not configured"    
        $err += "2.3.1.3 Value was not recognized or not configured"    
    }
}
catch {
    <#Do this if a terminating exception happens#>
    $cv += "Value was not found"   
    $err += "2.3.1.3 Value was not found"   
}
$index += "2.3.1.3"
$benchmark += "Limit Local Account use of Blank Password to console logon" 
$OptimalValue += "Enabled"
$DefaultValue += "Disabled"
Write-Host "Default value is Enabled`n" -ForegroundColor Yellow



Write-Host "2.3.1.4 Rename Administrator Account`n"
Write-Host "Test this benchmark exhaustively" -ForegroundColor Green
try {
    $adminName = $seceditContent | Select-String -Pattern "NewAdministratorName"
    $adminNameValue = $adminName -replace "NewAdministratorName\s*=\s*", ""
    if($adminNameValue -ne $null){
        $cv += "$adminNameValue"
    }   
    else {
        $cv += "Value was not recognized or not configured"
        $err += "2.3.1.4 Value was not recognized or not configured"            
    }
}
catch {
    <#Do this if a terminating exception happens#>
    $cv += "Value was not found"
    $err += "2.3.1.4 Value was not found"
}
Write-Host "Current Administrator account name is $adminNameValue.`n" 
Write-Host "Recommended optimal value is to rename the account to something that does not indicate 
its purpose. Even if you disable this account, which is recommended, ensure that you rename 
it for added security.`n"

$index += "2.3.1.4"
$benchmark += "Rename Administrator Account"
$OptimalValue += "avoid names that denote administrative or elevated access accounts. Be sure to also change the 
default description for the local administrator (through the Computer Management console)"
$DefaultValue += "Administrator"

Write-Host "Default value is Administrator `n" -ForegroundColor Yellow

Write-Host "2.3.1.5 Rename guest account`n"
Write-Host "Test this benchmark exhaustively" -ForegroundColor Yellow
try {
    $guestAccountName = $seceditContent | Select-String -Pattern "NewGuestName"
    $guestAccountValue = $guestAccountName -replace "NewGuestName\s*=\s*", ""
    Write-Host "Current Guest account name is $guestAccountValue.`n"
    Write-Host "Recommended optimal value is to rename the account to something that does not indicate 
    its purpose. Even if you  disable this account, which is recommended, ensure that you 
    rename it for added security.`n"
    if($guestAccountValue -ne $null){
        $cv += "$guestAccountValue"
    }
    else {
        $cv += "Value was not recognized or not configured"
        $err += "2.3.1.5 Value was not recognized or not configured"        
    }
}
catch {
    <#Do this if a terminating exception happens#>
    $cv += "Value was not found"
    $err += "2.3.1.5 Value was not found"
    
}
$guestAccountName = $seceditContent | Select-String -Pattern "NewGuestName"
$guestAccountValue = $guestAccountName -replace "NewGuestName\s*=\s*", ""
Write-Host "Current Guest account name is $guestAccountValue.`n"
    Write-Host "Recommended optimal value is to rename the account to something that does not indicate 
its purpose. Even if you  disable this account, which is recommended, ensure that you 
rename it for added security.`n"
$index += "2.3.1.5"
$benchmark += "Rename Guest Account"
$CurrentValue += $guestAccountValue
$OptimalValue += "rename this account to something that does not indicate its purpose. 
Even if you disable this account, which is recommended, ensure that you rename it for 
added security."
$DefaultValue += "Guest"


Write-Host "Default value is Guest`n" -ForegroundColor Yellow

Write-Host "2.3.2 Audit Controls `n"
Write-Host "2.3.2.1 Force audit policy subcategory setting`n"

Write-Host "2.3.2.2 Audit System Shutdown`n"
try {
    $auditSD = (Get-Content $outputFile | Select-String 'CrashOnAuditFail' | Select-Object -ExpandProperty Line).Split(',')[1]
    if($auditSD -ne $null){
        if($auditSD -eq 1){
            $cv += "Audit: Shut down system immediately if unable to log security audits is Enabled `n"
            $err += "2.3.2.2 Audit: Shut down system immediately if unable to log security audits is Enabled `n"
        }
        else{
            $cv += "Audit: Shut down system immediately if unable to log security audits is set to Disabled `n"
        }
    }
    else{
        $cv += "Value was not recognized or not configured"
        $err += "2.3.2.2 Value was not recognized or not configured"
    }
}
catch{
    $cv += "Value was not found"  
    $err += "2.3.2.2Value was not found"  
}

# Continue adding checks for other configurations here
<#$jsonCurrentValue = $cv | ConvertTo-Json
$jsonCurrentValue | Out-File "project\JSON\accounts\accounts_CurrentValue.json" -Encoding utf8
$jsonError = $err | ConvertTo-Json
$jsonError | Out-File "project\JSON\accounts\accounts_error.json" -Encoding utf8
Write-Output "Script Completed"
#>