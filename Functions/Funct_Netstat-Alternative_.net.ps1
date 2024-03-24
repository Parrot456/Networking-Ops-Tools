<#
.DESCRIPTION
This function uses .NET classes to quickly generate information on active sockets and output a powershell object with commonly references properties.

Test runs--
    Runtime: 46.3ms
    Runtime: 62.4ms

'Netstat -a' tests--
    Runtime: 228.2ms
    Runtime: 185.1ms

Output is a powershell object instead of a string like netstat. This allows the function to feed into other scripts or trigger an action when a specific socket status changes.

.EXAMPLE
#Run basic command to output active TCP sockets.
Get-TCPConnections

#Export to CSV
Get-TCPConnections | ConvertTo-Csv | Out-File c:\temp\TCPsock.csv

#Extract specific value from a socket for further automation
$var = Get-TCPConnections
$var[0].localEndPoint.Port
#>
function Get-TCPConnections {
    [CmdletBinding()]
    #Get all active TCP connections.
    $allTCPSockets = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetactiveTCPconnections()
    #Create generic list, each socket will be added to the list as a pscustomobject
    $TCPSockProperties = $null
    $TCPSockProperties = New-Object System.Collections.Generic.List[System.Object]
    #Supress .NET errors if domain name can't be resolved
    $ErrorActionPreference = 'silentlycontinue'
    if ($null -eq $allTCPSockets ) {
        Write-Host "No active sockets. Is your interface enabled?"
    }
    else {
        #Properties in common to all sockets. IP is not included to accurately capture loopback vs internet connections.
        $localHostname  = HOSTNAME
        #Collect properties from each active TCP socket.
        foreach ($TCPSocket in $allTCPSockets) {
            #Filter all relevant properties from full output. These will be formatted as a pscustomobject then the table is added to a list.
            $state          = $TCPSocket.State
            $localIPname    = $TCPSocket.LocalEndPoint.address.IPAddressToString
            $localPort      = $TCPSocket.LocalEndPoint.port
            $remoteIPname   = $TCPSocket.RemoteEndPoint.address.IPAddressToString
            $remoteHostname = [System.Net.Dns]::GetHostentry([System.Net.Dns]::GetHostentry($TCPSocket.RemoteEndPoint.address.IPAddressToString).hostname).hostname
            $remotePort     = $TCPSocket.RemoteEndPoint.port
            #Create a table with properties for each socket. Designed for most commonly used properties but could easily expand to include more
            $socketProperties = [PSCustomObject]@{
                "State"          = $State
                "LocalHostname"  = $localHostname
                "LocalIPName"    = $localIPname
                "LocalPort"      = $localPort
                "RemoteHostname" = $remoteHostname
                "RemoteIPName"   = $remoteIPname
                "RemotePort"     = $remotePort
            }
            #Add each pscustomobject with properties to the output list
            $TCPSockProperties.Add($socketProperties)
        }
    }
    $TCPSockProperties
}