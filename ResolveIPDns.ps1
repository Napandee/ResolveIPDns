$ErrorActionPreference = "silentlycontinue"

#Function for DNS Check
Function Get-DnsEntry($iphost)
{
If($ipHost -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
{
[System.Net.Dns]::GetHostEntry($iphost).HostName
}
ElseIf( $ipHost -match "^.*\.\.*")
{
[System.Net.Dns]::GetHostEntry($iphost).AddressList[0].IPAddressToString
} 
ELSE { Throw "Specify either an IP V4 address or a hostname" }
} 
#Menu Section
$Singel = New-Object System.Management.Automation.Host.ChoiceDescription "&Singel object", `
    "Singel DNS object, Either IP or FQDN"	
$File = New-Object System.Management.Automation.Host.ChoiceDescription "&From File", `
	"Search from File, File can contain mixed lines with IP or FQDN"	
$title = "DNS Resolver"
$message = "Welcome to DNS resolver! Both Ip and FQDN can be resolved!"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Singel, $File)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

#Switch and Main Code
switch ($result)
    {
        0 {
			"You selected Singel Object. Remember! FQDN or IP!"
			$SingelHost = Read-Host "FQDN or IP"
			$IpDnsSingelCheck = Get-DnsEntry $SingelHost
			Write-Host "Resolved host: $SingelHost Dns Query Returned: $IpDnsSingelCheck"
		  }
        1 {
			"You selected Search from File. Remember! FQDN or IP!"
			$txtFile = Read-Host "Full Directory to Source Text File"
			$SaveDirectory = Read-Host "Directory for result file"
			$SaveFile = Read-Host "Name and filetype for result file"
			$check = Test-Path -PathType Container $SaveDirectory
				if($check -eq $false)
				{
					New-Item $SaveDirectory -type Directory -Force
				}
			$Content = get-content $txtFile
			Foreach ($iphost in $Content)
				{
					$IpDnsCheck = Get-DnsEntry($iphost)
					$Temp = Add-Content -Path $SaveDirectory\$SaveFile -Value "Supplied Value: $iphost Dns Query Returned Value: $IpDnsCheck"
				}
				Write-Host "All Hosts Validated! Saved information in $SaveDirectory\$SaveFile!"
		}
    }
	

	
