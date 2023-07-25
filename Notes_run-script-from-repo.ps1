#set origin of script file. Should be a github raw link.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

#download script defined above
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

#run script
powershell.exe -ExecutionPolicy ByPass -File $file