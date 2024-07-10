function Get-PSSophosCentralAllEndpoints {
<#
.SYNOPSIS
Get all the endpoints for the specified tenant.

.DESCRIPTION
This could be used for caching data to be able to search an array or list for a device Id and Hostname.
Returns a PSCustomobject of some of the properties from Sophos Central Endpoints

.EXAMPLE
$AllEndpoints = Get-PSSophosCentralAllEndpoints -Verbose
$AllEndpoints |Where-Object -FilterScript {$_.deviceid -eq 'fe5e0ec6-1e32-4680-a36e-f66683b6a2e5'}
An example

.NOTES
General notes
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (

    )

    process {
        $headers = @{
            "Authorization" = "Bearer $script:token"
            "X-Tenant-ID"   = $script:TenantID
        }
        $url = "{0}/endpoint/v1/endpoints?pageSize=500&pageTotal=true&view=summary" -f $script:dataregion
        $epresponse = Invoke-RestMethod -Uri $url -Method Get -Headers $headers

        $json = $epresponse | ConvertTo-Json

        #Convert to an object
        $object = ConvertFrom-Json -InputObject $json

        #The Items node contains all the device info
        $object.items | ForEach-Object {
            [PSCustomObject]@{
                ComputerName = $_.hostname
                health = $_.health
                lastSeenAt = $_.lastSeenAt
                OperatingSystem = $_.os
                tamperProtectionEnabled =$_.tamperProtectionEnabled
                type = $_.type
                group = $_.group
                Deviceid = $_.id
            } #PSCustomObject
        } #ForEach-Object


    } #process

} #function Get-PSSophosCentralAllEndpoints



