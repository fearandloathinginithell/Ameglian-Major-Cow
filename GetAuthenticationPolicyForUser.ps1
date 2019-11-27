$user= "scanner"
if((Get-User -Identity $user | select -ExpandProperty AuthenticationPolicy) -eq $null) {
   Write-Host "User"
   Get-User -Identity $user | select DisplayName,Identity,WindowsEmailAddress,UserPrincipalName |fl
   Write-Host "Effective Authentication Policy from the default assignment"
        if((Get-OrganizationConfig | select -ExpandProperty DefaultAuthenticationPolicy) -eq $null) {
        Write-Host "No Policy assigned"
        }else {
        Get-AuthenticationPolicy -identity (Get-OrganizationConfig | select -ExpandProperty DefaultAuthenticationPolicy) | select Name,Allow* |fl
        }
}else {
   Write-Host "User"
   Get-User -Identity $user | select DisplayName,Identity,WindowsEmailAddress,UserPrincipalName |fl
   Write-Host "Effective Authentication Policy from the direct assignment" 
   Get-AuthenticationPolicy -identity (Get-User -Identity $user | select -ExpandProperty AuthenticationPolicy) | select Name,Allow* |fl
}
