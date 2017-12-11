
Function inter-VMAutomationMenu{
Write-Host "1.Start up All VM
2.Shutdown All VM
3.HealthCheck
10. Return
Select menu item: " -NoNewline
$userChoice = Read-Host    
if ($userChoice -eq 1){
    inter-StartUpVMs
}
elseif ($userChoice -eq 2){
    inter-StopVMs
}
elseif ($userChoice -eq 3){
    inter-HealthCheck
}
}

Function inter-StartUpVMs{
$VMs = Get-VM
$VMs | foreach {
Write-Host "Starting $($_.name)"
$StaringVMs = Start-VM $_ -Confirm:$false -RunAsync
}

$VMs | Foreach {
do {
$VMs = Get-VM $_
$Toolsstatus = $VMs.ExtensionData.Guest.ToolsRunningStatus
Write-Host "Waiting for $VMs to start, tools status is $Toolsstatus"
Sleep 7
} until ($Toolsstatus -eq "guestToolsRunning")
}
}


Function inter-StopVMs{
$VMs = Get-VM
$VMs | foreach {
if ($_.Name -ne "VMware vCenter Server Appliance"){
Write-Host "Stoping $($_.name)"
$StaringVMs = Stop-VM $_ -Confirm:$false -RunAsync
}
}
$VMs | Foreach {
if (-ne "VMware vCenter Server Appliance"){
do {
$VMs = Get-VM $_
$Toolsstatus = $VMs.ExtensionData.Guest.ToolsRunningStatus
Write-Host "Waiting for $VMs to stop, tools status is $Toolsstatus"
Sleep 7
} until ($Toolsstatus -eq "guestToolsNotRunning")
}
}
}


Function inter-HealthCheck{
Get-VM  | Get-View | Select Name,@{Name=”Hardware Version”; Expression={$_.Config.Version}},
@{Name=”Tools Status”; Expression={$_.Guest.ToolsStatus}},
@{Name=”Tools Version Status”; Expression={$_.Guest.ToolsVersionStatus}},
@{Name=”Tools Version”; Expression={$_.Guest.ToolsVersion}},
@{Name=”Snapshots”; Expression={(((Get-Snapshot -VM (Get-VM -Name $_.Name)).Name)).Length -ne 0}},
@{Name=”Data Store path”; Expression={((((Get-VM -Name $_.Name)).DatastoreIdList)).Length -ne 0}}
}

Function inter-TEST{

}
inter-VMAutomationMenu


