function Get-PSSophosCentralEndpoint {
    <#
    .SYNOPSIS
    Get's info an a endpoint registered in Sophos Central

    .DESCRIPTION
    Uses the endpoint API to get information on an endpoint based on ID. This command needs the tenant ID and JWT for the header information.

    .EXAMPLE
    Get-PSSophosCentralEndpoint

    .NOTES
    The Data Region and Tenant ID should be available in the Script scope from the Connect-PSSophosCentral
    Http request format: https://api-{dataRegion}.central.sophos.com/endpoint/v1/endpoints/{endpointId}
    .LINK
    https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/get
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4
    #>
    [CmdletBinding()]
    param (
        # The ID of the device in Sophos Central
        [Parameter(Mandatory = $true)]
        [string]
        [Alias("DeviceId")]
        $endpointId,

        # Basic view to be returned in response
        [Parameter(Mandatory=$false)]
        [switch]
        $Basic,

        # Summary view to be returned in response
        [Parameter(Mandatory=$false)]
        [switch]
        $Summary,

        # Full view to be returned in response
        [Parameter(Mandatory=$false)]
        [switch]
        $Full
    )

    begin {
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"
        $headers = @{
            "Authorization" = "Bearer $script:token"
            "X-Tenant-ID"   = $script:TenantID
        }
        Write-Verbose "[BEGIN ] $headers"
    } #begin

    process {
        $url = "{0}/endpoint/v1/endpoints/{1}" -f $script:dataregion, $endpointId
        Write-Verbose "URI: [$url]"
        Write-Verbose "Dataregion [$($script:dataregion)]"

        try {
            Invoke-RestMethod -Uri $url -Method GET -Headers $headers
        }
        catch {
            write-error "Error with request: [$_]"
        } #try/catch
    } #process

    end {
        Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #function Get-PSSophosCentralEndpoint