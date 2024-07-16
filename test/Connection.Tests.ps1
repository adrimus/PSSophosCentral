BeforeAll {
    Import-Module ..\..\PSSophosCentral
}

Describe 'Testing the Endpoint commands' {
    It 'Creates Dataregion variable' {
        InModuleScope PSSophosCentral {
            $script:dataregion | Should -not -BeNullOrEmpty
            $script:dataregion | Should -BeLike 'https://*sophos.com'
        }
    } #it

    It 'Gets a JWT' {
        InModuleScope PSSophosCentral {
            $script:token | Should -not -BeNullOrEmpty
        }
    }

    it 'Gets the Tenant ID' {
        InModuleScope PSSophosCentral {
            $script:TenantId | Should -not -BeNullOrEmpty
        }
    }

} #Describe