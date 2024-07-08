function Get-PSSophosCentralContext {
    <#
    .SYNOPSIS
    Gets the metadata used to authenticate HTTPS requests

    .DESCRIPTION
    Get's the Region and TenantID which is used in the HTTPS request headers

    .EXAMPLE
    $response = Connect-SophosCentral -clientid $clientid -clientsecret $clientsecret
    Get-PSSophosCentralContext -token $response.access_token

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        # Token to be used in the header of the HTTPS request
        [Parameter(Mandatory = $true)]
        [string]
        $token
    )

    process {

        $headers = @{"Authorization" = "Bearer $token" }
        $gdrresponse = Invoke-RestMethod 'https://api.central.sophos.com/whoami/v1' -Method 'GET' -Headers $headers
        $TenantId = $gdrresponse.id
        $dataregion = $gdrresponse.apiHosts.dataRegion

        #Output object
        [PSCustomObject]@{
            TenantId = $TenantId
            DataRegion = $dataregion
        }

    } #process

} #Get-SophosCentralContext function