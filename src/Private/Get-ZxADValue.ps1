function Get-ZxADValue {
    param([pscustomobject]$Control, [string]$Server)
    $serverArgs = if ($Server) { @{ Server = $Server } } else { @{} }
    switch ($Control.type) {
        'PasswordPolicy' {
            $policy = Get-ADDefaultDomainPasswordPolicy @serverArgs
            return $policy.($Control.property)
        }
        'DomainProperty' {
            $domain = Get-ADDomain @serverArgs
            return $domain.($Control.property)
        }
        'PrivilegedGroupCount' {
            return @(Get-ADGroupMember -Identity $Control.group -Recursive @serverArgs).Count
        }
        'InactiveComputerCount' {
            $limit = (Get-Date).AddDays(-[int]$Control.days)
            return @(Get-ADComputer -Filter 'Enabled -eq $true' -Properties LastLogonDate @serverArgs |
                Where-Object { -not $_.LastLogonDate -or $_.LastLogonDate -lt $limit }).Count
        }
        'UnsignedLdapPolicy' {
            $path = 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
            return (Get-ItemProperty $path -Name LDAPServerIntegrity -ErrorAction SilentlyContinue).LDAPServerIntegrity
        }
        default { throw "Bilinmeyen AD kontrol türü: $($Control.type)" }
    }
}
