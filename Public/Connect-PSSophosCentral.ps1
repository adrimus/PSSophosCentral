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
    Connect-PSSophosCentral -clientid $clientid -clientsecret $clientsecret

    Connect to Sophos Central using credentials from SecretManagement
    .NOTES
    General notes
    #>
    [CmdletBinding()]

    [OutputType([string])]

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

        try {
            $response = Invoke-RestMethod -Uri 'https://id.sophos.com/api/v2/oauth2/token' -Method 'POST' -Headers $headers -Body $body
        } catch {
            throw $_.exception.message
        } #try/catch

        #Get the Tenant ID and Data Region
        $data = Get-PSSophosCentralContext -token $response.access_token

        # The response from the above command need to be available for subsequent API calls
        $script:token = $response.access_token
        $script:TenantId = $data.TenantId
        $script:DataRegion = $data.dataRegion

        Write-Verbose "`$Script:DataRegion: [$script:DataRegion]"

        Write-Output "Connection Successful"

    } #process

} #Connect-PSSophosCentral function