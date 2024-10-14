BeforeAll {
    Import-Module $PSScriptRoot\..\PSSophosCentral.psm1 -Force -PassThru
}

Describe "Get-PSSophosCentralEndpoint" -Tag getendpoint {

    Context "Testing script parameters" {

        BeforeEach {
            Mock Invoke-RestMethod -ModuleName PSSophosCentral -MockWith {  <#do nothing#> }
        }

        It "Should run without errors" {

            InModuleScope -ModuleName PSSophosCentral {
                $script:token = "1234567"
                $script:dataregion = "https://api-us01.central.sophos.com"
            }

            Get-PSSophosCentralEndpoint -endpointId "3fheufh-sdgfdh-3534dsf" |
            Should -Invoke Invoke-RestMethod -ModuleName PSSophosCentral -ParameterFilter {
                $Method -eq "GET" -and $Uri -like "*/endpoint/v1/endpoints/*"
            }

        } #it

        It "Throws an error if token is not set" {
            InModuleScope -ModuleName PSSophosCentral {
                $script:token = $null
                $script:dataregion = "https://api-eu01.central.sophos.com"
            }
            { Get-PSSophosCentralEndpoint -endpointId "3fheufh-sdgfdh-3534dsf" } |
            Should -Throw "Authentication needed. Please call Connect-PSSophosCentral."
        } #it

        It "Throws an error if data region is not set" {
            InModuleScope -ModuleName PSSophosCentral {
                $script:token = "mock-token"
                $script:dataregion = $null
            }
            { Get-PSSophosCentralEndpoint -endpointId "test-id" } |
            Should -Throw "Data region not set. Please set the data region."
        } #it

    } #context

} #Describe
