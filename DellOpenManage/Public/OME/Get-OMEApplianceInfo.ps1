
function Get-OMEApplianceInfo {
<#
Copyright (c) 2021 Dell EMC Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

<#
 .SYNOPSIS
   Get appliance info

 .DESCRIPTION
   This script uses the OME REST API.
   Note that the credentials entered are not stored to disk.
.PARAMETER Name
    String containing name to search by
 .EXAMPLE
   Get-OMEApplianceInfo | Format-Table

   List all account roles
 .EXAMPLE
   Get-OMEApplianceInfo | Format-Table

   Get appliance info
#>   

Begin {}
Process {
    if (!$(Confirm-IsAuthenticated)){
        Return
    }
    Try {
        if ($SessionAuth.IgnoreCertificateWarning) { Set-CertPolicy }
        $BaseUri = "https://$($SessionAuth.Host)"
        $Headers = @{}
        $ContentType = "application/json"
        $Headers."X-Auth-Token" = $SessionAuth.Token

        $ApplianceInfoUrl = $BaseUri + "/api/ApplicationService/Info"

        $ApplianceInfos = @()
        Write-Verbose $ApplianceInfoUrl
        $ApplianceInfoResponse = Invoke-WebRequest -Uri $ApplianceInfoUrl -UseBasicParsing -Method Get -Headers $Headers -ContentType $ContentType
        if ($ApplianceInfoResponse.StatusCode -in 200, 201) {
            $ApplianceInfoData = $ApplianceInfoResponse.Content | ConvertFrom-Json
            $ApplianceInfo = New-ApplianceInfoFromJsonn -ApplianceInfo $ApplianceInfoData
        }
    }
    Catch {
        Resolve-Error $_
    }

}

End {}

}