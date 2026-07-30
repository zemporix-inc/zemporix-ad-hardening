function Export-ZxADSnapshot {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path, [string]$Server)
    $domain = Get-ADDomain -Server $Server
    $forest = Get-ADForest -Server $Server
    $snapshot = [ordered]@{
        generatedAt=(Get-Date).ToUniversalTime().ToString('o')
        domain=[ordered]@{ dnsRoot=$domain.DNSRoot; mode=[string]$domain.DomainMode; pdc=$domain.PDCEmulator }
        forest=[ordered]@{ root=$forest.RootDomain; mode=[string]$forest.ForestMode }
        findings=@(Test-ZxADHardening -Server $Server)
    }
    $snapshot | ConvertTo-Json -Depth 7 | Set-Content $Path -Encoding UTF8
    Get-Item $Path
}
