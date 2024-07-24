function Get-PSSophosCentralAllEndpoints {
    <#
.SYNOPSIS
Get all the endpoints for the specified tenant.

.DESCRIPTION
This could be used for caching data to be able to search an array or list for a device Id and Hostname.
Returns a PSCustomobject of some of the properties from Sophos Central Endpoints

.EXAMPLE
Get-PSSophosCentralAllEndpoints -PipelineVariable Endpoint | ForEach-Object -Process {
    if ($itemsHashtable.Contains($Endpoint.ComputerName)) {

        Write-warning "$($Endpoint.ComputerName) has a duplicate entry"

    }
    else {

        $itemsHashtable.Add( $Endpoint.ComputerName, $Endpoint)

    } #if/else
} #Get-PSSophosCentralAllEndpoints
Using this command to cache endpoint data

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
        $url = "{0}/endpoint/v1/endpoints?pageSize=500&pageTotal=true&view=summary" -f $dataregion
        $epresponse = Invoke-RestMethod -Uri $url -Method Get -Headers $headers

        #The Items node contains all the device info
        $epresponse.items | ForEach-Object {
            [PSCustomObject]@{
                ComputerName            = $_.hostname
                health                  = $_.health.overall
                lastSeenAt              = $_.lastSeenAt
                OperatingSystem         = $_.os.name
                tamperProtectionEnabled = $_.tamperProtectionEnabled
                type                    = $_.type
                group                   = $_.group.name
                Deviceid                = $_.id
            } #PSCustomObject
        } #ForEach-Object


    } #process

} #function Get-PSSophosCentralAllEndpoints



