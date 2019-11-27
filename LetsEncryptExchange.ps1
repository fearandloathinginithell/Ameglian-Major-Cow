<#
https://github.com/rmbolger/Posh-ACME
https://github.com/rmbolger/Posh-ACME/blob/master/Tutorial.md
https://github.com/rmbolger/Posh-ACME/blob/master/Posh-ACME/DnsPlugins/Azure-Readme.md
Install-Module -Name Posh-ACME
Data located in %LOCALAPPDATA%\Posh-ACME
Default Password for cert 'poshacme'
get-help New-PACertificate
#>
 
Set-PAServer LE_STAGE
#Set-PAServer LE_PROD

$azParams = @{
  AZSubscriptionId='<GUID>';
  AZTenantId='<GUID>';
  AZAppUsername='<GUID>'
  AZAppPasswordInsecure='<PASSWORD>';
}

# issue a cert
$contact = "me@example.com"

#New Exchange Cert
New-PACertificate 'mail.example.com','example.com','hybrid.example.com','autodiscover.example.com' `
-DnsPlugin Azure -PluginArgs $azParams -AcceptTOS -Force -Verbose -CertKeyLength 2048 -NewCertKey -contact $contact # -Install 

#REPLACE WITH
#Submit-Renewal 'mail.example.com' -NewKey -Force

#Get the important stuff
Get-PACertificate |select -ExpandProperty PfxFile -OutVariable CertPfxFile
Get-PACertificate |select -ExpandProperty Thumbprint -OutVariable CertThumbprint
Get-PACertificate |select -ExpandProperty Subject -OutVariable CertSubject
Get-PACertificate |select -ExpandProperty NotBefore -OutVariable CertNotBefore
$FriendlyName = "$CertSubject $CertNotBefore"

#Add exchange module
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
Import-Module 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#Import Exchange Certificate
Import-ExchangeCertificate -FileData ([Byte[]]$(Get-Content -Path "$CertPfxFile" -Encoding Byte -ReadCount 0)) `
-Password (ConvertTo-SecureString -String 'poshacme' -AsPlainText -Force) -PrivateKeyExportable $true -FriendlyName $FriendlyName
Get-ExchangeCertificate -Thumbprint $CertThumbprint |select * |fl

Enable-ExchangeCertificate -Thumbprint $CertThumbprint -Services IIS
