@{
    RootModule='src/Zemporix.ADHardening.psm1'; ModuleVersion='1.0.0'
    GUID='b390de17-2d43-4a72-8839-302ddcd0ce02'; Author='zemporix-inc'
    CompanyName='zemporix-inc'; Copyright='(c) 2026 zemporix-inc. MIT License.'
    Description='Active Directory güvenlik duruşunu denetleyen PowerShell modülü.'
    PowerShellVersion='5.1'
    RequiredModules=@('ActiveDirectory')
    FunctionsToExport=@('Test-ZxADHardening','Invoke-ZxADHardening','Export-ZxADSnapshot')
}
