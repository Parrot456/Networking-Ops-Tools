<#
.DESCRIPTION
Generates a capture file (.etl format) using windows native tools. To analyze in wireshark use ETL2PCAP to convert to PCAP.

Note that there is a PID listed in .etl files. This is generally not accurate and should be ignored.

.EXAMPLE
Expected time format: 2024-03-21T13:50:52.5084429Z
Use this command to get the current time then modify: (Get-Date).ToUniversalTime().ToString("o")

$start = "2024-03-21T13:00:00.0004429Z"
$end = "2024-03-21T13:10:00.0004429Z"
Start-ETLPacketCapture -StartTimeISO8601 $start -EndTimeISO8601 $end
#>
function Start-ETLPacketCapture {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$StartTimeISO8601,

        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$EndTimeISO8601
    )
    PROCESS {
        #Normalize timestamps
        $startTime = [DateTime]::Parse($StartTimeISO8601)
        $endTime = [DateTime]::Parse($EndTimeISO8601)

        #Validate that the end time is after the start time
        if ($endTime -lt $startTime) {
            Write-Error "End time must be after start time."
            return
        }

        #Wait until the start time
        while ((Get-Date) -lt $startTime) {
            Write-Host "Waiting for start time..."
            Start-Sleep -Seconds 1
        }

        #Trace file name contains date and hostname
        $ETLDateStr = (get-date).ToString("yyyyMMddhhmm")
        $ETLNameSTR = (hostname) + '.etl'
        $ETLNameFull = (get-location | Select-Object path).path + '\' + $ETLDateStr + '_' + $ETLNameSTR

        #Start trace
        netsh trace start capture=yes report=disabled tracefile=$ETLNameFull

        #wait until end time
        while ((get-date) -lt $endTime) {
            Write-Output "Capture in progress..."
            start-sleep -Seconds 5
        }
    }
    END {
        #Stop capture
        Write-Output "Trace stopped"

        #Stop capture
        netsh trace stop
    }
}
