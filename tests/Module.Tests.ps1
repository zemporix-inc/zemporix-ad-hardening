BeforeAll { Import-Module "$PSScriptRoot/../Zemporix.ADHardening.psd1" -Force }
Describe 'AD hardening paketi' {
    It 'manifest geçerlidir' { Test-ModuleManifest "$PSScriptRoot/../Zemporix.ADHardening.psd1" | Should -Not -BeNullOrEmpty }
    It 'kontrol kimlikleri benzersizdir' {
        $b=Get-Content "$PSScriptRoot/../baselines/ad-balanced.json" -Raw|ConvertFrom-Json
        @($b.controls.id|Select-Object -Unique).Count | Should -Be $b.controls.Count
    }
}
