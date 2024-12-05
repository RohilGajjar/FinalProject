Clear-Host
$benchmark = @() #benchmark status
$cv = @() #Current Values
$err = @()

#Firewall status for the Public profile
if((Get-NetFirewallProfile -Name Public).Enabled)
    {
         $cv += "Public: Firewall state is set to On"
    }
else{ 
    $cv +=  "1) Windows Firewall: Public: Firewall state' is set to Off"
    $err +=  "1) Windows Firewall: Public: Firewall state' is set to Off"
}

#Firewall status for the inbound connections
if((Get-NetFirewallProfile -Name Public).DefaultInboundAction -eq "Block"){
    $cv += "Inbound connections to Public profile are set to 'Block'"
}
else {
    $fire = (Get-NetFirewallProfile -Name Public).DefaultInboundAction
    $cv += "Inbound connections to Public profile are $fire "
    $err += "Inbound connections to Public profile are $fire "
}

#Firewall status for the outbound connections
if((Get-NetFirewallProfile -Name Public).DefaultOutboundAction -eq "Allow"){
    $cv += "Outbound connections are set to 'Allow'"
}
else{
    $fire = ((Get-NetFirewallProfile -Name Public).DefaultOutboundAction)
    $cv += "Outbound connections are $fire"
}

#Notify on listen
if((Get-NetFirewallProfile -Name Public).NotifyOnListen -eq "False"){
    $cv += "Display a notification is set to No"
}
else{
    $fire = (Get-NetFirewallProfile -Name Public).NotifyOnListen
    $err += "Display a notification is not set to No"
    $cv += "Display a notification is not set to $fire"
}
if((Get-NetFirewallProfile -Name Public).AllowLocalFirewallRules -eq "False"){
    $cv += "Apply local firewall rules is set to 'No' "
}
else{
    $fire = (Get-NetFirewallProfile -Name Public).AllowLocalFirewallRules
    $cv += "Apply local firewall rules is set to $fire"
    $err += "Apply local firewall rules is set to $fire"
}

#log file name
if((Get-NetFirewallProfile -Name Public).LogFileName -eq "%systemroot%\system32\LogFiles\Firewall\pfirewall.log"){
    $cv += "Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\Publicfw.log'"
    }
else{
    $cv += "Warning! Log file name is $(Get-NetFirewallProfile -Name Public).LogFileName."
    $err += "Warning! Log file name is $(Get-NetFirewallProfile -Name Public).LogFileName."
}

#max size of the log file
if((Get-NetFirewallProfile -Name Public).LogMaxSizeKilobytes -ge 16384){
    $cv += "Logging: Size limit (KB)' is set to '16,384 KB or greater' "
}
else{
    $fire = (Get-NetFirewallProfile -Name Public).LogMaxSizeKilobytes
    $cv += "Logging size is set to $fire"
    $err += "Logging size is set to $fire"
}

#log the dropped packets
if((Get-NetFirewallProfile -Name Public).LogBlocked){
    $cv += "Logging: Log dropped packets' is set to 'Yes' "
}
else{
    $cv += "Logging: Log dropped packets is set to No"
    $cv += "Logging: Log dropped packets is set to No"
}

#log the allowed packets
if((Get-NetFirewallProfile -Name Public).LogAllowed){
    $cv += "Logging: Log allowed packets' is set to 'Yes' "
}
else{
    $cv += "Logging: Log allowed packets is set to No"
    $err += "Logging: Log allowed packets is set to No"
}
$json = $err | ConvertTo-Json
$json | Out-File "JSON\public_firewall\fwpublic_err.json" -Encoding utf8
$jsonCurrentValue = $cv | ConvertTo-Json
$jsonCurrentValue | Out-File "JSON\public_firewall\fwpublic_CurrentValue.json" -Encoding utf8

