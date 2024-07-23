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
    [CmdletBinding(DefaultParameterSetName = "Basic")]
    [OutputType([PSCustomObject])]
    param (
        # The ID of the device in Sophos Central
        [Parameter(ParameterSetName = 'endpointId', Mandatory = $true)]
        [string]
        [Alias("Id")]
        $endpointId,

        [Parameter(ParameterSetName = 'computername', Mandatory = $true, ValueFromPipeline)]
        [string[]]
        [Alias("Hostname")]
        $computername,

        [Parameter(ParameterSetName = 'Full')]
        [Parameter(ParameterSetName = 'computername')]
        [Parameter(ParameterSetName = 'endpointId')]
        [switch]$Full,

        [Parameter(ParameterSetName = 'Summary')]
        [Parameter(ParameterSetName = 'computername')]
        [Parameter(ParameterSetName = 'endpointId')]
        [switch]$Summary,

        [Parameter(ParameterSetName = 'Basic')]
        [Parameter(ParameterSetName = 'computername')]
        [Parameter(ParameterSetName = 'endpointId')]
        [switch]$Basic
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
        }
        Write-Verbose "[BEGIN ] $headers"
        #endregion

        # Cache Hostname and DeviceIDs to search through later

        #region hashtable

        #Output parameters
        $PSBoundParameters.Keys | ForEach-Object {
            $message = 'Key: {0}, Value: {1}' -f $_, $PSBoundParameters[$_]
            Write-Verbose $message
        }

        if (-not $itemsHashtable) {

            [hashtable]$itemsHashtable = @{}

            try {

                Get-PSSophosCentralAllEndpoints -PipelineVariable Endpoint | ForEach-Object -Process {
                    if ($itemsHashtable.Contains($Endpoint.ComputerName)) {

                        Write-warning "$($Endpoint.ComputerName) has a duplicate entry"

                    }
                    else {

                        $itemsHashtable.Add( $Endpoint.ComputerName, $Endpoint)

                    } #if/else
                } #Get-PSSophosCentralAllEndpoints

            }
            catch {

                Throw $_.exception.message

            } #try/catch

        } #if

        #endregion

    } #begin

    process {
        Write-Verbose "[PROCESS] Starting: $($MyInvocation.Mycommand)"
        try {
            #region Get EndpointID

            if ($PSBoundParameters.ContainsKey("computername")) {

                write-verbose "Getting ID for [$computername]"
                $endpoint = $itemsHashtable[$computername]
                $endpointid = $endpoint.Deviceid
                Write-Verbose "endpoint id: [$endpointid]"

            } #if

            #endregion

            #region view

            Switch ($PSCmdlet.ParameterSetName) {
                "Full" { $query = "?view=full" }
                "Basic" { $query = "?view=Basic" }
                "Summary" { $query = "?view=Summary" }

            } #switch

            #endregion

            #region API request
            if ($endpointId -ne "") {

                $url = "{0}/endpoint/v1/endpoints/{1}" -f $script:dataregion, $endpointId

                # Add view query to the request if specified
                if ($query) {
                    $url = $url + $query
                } #if
                Write-Verbose "URI: [$url]"
                Write-Verbose "Dataregion [$($script:dataregion)]"

                $invokeRestMethodSplat = @{
                    Uri     = $url
                    Method  = 'GET'
                    Headers = $headers
                }

                Invoke-RestMethod @invokeRestMethodSplat

            }
            else {

                write-error "Cannot find an endpoint with name: $computername under: $script:dataregion"

            } #if/else

            #endregion
        }
        catch {

            write-error "Error with request: [$_]"
            $PSCmdlet.ThrowTerminatingError($PSItem)

        } #try/catch

    } #process

    end {
        Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #function Get-PSSophosCentralEndpoint