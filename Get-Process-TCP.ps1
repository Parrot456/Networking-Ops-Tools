function Get-processTCP {
    [CmdletBinding()]
    param ( #parameter is accepted from pipeline
        [Parameter(ValueFromPipeline)]
        [string[]]$processName #Will accept an array
    )
    PROCESS { #core actions for the function run here, runs once per piped item, uses foreach loop in case an array is piped
        foreach ($Computer in $ComputerName) {
            try { #try executes the code
                Write-Host -message "Attempting to connect to $computer"
                Test-WSMan -ComputerName $Computer -ErrorAction Stop #ErrorAction Stop turns all errors into terminating errors so the catch block will run.
            }
            catch { #catch supresses terminating error messages and writes a custom string to the console
                Write-Warning -Message "Well that didn't work..."
            }
        }
    }

}


#############################

#Make search a wildcard match
$processName = "*$processName*"

#
$EstablishedConnections = Get-NetTCPConnection -State Established | Select-Object -Property LocalAddress, LocalPort, @{name = 'RemoteHostName'; expression = { (Resolve-DnsName $_.RemoteAddress).NameHost } }, RemoteAddress, RemotePort, State, @{name = 'ProcessName'; expression = { (Get-Process -Id $_.OwningProcess). Path } }, OffloadState, CreationTime
Foreach ($Connection in $EstablishedConnections) {
    If ($Connection.ProcessName -like $processName) {
        $Connection | ConvertTo-Csv | select-object -skip 1 | Out-File c:\temp\firefoxTCP.csv -Append
    }
}