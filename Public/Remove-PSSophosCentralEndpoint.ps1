function Remove-PSSophosCentralEndpoint {
    <#
    .SYNOPSIS
    Removes a device from Sophos Central

    .DESCRIPTION
    Uses a REST API to remove a device from Sophos Central. This API accepts a list in JSON format.
    It calls the Get-PSSophosCentralEndpoint command to verify that the endpoint exists and to provide the hostname if you use the WhatIf switch parameter

    .EXAMPLE
    remove-PSSophosCentralEndpoint -endpointId 85536e48-b1e4-4a35-81ff-bc4cdca6eee7 -WhatIf -Verbose
    You can use the -WhatIf switch to check the hostname in the whatif output, in this example you will also get verbose output

    .EXAMPLE
    remove-PSSophosCentralEndpoint -endpointId 85536e48-b1e4-4a35-81ff-bc4cdca6eee7 -Confirm
    You can also use the -confirm switch to see the hostname in the confirmation prompt

    .NOTES
    Use with Caution
    Sophos Documentation for the API used: https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/delete/post
    #>

    [CmdletBinding(SupportsShouldProcess)]

    [OutputType([System.Void])]

    param (
        # The ID of the device in Sophos Central
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrWhiteSpace()]
        [string[]]
        [Alias("Id")]
        $EndpointId
    )

    begin {

        # Check that Endpoint exists


        #region begin
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"

        $headers = @{
            "Authorization" = "Bearer $script:token"
            "X-Tenant-ID"   = $script:TenantID
            "Accept"        = "application/json"
        }

        Write-Verbose "[BEGIN ] $headers"
        #endregion

    }

    process {
        foreach ($id in $EndpointId) {
            $url = "{0}/endpoint/v1/endpoints/{1}" -f $dataregion, $id
            Write-Verbose "URI: [$url]"

            # Check device name
            try {

                $device = Get-PSSophosCentralEndpoint -endpointid $id

                if ($pscmdlet.ShouldProcess($device.hostname, "Remove from Sophos Central")) {

                    Invoke-RestMethod -Uri $url -Method DELETE -Headers $headers

                } #if ShouldProcess

            }
            catch {

                Write-Error "Error with Device with id: $id does not exist"

            } #try/catch

        } #foreach

    } #process

    end {

    } #end

}  #Remove-PSSophosCentralEndpoint  function