<#
.DESCRIPTION
Shows all active TCP connections by process name. All names are converted to wildcard format so connections for multiple process ID's may be returned.

Results are filtered from Get-NetTCPConnection

.EXAMPLE
#Search for a process and display TCP connection information. 
get-processTCP -ProcessName firefox

#Search for a process and show TCP connections for a specific process. Note that the output is
$firefoxTCPConnections = get-processTCP -ProcessName firefox

$firefoxTCPConnections[15]
LocalAddress         : 192.168.1.5
LocalPort            : 46175
RemoteAddress        : 30.92.257.198
RemotePort           : 443
OwningProcess        : 34760
AppliedSettings      : 
OffloadState         : InHost
InstanceID           : 192.168.1.5++46175++30.92.257.198++443
EnabledDefault       : 2
RequestedState       : 5
TransitioningToState : 12

#


#>
function Get-processTCP {
    [CmdletBinding()]
    param(
        [string]$ProcessName
    )
    #Get the process ID for the given process name
    $processName = "*$processName*"
    $process = Get-Process -Name $ProcessName
    if ($null -eq $process ) {
        Write-Host "Process '$ProcessName' not found."
    }
    else {
        #Get  TCP connections for the owning process
        $connections = Get-NetTCPConnection -OwningProcess $process.Id -ErrorAction SilentlyContinue
        if ($null -eq $connections) {
            Write-Host "No TCP connections found for wildcard process name '$ProcessName'"
        }
        else {
            $filteredConProp = $connections | Select-Object LocalAddress, LocalPort, RemoteAddress, `
            RemotePort, OwningProcess, AppliedSettings, OffloadState, InstanceID, EnabledDefault, RequestedState, TransitioningToState
            
            
            $filteredConProp
        }
    }
}