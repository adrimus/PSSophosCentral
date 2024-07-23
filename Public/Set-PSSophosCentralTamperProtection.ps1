function Set-PSSophosCentralTamperProtection {
    <#
    .SYNOPSIS
    Uses the Sophos API for endpoints to set tamper protection on or off

    .DESCRIPTION
    Long description

    .PARAMETER dataregion
    Data region to be included in the URI of thhe HTTPS request,

    .PARAMETER tenantID
    Used for authentication and in the request headers

    .PARAMETER token
    Needed for authorization

    .PARAMETER id
    Device ID for a specific endpoint (Computer)

    .PARAMETER enable
    Boolean value to enable or disabletamper protection

    .EXAMPLE
    Set-PSSophosCentralTamperProtection -dataregion $dataregion -tenantID $TenantId -token $token -enable:$false -id '8e72b84b-20df-4603-ba05-fba3a9fe27b8'

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (

        # Endpoint ID
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        [Alias("Id")]
        $endpointId,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [bool]
        [alias("Enable")]
        $IsEnabled
    )

    begin {
        #region begin
        Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"

        $headers = @{
            "Authorization" = "Bearer $token"
            "X-Tenant-ID"   = $TenantID
            "Accept"        = "application/json"
        }

        $body = @{ "enabled" = $enable } | ConvertTo-Json

        Write-Verbose "[BEGIN ] $headers"
        Write-Verbose "[BEGIN ] $body"
        #endregion
    } #begin

    process {
        #region process
        foreach ($Id in $endpointId) {

            $url = "$dataregion/endpoint/v1/endpoints/$Id/tamper-protection"
            Write-Verbose "[PROCESS] URL [$url]"

            # set message to display in the what if message
            switch ($enable) {
                $false { $operation = "Disabling tamper protection" }
                default { $operation = "Enabling tamper protection" }
            } #switch

            # Check device name
            try {

                $device = Get-PSSophosCentralEndpoint -endpointid $Id

            }
            catch {

                Throw $_.exception.message

            } #try/catch

            if ($pscmdlet.ShouldProcess($device.hostname, $operation)) {

                $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ContentType "application/json"
                Write-Verbose "[PROCESS] response:  [$response]"
                $response

            } #if
        }
        #endregion
    } #process

    end {

        Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"

    } #end
} #Set-PSSophosCentralTamperProtection function