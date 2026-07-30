function Test-ZxADHardening {
    [CmdletBinding()]
    param([string]$Baseline='ad-balanced', [string]$Server)
    $profile = Get-ZxADBaseline $Baseline
    foreach ($control in $profile.controls) {
        try {
            $actual = Get-ZxADValue -Control $control -Server $Server
            $pass = switch ($control.operator) {
                'LessOrEqual' { [double]$actual -le [double]$control.expected }
                'GreaterOrEqual' { [double]$actual -ge [double]$control.expected }
                default { [string]$actual -eq [string]$control.expected }
            }
            [pscustomobject]@{ Id=$control.id; Title=$control.title; Severity=$control.severity
                Status=$(if ($pass) {'Pass'} else {'Fail'}); Expected=$control.expected
                Actual=$actual; Remediable=[bool]$control.remediable }
        } catch {
            [pscustomobject]@{ Id=$control.id; Title=$control.title; Severity=$control.severity
                Status='Error'; Expected=$control.expected; Actual=$_.Exception.Message; Remediable=$false }
        }
    }
}
