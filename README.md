# Networking-Ops-Tools
A collection of scripts for testing and baselining a windows network

**Netstat-Alternative_.net**
Designed to be a faster version of netstat and output a usable object instead of a string block. Examples--

#Run basic command to output active TCP sockets.
Get-TCPConnections

#Export to CSV
Get-TCPConnections | ConvertTo-Csv | Out-File c:\temp\TCPsock.csv

#Extract specific value from a socket for further automation
$var = Get-TCPConnections
$var[0].localEndPoint.Port

**Get-processTCP**
Shows all active TCP connections associated with a process name. Name matches are wildcard to capture all relevant processes. All TCP connections will include process ID. Examples--

#Output all TCP connections used by Firefox
get-processTCP -ProcessName firefox
