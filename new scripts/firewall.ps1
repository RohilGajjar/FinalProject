Clear-Host
$benchmark = @() #benchmark status
$cv = @() #Current Values
$err = @()

#Firewall status for the private profile
if((Get-NetFirewallProfile -Name Private).Enabled)
    {
    $cv += "Private: Firewall state is set to On"
}
else{ 
    $cv +=  "1) Windows Firewall: Private: Firewall state' is set to Off"
    $err +=  "1) Windows Firewall: Private: Firewall state' is set to Off"
}

#Firewall status for the inbound connections
if((Get-NetFirewallProfile -Name Private).DefaultInboundAction -eq "Block"){
    $cv += "Inbound connections to Private profile are set to 'Block'"
    $cv += "Block"
}
else {
    $fire = (Get-NetFirewallProfile -Name Private).DefaultInboundAction
    $cv += "Inbound connections to Private profile are $fire "
    $err += "Inbound connections to Private profile are $fire "
}

#Firewall status for the outbound connections
if((Get-NetFirewallProfile -Name Private).DefaultOutboundAction -eq "Allow"){
    $cv += "Outbound connections are set to 'Allow'"
}
else{
    $fire = ((Get-NetFirewallProfile -Name Private).DefaultOutboundAction)
    $cv += "Outbound connections are $fire"
    $err += "Outbound connections are $fire"
}

#Notify on listen
if((Get-NetFirewallProfile -Name Private).NotifyOnListen -eq "False"){
    $cv += "Display a notification' is set to No"
}
else{
    $fire = (Get-NetFirewallProfile -Name Private).NotifyOnListen
    $cv += "Display a notification' is set to $fire"
    $err += "Display a notification' is set to $fire"
}
if((Get-NetFirewallProfile -Name Private).AllowLocalFirewallRules -eq "False"){
    $cv += "Apply local firewall rules is set to 'No' "
}
else{
    $fire = (Get-NetFirewallProfile -Name Private).AllowLocalFirewallRules
    $cv += "Apply local firewall rules is set to $fire"
    $err += "Apply local firewall rules is set to $fire"
}

#log file name
if((Get-NetFirewallProfile -Name Private).LogFileName -eq "%systemroot%\system32\LogFiles\Firewall\pfirewall.log"){
    $cv += "Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\Privatefw.log'"
    }
else{
    $cv += "Warning! Log file name is $(Get-NetFirewallProfile -Name Private).LogFileName."
    $err += "Warning! Log file name is $(Get-NetFirewallProfile -Name Private).LogFileName."
}

#max size of the log file
if((Get-NetFirewallProfile -Name Private).LogMaxSizeKilobytes -ge 16384){
    $cv += "Logging: Size limit (KB)' is set to '16,384 KB or greater' "
}
else{
    $fire = (Get-NetFirewallProfile -Name Private).LogMaxSizeKilobytes
    $cv += "Logging size is set to $fire"
    $err += "Logging size is set to $fire"
}

#log the dropped packets
if((Get-NetFirewallProfile -Name Private).LogBlocked){
    $cv += "Logging: Log dropped packets' is set to 'Yes' "
}
else{
    $cv += "Logging: Log dropped packets is set to No"
    $err += "Logging: Log dropped packets is set to No"
}

#log the allowed packets
if((Get-NetFirewallProfile -Name Private).LogBlocked){
    $cv += "Logging: Log allowed packets' is set to 'Yes' "
}
else{
    $cv += "Logging: Log allowed packets is set to No"
    $err += "Logging: Log allowed packets is set to No"
}
$jsonCurrentValue = $cv | ConvertTo-Json
$jsonCurrentValue | Out-File "project\JSON\pvt_firewall\fwprivate_CurrentValue.json" -Encoding utf8
$jsonError = $cv | ConvertTo-Json
$jsonError | Out-File "project\JSON\pvt_firewall\fwprivate_error.json" -Encoding utf8