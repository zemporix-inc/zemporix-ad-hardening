function Invoke-ZxADHardening {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param([string]$Baseline='ad-balanced', [string[]]$IncludeControl, [string]$Server)
    $profile = Get-ZxADBaseline $Baseline
    $failed = Test-ZxADHardening -Baseline $Baseline -Server $Server | Where-Object Status -eq Fail
    if ($IncludeControl) { $failed = $failed | Where-Object Id -in $IncludeControl }
    foreach ($finding in $failed) {
        $control = $profile.controls | Where-Object id -eq $finding.Id
        if (-not $control.remediable) { Write-Warning "$($finding.Id) elle değerlendirilmelidir."; continue }
        if (-not $PSCmdlet.ShouldProcess($finding.Id, 'Etki alanı güvenlik ayarını uygula')) { continue }
        switch ($control.type) {
            'PasswordPolicy' {
                $args = @{ Identity=(Get-ADDomain -Server $Server).DistinguishedName; Confirm=$false }
                if ($Server) { $args.Server = $Server }
                $args[$control.parameter] = $control.expected
                Set-ADDefaultDomainPasswordPolicy @args
            }
            'UnsignedLdapPolicy' {
                $path='HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
                New-ItemProperty $path LDAPServerIntegrity -Value $control.expected -PropertyType DWord -Force | Out-Null
            }
        }
    }
    Test-ZxADHardening -Baseline $Baseline -Server $Server
}
