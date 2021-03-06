﻿$servers = Get-content -Path "C:\Temp\servers.txt"
add-pssnapin Citrix*

foreach($server in $servers){

$session = Get-BrokerSession -MachineName $server | select -ExpandProperty UserName

if(!($session -eq $null)){

write-host "$server is having sessions"

$MM = Set-BrokerMachineMaintenanceMode -InputObject $server $true

Start-Sleep -Seconds 2

#$SessionName = $session | select -ExcludeProperty UserName

$sessions = Get-BrokerSession -UserName $session

$Messgae1 = Send-BrokerSessionMessage -InputObject $sessions -MessageStyle Information -Title testwarning -Text "Reminder1: Due to Server maintanance please save your works and logoff"

start-sleep -Seconds 10


$sessions15min = Get-BrokerSession -MachineName AHS\AWS01MCSAHSD02P | select -ExpandProperty UserName

if(!($sessions15min -eq $null)){

write-host "$server is having sessions"

Start-Sleep -Seconds 2
$session15min = Get-BrokerSession -UserName $sessions15min

$Messgae2 = Send-BrokerSessionMessage -InputObject $session15min -MessageStyle Information -Title testwarning -Text "Final Reminder: Machine is going to shutdown in 15mins, please logoff to save your workloads"

start-sleep -Seconds 10

$Messgae3 = Send-BrokerSessionMessage -InputObject $sessions -MessageStyle Information -Title testwarning -Text "Shutdown Reminder: Machine is going to shutdown!!!!"

$shutdown = New-BrokerHostingPowerAction -Action shutdown -MachineName "$server"

$shutdown

write-host "$server got shutdown succesfully "


}

else{

$shutdown = New-BrokerHostingPowerAction -Action shutdown -MachineName "$server"

$shutdown

write-host "$server got shutdown succesfully "

}

}

else{


$shutdown = New-BrokerHostingPowerAction -Action shutdown -MachineName "$server"

$shutdown

write-host "$server got shutdown succesfully "


}


}