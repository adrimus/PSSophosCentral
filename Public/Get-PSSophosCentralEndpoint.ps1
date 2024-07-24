function Get-PSSophosCentralEndpoint {
    <#
    .SYNOPSIS
    Get's info an a endpoint registered in Sophos Central

    .DESCRIPTION
    Uses the endpoint API to get information on an endpoint based on ID. This command needs the tenant ID and JWT for the header information.
    You can specify the Device ID which will directly added to the URI.
    If you specify the Computername, the function will use Get-PSSophosCentralAllEndpoints to create a hashtable to beable to search for the Device ID using the Computername

    .EXAMPLE
    Get-PSSophosCentralEndpoint -computername LAP001

    .EXAMPLE
    Get-PSSophosCentralEndpoint -DeviceId ffc1ceb4-c046-44cd-a9e5-312asf6658c0b

    .NOTES
    The Data Region and Tenant ID should be available in the Script scope from the Connect-PSSophosCentral
    Http request format: https://api-{dataRegion}.central.sophos.com/endpoint/v1/endpoints/{endpointId}
    .LINK
    https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/get
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        # The ID of the device in Sophos Central
        [Parameter(Mandatory = $true)]
        [string]
        [Alias("Id")]
        $endpointId
    )

    begin {
        #region check

        # Check if connected to Sophos Central
        Write-Verbose "[$script:tenantid]"
        Write-Verbose "[$script:dataregion]"

        if (-not ($script:token)) {
            throw "Authentication needed. Please call Connect-PSSophosCentral."
        }

        #endregion

        #region Header
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"
        $headers = @{
            "Authorization" = "Bearer $script:token"
            "X-Tenant-ID"   = $script:TenantID
            "Accept"        = "application/json"
        }
        Write-Verbose "[BEGIN ] $headers"
        #endregion

    } #begin

    process {
        Write-Verbose "[PROCESS] Starting: $($MyInvocation.Mycommand)"
        try {

            #region API request

            $url = "{0}/endpoint/v1/endpoints/{1}?view=full" -f $script:dataregion, $endpointId

            Write-Verbose "URI: [$url]"
            Write-Verbose "Dataregion [$($script:dataregion)]"

            $invokeRestMethodSplat = @{
                Uri     = $url
                Method  = 'GET'
                Headers = $headers
            }

            Invoke-RestMethod @invokeRestMethodSplat

            #endregion
        }
        catch {

            write-error "Error with request: [$($_.message)]"

        } #try/catch

    } #process

    end {
        Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #function Get-PSSophosCentralEndpoint