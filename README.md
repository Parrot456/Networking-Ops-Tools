# Repository Purpose
Meant to be a collection of mostly Windows native tools that can be used by ops support teams and engineers to assess the state of the network.

Split into functions and notes.

# Notes

**Notes_nmap-basic**
nmap captures and service specific scanning notes.

**Notes_run-script-from-repos**
Suggestions for accessing tools in a mixed Windows/Linux environment that may not have ideal configuration (secure repo).

# Functions
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

Shows all active TCP connections associated with a process name. Name matches are wildcard to capture all relevant processes. All TCP connections will include the related process ID. Examples--

#Output all TCP connections used by Firefox

get-processTCP -ProcessName firefox

**nmap-basics**

Notes on commonly used nmap options. Includes examples of application specific scanning such as SQL and REDIS.

**Wireshark-filters-notes**

Capture and display filters to exatract specific information such as strings.