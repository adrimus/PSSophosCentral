function Remove-PSSophosCentralEndpoint {
    <#
    .SYNOPSIS
    Removes a device from Sophos Central
    
    .DESCRIPTION
    Uses a REST API to remove a device from Sophos Central. This API accepts a list in JSON format. 
    
    .EXAMPLE
    An example
    
    .NOTES
    Sophos Documentation for the API used: https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/delete/post
    #>

    [CmdletBinding(SupportsShouldProcess)]

    [OutputType([System.Void])]

    param (
        # Data region to be included in the URI of thhe HTTPS request
        [Parameter(Mandatory = $true)]
        [string]
        $dataregion,

        # TenantID for the header
        [Parameter(Mandatory = $true)]
        [string]
        $tenantID,

        # Parameter help description
        [Parameter(mandatory = $true)]
        [string]
        $token,

        # The ID of the device in Sophos Central
        [Parameter(Mandatory = $true)]
        [string]
        [Alias("DeviceId")]
        $endpointId  
    )
    
    begin {

        #region begin
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"

        $headers = @{
            "Authorization" = "Bearer $token"
            "X-Tenant-ID"   = $TenantID
            "Accept"        = "application/json"
        }

        Write-Verbose "[BEGIN ] $headers"
        #endregion
        
    }
    
    process {
        $url = "{0}/endpoint/v1/endpoints/{1}" -f $dataregion, $endpointId
        Write-Verbose "URI: [$url]"

        #Check device name
        Get-PSSophosCentralEndpoint

        if ($pscmdlet.ShouldProcess($endpointId, "Remove from Sophos Central")) {

            try {
                Invoke-RestMethod -Uri $url -Method DELETE -Headers $headers
            }
            catch {
                write-error "Error with request: [$_]"
            } #try/catch

            $message = "This is a message"
            Write-Verbose "[PROCESS] Text:  [$Message]"

        } #if ShouldProcess

    } #process
    
    end {
        
    } #end
}  #Remove-PSSophosCentralEndpoint  function 