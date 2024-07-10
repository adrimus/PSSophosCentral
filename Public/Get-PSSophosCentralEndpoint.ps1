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
        [Parameter(Mandatory = $true, ParameterSetName = 'SearchById')]
        [string]
        [Alias("DeviceId")]
        $endpointId,

        [Parameter(Mandatory = $true, ParameterSetName = 'SearchbyName')]
        [string]
        [Alias("Hostname")]
        $computername,

        # Basic view to be returned in response
        [Parameter(Mandatory = $false)]
        [switch]
        $Basic,

        # Summary view to be returned in response
        [Parameter(Mandatory = $false)]
        [switch]
        $Summary,

        # Full view to be returned in response
        [Parameter(Mandatory = $false)]
        [switch]
        $Full
    )

    begin {
        #region Header
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"
        $headers = @{
            "Authorization" = "Bearer $script:token"
            "X-Tenant-ID"   = $script:TenantID
        }
        Write-Verbose "[BEGIN ] $headers"
        #endregion

        # Cache Hostname and DeviceIDs to search through later
        if ($PSBoundParameters.ContainsKey("computername")) {

            Write-Verbose "Hostname Parameter Specified"

            #region hashtable

            #Output parameters
            $PSBoundParameters.Keys | ForEach-Object {
                $message = 'Key: {0}, Value: {1}' -f $_, $PSBoundParameters[$_]
                Write-Verbose $message
            }

            [hashtable]$itemsHashtable = @{}

            try {

                $forEachObjectSplat = @{
                    Process = {
                        if ($itemsHashtable.Contains($Endpoint.ComputerName)) {

                            Write-Verbose "$($Endpoint.ComputerName) has a duplicate entry"

                        } else {

                            $itemsHashtable.Add( $Endpoint.ComputerName, $Endpoint.DeviceId )

                        } #if/else
                    } #process
                } #forEachObjectSplat

                Get-PSSophosCentralAllEndpoints -PipelineVariable Endpoint | ForEach-Object @forEachObjectSplat

            } catch {

                Throw $_.exception.message

            } #try/catch

            #endregion

        } #if

    } #begin

    process {
        #region Get EndpointID

        if ($PSBoundParameters.ContainsKey("computername")) {

            $endpointId = $itemsHashtable[$computername]

        } #if

        #endregion

        #region API request

        $url = "{0}/endpoint/v1/endpoints/{1}" -f $script:dataregion, $endpointId
        Write-Verbose "URI: [$url]"
        Write-Verbose "Dataregion [$($script:dataregion)]"

        try {

            Invoke-RestMethod -Uri $url -Method GET -Headers $headers

        }
        catch {

            write-error "Error with request: [$_]"

        } #try/catch

        #endregion

    } #process

    end {
        Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #function Get-PSSophosCentralEndpoint