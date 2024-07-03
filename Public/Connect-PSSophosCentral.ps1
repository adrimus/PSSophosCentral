function Connect-PSSophosCentral {
    <#
    .SYNOPSIS
    Connect to sophos central using RESTful API

    .DESCRIPTION
    Uses the Sophos Central APIto authenticate with Sophos Central

    .PARAMETER clientid
    Parameter description

    .PARAMETER clientsecret
    Parameter description

    .EXAMPLE
    # Get password for vault
    $passwordPath = Join-Path (Split-Path $profile) SecretStore.vault.credential
    $password = Import-CliXml -Path $passwordPath

    Unlock-SecretStore -Password $password
    $clientid = Get-Secret -Name TamperProtection-ClientID -AsPlainText
    $clientsecret = Get-Secret -Name TamperProtection-Secret -AsPlainText

    # Save response to a variable to get region and tenantID with Get-SophosCentralContext
    $response = Connect-PSSophosCentral -clientid $clientid -clientsecret $clientsecret

    Connect to Sophos Central using credentials from SecretManagement
    .NOTES
    General notes
    #>
    [CmdletBinding()]

    [OutputType(PSCustomObject)]

    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $clientid,

        [Parameter(Mandatory = $true)]
        [string]
        $clientsecret
    )

    process {
        $body = "grant_type=client_credentials&scope=token&client_id=$clientid&client_secret=$clientsecret"
        $headers = @{"Content-Type" = "application/x-www-form-urlencoded" }
        $response = Invoke-RestMethod -Uri 'https://id.sophos.com/api/v2/oauth2/token' -Method 'POST' -Headers $headers -Body $body
        $response
    } #process

} #Connect-PSSophosCentral function