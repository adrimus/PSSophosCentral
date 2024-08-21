BeforeAll {
    Import-Module ..\PSSophosCentral.psd1 -Force

    $passwordPath = Join-Path (Split-Path $profile) SecretStore.vault.credential
    $password = Import-CliXml -Path $passwordPath

    Unlock-SecretStore -Password $password
    $clientid = Get-Secret -Name TamperProtection-ClientID -AsPlainText
    $clientsecret = Get-Secret -Name TamperProtection-Secret -AsPlainText

    Connect-PSSophosCentral -clientid $clientid -clientsecret $clientsecret
}

Describe 'Get-PSSophosCentralAllEndpoints' -Tag Endpoints {
    It 'Returns devices with good health status' {
        $results = Get-PSSophosCentralAllEndpoints -healthStatus good
        foreach ($result in $results) {
            $result.health | Should -BeExactly 'good'
        }
    }
}