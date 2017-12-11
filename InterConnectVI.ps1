


Function Inter-ConnectVI{

        $serverName = Read-Host "Enter the server name "
        
        if (!(Inter-getOnlineTest  -ComputerName $serverName)){
            return
        }
        
        if (! (Inter-checkActiveConnection -serverName $serverName )){
            $userName   = Read-Host "Enter the username "
            $password = Read-Host  "Enter the password" -AsSecureString
            if (Inter-ConnectVIServer -serverName $serverName -userName $userName -password $password){
                #Call the menu Function
                Inter-Menu
            }
            else {
                return
            }            
        
        }

        else {
            #Call the menu Function
            Inter-Menu

        }

}



Function Inter-getOnlineTest(){

    Param(
        # Name of the computer
        $ComputerName
        )
    Write-Host -NoNewline "Testing connection with $ComputerName, Please wait... "
    # Test Function
    sleep -Seconds 1
    $onlineTest = Test-Connection -ComputerName  $ComputerName -Count 1 -Verbose -Quiet
        if ($onlineTest -eq $false){
            Write-Host "[Host is offline]"
            return $false
        }
        else {
        
            Write-Host "[OK]"
        }
    return $true
}


Function Inter-checkActiveConnection(){
    
    Param(
    #Param to get the server informations
    $serverName
    )
    
    Write-Host -NoNewline  "Checking for active connections with $serverName, Please wait... "
    $numberServers = $global:DefaultVIServers.Count
    sleep -Seconds 1
    
    
    if ($numberServers -gt 0){
        Write-Host "[OK]"
        Write-Host "You are already connected to one or more server(s)"    
        foreach ($server in $global:DefaultVIServers){
         $server | Format-Table | Out-Default
        }
       return $true
    }
    Write-Host "[No Valid connections found]"
    return $false
}



Function Inter-ConnectVIServer(){
Param (
    $serverName,
    $userName,
    $password
)

$unsecurePassword = (New-Object PSCredential "user",$password).GetNetworkCredential().Password
Connect-VIServer -Server $serverName -User $userName -Password $unsecurePassword -ErrorAction SilentlyContinue | Out-Default 
if ($global:DefaultVIServer -eq $null){
    Write-Host "Cannot connect to this server, Maybe wrong username or password ?"
    return $false
}

return $true

}



Function Inter-Menu(){
Write-Host "1.VMs Scenarios`n2.Exit`nSelect menu item: " -NoNewline
$userChoice = Read-Host
if ($userChoice -eq 1){
    inter-VMAutomationMenu
}
elseif($userChoice -eq 2){
    Exit
}
}







clear

Inter-ConnectVI
