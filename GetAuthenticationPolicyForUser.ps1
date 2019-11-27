$user= "scanner"
if((Get-User -Identity $user | select -ExpandProperty AuthenticationPolicy) -eq $null) {
   Write-Host "User"
   Get-User -Identity $user | select DisplayName,Identity,WindowsEmailAddress,UserPrincipalName |fl
   Write-Host "Effective Authentication Policy" 
   Get-AuthenticationPolicy -identity (Get-OrganizationConfig | select -ExpandProperty DefaultAuthenticationPolicy) | select Name,Allow* |fl
}else {
   Write-Host "User"
   Get-User -Identity $user | select DisplayName,Identity,WindowsEmailAddress,UserPrincipalName |fl
   Write-Host "Effective Authentication Policy" 
   Get-AuthenticationPolicy -identity (Get-User -Identity $user | select -ExpandProperty AuthenticationPolicy) | select Name,Allow* |fl
}
