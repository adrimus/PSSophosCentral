BeforeAll {
    $module = Import-Module ..\PSSophosCentral.psd1 -PassThru

    $ModuleName = "PSSophosCentral"
    $ModuleManifestName = "$ModuleName.psd1"
    $ModuleManifestPath = "..\$ModuleManifestName"
}

write-host "`$ModuleManifestName: [$ModuleManifestName]"
Write-Host "PSScriptRoot: [$PSScriptRoot]"
Write-Host "ModuleManifestPath: [$ModuleManifestPath]"

Describe 'Module Manifest' -Tag Module {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -Be BeNullOrEmpty
        $? | Should -Be $true
    } #it

    context 'Available commands' {

        it 'Get-PSSophosCentralEndpoint should be available' {
            $commands = get-command -module 'PSSophosCentral'
            $commands.name | should -contain 'Get-PSSophosCentralEndpoint'
        }

    }
} #Describe


