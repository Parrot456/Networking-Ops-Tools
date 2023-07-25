#links
https://pentestlab.blog/2012/04/02/nmap-techniques-for-avoiding-firewalls/ #firewall bypass

####GENERAL USE####
#Does not run scripts, initial recon, very fast
nmap -sS -Pn -p- --open --min-rate 5000 --max-retries 2 --min-hostgroup 256 -oA nmap_fullscan 192.168.88.0/24

-sS
-Pn 
-p- 
--open 
--min-rate
--max-retries
--min-hostgroup
-oA

#use all scripts and scan all ports on a specific host or network
nmap -sV -sC 192.168.1.1

-sV #probe open ports for service/version info
-sC #run scripts, can be used on individual ports to minimize detection
####

#scan a single port
nmap -p 10001 -Pn 65.29.131.224

#scan udp ports
nmap -sU -p 500,4500 -v 192.168.1.1

#scan range of ports
nmap  -p 1000-32000 localhost

#nmap preset list
$presetList = [ordered]@{
    Default         = ''
    Intense         = '-T4 -A'
    IntenseAllTCP   = '-T4 -p 1-65535 -A'
    IntensePlusUDP  = '-T4 -sS -sU -A'
    IntenseNoPing   = '-T4 -A -v -Pn'
    PingSweep       = '-T4 -sn'
    Quick           = '-T4 -F'
    QuickPlus       = '-T4 --version-intensity 2 -sV -O -F'
    QuickTraceroute = '-T4 -sn -traceroute'
    Snmp            = '-T4 -sU -p U:161'
}

nmap $presetList.Quick 8.8.8.8



#advanced nmap, scans all tcp ports and sends 5000 packets per second
nmap -p- --min-rate 5000 -sV 10.129.136.91

####Enumeration####

#mysql enumeration
nmap --script=mysql-enum 
    Performs valid-user enumeration against MySQL server using a bug discovered and published by Kingcope 
    (http://seclists.org/fulldisclosure/2012/Dec/9). Server version 5.x are susceptible to an user enumeration 
    attack due to different messages during login when using old authentication mechanism from versions 4.x and earlier.
nmap -sV -sC 10.129.105.5 #seems more useful
    -sC: Performs a script scan using the default set of scripts. It is equivalent to --
    script=default. Some of the scripts in this category are considered intrusive and
    should not be run against a target network without permission.
    -sV: Enables version detection, which will detect what versions are running on what
    port.

#enumerate redis
nmap --script redis-info -sV -p 6379 <ip>

#enumerate http
nmap -sV --script=http-enum 8.8.8.8