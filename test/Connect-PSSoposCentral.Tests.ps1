BeforeAll {
    Import-Module ..\PSSophosCentral.psd1

    $passwordPath = Join-Path (Split-Path $profile) SecretStore.vault.credential
    $password = Import-CliXml -Path $passwordPath

    Unlock-SecretStore -Password $password
    $clientid = Get-Secret -Name TamperProtection-ClientID -AsPlainText
    $clientsecret = Get-Secret -Name TamperProtection-Secret -AsPlainText

}

Describe "Connect-PSSoposCentral" {
    It "Returns expected output" {
            Connect-PSSophosCentral -clientid $clientid -clientsecret $clientsecret | Should -Be "Connection Successful"
    }
}
