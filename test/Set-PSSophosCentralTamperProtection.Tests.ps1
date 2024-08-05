BeforeAll {
    Import-Module ..\PSSophosCentral.psd1
}

Describe "Set-PSSophosCentralEndpointTamperProtection" {
    It "Returns expected output when disabling tamper protection" {

        # Define the expected result
        $expectedResult = @{
            'enabled' = $false
        }

        $result = Set-PSSophosCentralTamperProtection -endpointId "1f9c5e88-69aa-43b1-b355-777895a3484e" -isEnabled no

        # Compare the actual result with the expected result
        $result.enabled | Should -Be $expectedResult.enabled
    }

}