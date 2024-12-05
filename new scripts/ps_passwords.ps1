Clear-Host
# Export the current security policy settings to a file
#secedit /export /cfg $outputFile
secedit /export /cfg $outputFile

# Read the content of the exported file
#$outputFile = "$env:USERPROFILE\DESKTOP\secedit_output.txt"
$outputFile = "$env:temp\secedit_output.txt"
$seceditContent = Get-Content $outputFile
Clear-Host
$index = @("1.1.1","1.1.2","1.1.3","1.1.4","1.1.5","1.1.6","1.2.1","1.2.2","1.2.3","1.2.4")
$benchmark = @()
$cv = @() #holds only the current value
$err = @() #logs the error

#1.1.1 enforce password history
$passwordHistoryLine = $seceditContent | Select-String -Pattern "PasswordHistorySize"
$passwordHistoryValue = $passwordHistoryLine -replace "PasswordHistorySize\s*=\s*", ""
if($passwordHistoryValue -ne $null){
    if ($passwordHistoryValue -ge 24) {
        $benchmark += "Enforce password history is correctly set to 24 or more passwords"
    } else {
        $err += "1.1.1 Enforce password history is NOT set to 24 or more."
        $benchmark += "Enforce password history is NOT set to 24 or more."
    }
    $cv += "$passwordHistoryValue"
}
else{
    $benchmark += "Enforce password history value not found in security policy"
    $cv += "Enforce password history value not found in security policy"
    $err += "1.1.1 Enforce password history value not found in security policy"
}
#1.1.2 maximum password age
try {
    $passwordPolicy = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' -Name 'MaximumPasswordAge'
    # Check if the 'Enforce password history' is set to '24 or more passwords'
    if ($passwordPolicy.MaximumPasswordAge -le 365 -and $passwordPolicy.MaximumPasswordAge -ne 0 ) {
        $benchmark += "Maximum password age is set to 365 or fewer days, but not 0"
    } else {
        $benchmark += "'Maximum password age is not set to 365 or fewer days"
        $err += "'1.1.2 Maximum password age is not set to 365 or fewer days"
    }
    $cv += "$($passwordPolicy.MaximumPasswordAge)"
}
catch {
    $benchmark += "Maximum password age value was not found in security policy"
    $cv += "Maximum password age value was not found in security policy"
    $err += "1.1.2 Maximum password age value was not found in security policy"
}

#1.1.3 minimum password age
$minPasswordAgeLine = $seceditContent | Select-String -Pattern "MinimumPasswordAge"

# Extract the value of the MinimumPasswordAge setting
$minPasswordAgeValue = $minPasswordAgeLine -replace "MinimumPasswordAge\s*=\s*", ""
if($minPasswordAgeValue -ne $null){
    if ($minPasswordAgeValue -ge 1){
        $benchmark += "Minimum password age is set to 1 or more day(s)"
        }
    else{
        $benchmark += "Minimum Password age is not set to 1 or more day(s)"
        $err += "1.1.3 Minimum Password age is not set to 1 or more day(s)"
    } 
    $cv += $minPasswordAgeValue
}
else{
    $err += "1.1.3 Minimum Password age value setting was not found in the security policy"
    $benchmark += "Minimum Password age value setting was not found in the security policy"
    $cv += "Minimum Password age value setting was not found in the security policy"
}
#1.1.4 Minimum password length
$minPassword = $seceditContent | Select-String -Pattern "MinimumPasswordLength ="
$minPasswordValue = $minPassword -replace "MinimumPasswordLength\s*=\s*", ""
if($minPasswordValue -ne $null){
    if($minPasswordValue -ge 14){
        $benchmark += "Minimum password length is set to 14 or more character(s)"
    }
    else{
        $benchmark += "Minimum password length is not set to 14 or more character(s)"
        $err += "1.1.4 Minimum password length is not set to 14 or more character(s)"
    }
    $cv += "$minPasswordValue"
}
else {
    $benchmark += "Value was not found in security policy"
    $cv += "Value was not found in security policy"
    $err += "1.1.4 Minimum Password length value was not found in security policy"
}

#1.1.5 Password complexity
$passwordComplexityLine = $seceditContent | Select-String -Pattern "PasswordComplexity"
$passwordComplexityValue = $passwordComplexityLine -replace "PasswordComplexity\s*=\s*", ""
if($passwordComplexityValue -ne $null){
    if($passwordComplexityValue -eq 1){
        $benchmark += "Password complexity is enabled"
    }
    else{
        $benchmark += "Password complexity is disabled"
        $err += "Password complexity is disabled"
    }
    $cv += $passwordComplexityValue
}
else{
    $benchmark += "Value was not found in security policy"
    $cv += "Value was not found in security policy"
    $err += "1.1.5 Password Complexity Value was not found in security policy"
}
# 1.1.6 Store passwords using reversible encryption
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "StoreClearTextPasswords"
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName 
    if ($regValue -ne $null) {
        if ($regValue.$regName -eq 0) {
            $benchmark += "Store passwords using reversible encryption is Disabled."
        } else {
            $benchmark += "Store passwords using reversible encryption is Enabled."
            $err += "1.1.6 Store passwords using reversible encryption is Enabled."
        }
        $cv +=  $regValue.$regName.ToString() + " (0: False and 1: True)"
    } else {
        $benchmark += "The setting 'Store passwords using reversible encryption' is not configured."
        $cv += "The setting 'Store passwords using reversible encryption' is not configured."
        $err += "1.1.6 The setting 'Store passwords using reversible encryption' is not configured."
    }
}
catch {
    $cv += "StoreClearTextPasswords registry not found or not accessible"
    $err += "1.1.6 StoreClearTextPasswords registry not found or not accessible"
} 
#1.2 Account lockout policy
#1.2.1 Account lockout duration

try {
    $accountLockout = $seceditContent | Select-String -Pattern "LockoutDuration"
    # Extract the value of the PasswordHistorySize setting
    $accountLockoutValue = $accountLockout -replace "LockoutDuration\s*=\s*", ""
    if($accountLockoutValue -ne $null){
        if($accountLockoutValue -ge 15){
            $benchmark += "Account Lockout Duration is set to 15 or more."
        }
        else{
            $benchmark += "Account Lockout Duration is not set to 15 or more."
            $err += "1.2.1 Account Lockout Duration is not set to 15 or more."
        }
        $cv += $accountLockoutValue
    }
    else{
        $benchmark += "Value was not found in security policy"
        $cv += "Value was not found in security policy"
        $err += "1.2.1 Account Lockout Duration Value was not found in security policy"
    }
}
catch {
    $benchmark += "Error retrieving or not configured"
    $cv += "Error retrieving or not configured"
    $err += "1.2.1 Error retrieving Account Lockout Duration value or not configured"
}
#1.2.2 Account lockout threshold

try {
    $accountLockoutBad = $seceditContent | Select-String -Pattern "LockoutBadCount"
    $accountLockoutBadValue = $accountLockoutBad -replace "LockoutBadCount\s*=\s*", ""
    if($accountLockoutBadValue -ne $null){
        if($accountLockoutBadValue -le 5 -and $accountLockout -ne 0 ){
            $benchmark += "Account lockout threshold is set to 5 or fewer invalid logon attempt(s), but not 0"
        }
        else{
            $benchmark += "Account lockout threshold is not set to 5 or fewer invalid logon attempt(s)."
            $err += "1.2.2 Account lockout threshold is not set to 5 or fewer invalid logon attempt(s)."
        }
        $cv += "$accountLockoutBadValue"
    }
    else{
        $benchmark += "Value was not found in security policy"
        $cv += "1.2.2 Value was not found in security policy"
        $err += "1.2.2 Value was not found in security policy"
    }
    
}
catch {
    $cv += "Error retrieving or not configured"
    $benchmark += "Error retrieving or not configured"
    $err += "1.2.2 Error retrieving Account Lockout Threshold value or not configured"
}

#1.2.3 Allow admin Account lockout 
try {
    $adminLockout = $seceditContent | Select-String -Pattern "AllowAdministratorLockout"
    $adminLockoutValue = $adminLockout -replace "AllowAdministratorLockout\s*=\s*", ""
    if($adminLockoutValue -ne $null){
        if ($accountLockoutBadValue -eq 1){
            benchmark += "Allow Administrator account lockout is set to Enabled"
        }
        else{
            $benchmark += "Allow Administrator account lockout is set to Disabled"
            $err += "1.2.3 Allow Administrator account lockout is set to Disabled"
        }   
        $cv += "$adminLockoutValue" + " (0:False and 1:True)"
    }
    else{
        $benchmark += "Value was not found in Security policy"
        $cv += "Value was not found in Security policy"
        $err += "1.2.3 Admin Account Lockout Status was not found in Security policy"
    }
}
catch {
    $benchmark += "Error retrieving or not configured"
    $cv += "Error retrieving or not configured"
    $err += "1.2.3 Error retrieving Admin Account Lockout Status or not configured"
}
#1.2.4 Reset account lockout counter
try {
    $resetLockout = $seceditContent | Select-String -Pattern "ResetLockoutCount"
    $resetLockoutValue = $resetLockout -replace "ResetLockoutCount\s*=\s*", ""
    if($resetLockoutValue -ne $null){
        if($resetLockoutValue -ge 15){
            $benchmark += "Reset account lockout counter after' is set to 15 or more minute."
        }
        else{
            $benchmark += "Reset account lockout counter after is not set to 15 or more minute."
            $err += "1.2.4 Reset account lockout counter after is not set to 15 or more minute."
        }
        $cv += "$resetLockoutValue"
    }
    else{
        $cv += "Value was not found in security policy"
        $benchmark += "Value was not found in security policy"
        $err += "1.2.4 Reset Account Lockout Counter Value was not found in security policy"
    }
}
catch {
    $cv += "Error retrieving or not configured"
    $benchmark += "Error retrieving or not configured"
    $err += "1.2.4 Error retrieving Reset Account Lockout Counter Value or it was not configured"
}
$jsonCurrentValue = $cv | ConvertTo-Json
$jsonCurrentValue | Out-File "project\JSON\pw_CurrentValue.json" -Encoding utf8
$jsonPasswordError = $err | ConvertTo-Json
$jsonPasswordError | Out-File "project\JSON\pw_Error.json" -Encoding utf8











