BeforeAll {
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\PSSophosCentral.psd1"
    Import-Module -Name $modulePath
}

Describe "Get-PSSophosCentralEndpoint" -Tag getendpoint {

    Context "When not authenticated" {
        It "Throws an error if token is not set" {
            InModuleScope -ModuleName PSSophosCentral {
            $script:token = $null
            $script:dataregion = "https://api-eu01.central.sophos.com"
            }
            { Get-PSSophosCentralEndpoint -endpointId "test-id" } | Should -Throw "Authentication needed. Please call Connect-PSSophosCentral."
        }

        It "Throws an error if data region is not set" {
            InModuleScope -ModuleName PSSophosCentral {
                $script:token = "mock-token"
                $script:dataregion = $null
            }
            { Get-PSSophosCentralEndpoint -endpointId "test-id" } | Should -Throw "Data region not set. Please set the data region."
        }
    }
}
