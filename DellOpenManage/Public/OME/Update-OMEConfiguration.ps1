﻿using module ..\..\Classes\Group.psm1
using module ..\..\Classes\Device.psm1
using module ..\..\Classes\ConfigurationBaseline.psm1



function Get-ConfigurationPayload($Name, $TemplateId, $TargetPayload, $RebootType) {
    $Payload = '{
        "JobName": "Make Devices Compliant",
        "JobDescription": "Make the selected devices compliant with template",
        "Schedule": "startnow",
        "State": "Enabled",
        "Targets": [
            {
                "Id": 10072,
                "Data": "37KP0Q2",
                "TargetType": {
                    "Id": 1000,
                    "Name": "DEVICE"
                }
            }
        ],
        "Params": [
            {
                "Key": "jobName",
                "Value": "Make Devices Compliant"
            },
            {
                "Key": "jobDesc",
                "Value": "Make the selected devices compliant with template"
            },
            {
                "Key": "schemaId",
                "Value": "34"
            },
            {
                "Key": "templateId",
                "Value": "34"
            },
            {
                "Key": "HAS_IO_POOL",
                "Value": "false"
            },
            {
                "Key": "fileName",
                "Value": "DEPLOY_CONFIG_34.xml"
            },
            {
                "Key": "action",
                "Value": "SERVER_DEPLOY_CONFIG"
            },
            {
                "Key": "shutdownType",
                "Value": "0"
            },
            {
                "Key": "timeToWait",
                "Value": "300"
            },
            {
                "Key": "endHostPowerState",
                "Value": "1"
            },
            {
                "Key": "strictCheckingVlan",
                "Value": "false"
            }
        ],
        "JobType": {
            "@odata.type": "#JobService.JobType",
            "Id": 50,
            "Name": "Device_Config_Task",
            "Internal": false
        }
    }' | ConvertFrom-Json

    $ParamsHashValMap = @{
        "jobName" = [string]$Name
        "schemaId" = [string]$TemplateId
        "templateId" = [string]$TemplateId
        "shutdownType" = [string]$RebootType
    }

    for ($i = 0; $i -le $Payload.'Params'.Length; $i++) {
        if ($ParamsHashValMap.Keys -Contains ($Payload.'Params'[$i].'Key')) {
            $value = $Payload.'Params'[$i].'Key'
            $Payload.'Params'[$i].'Value' = $ParamsHashValMap.$value
        }
    }
    $Payload.Targets = $TargetPayload
    $Payload.JobName = $Name
    return $payload
}

function Update-OMEConfiguration {
<#
Copyright (c) 2018 Dell EMC Corporation

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
    Update configuration on devices in OpenManage Enterprise
.DESCRIPTION
    This will use an existing configuration baseline to submit a Job that updates configuration on a set of devices immediately. ***This will force a reboot if necessary***
.PARAMETER Name
    Name of the configuration update job
.PARAMETER Baseline
    Array of type ConfigurationBaseline returned from Get-OMEConfigurationBaseline function
.PARAMETER DeviceFilter
    Array of type Device returned from Get-OMEDevice function. Used to limit the devices updated within the baseline.
.PARAMETER UpdateSchedule
    Determines when the updates will be performed. (Default="RebootNow", "StageForNextReboot")
.PARAMETER Wait
    Wait for job to complete
.PARAMETER WaitTime
    Time, in seconds, to wait for the job to complete
.INPUTS
    None
.EXAMPLE
    Update-OMEConfiguration -Name "Make Compliant Test01" -Baseline $("TestBaseline01" | Get-OMEConfigurationBaseline) -Wait -Verbose

    Update configuration compliance on all devices in baseline ***This will force a reboot if necessary***
.EXAMPLE
    Update-OMEConfiguration -Name "Make Compliant Test01" -Baseline $("TestBaseline01" | Get-OMEConfigurationBaseline) -DeviceFilter $("C86CZZZ" | Get-OMEDevice -FilterBy "ServiceTag") -Wait -Verbose
    
    Update configuration compliance on filtered devices in baseline ***This will force a reboot if necessary***
.EXAMPLE
    Update-OMEConfiguration -Name "Make Compliant Test01" -Baseline $("TestBaseline01" | Get-OMEConfigurationBaseline) -DeviceFilter $("C86CZZZ" | Get-OMEDevice -FilterBy "ServiceTag") -UpdateSchedule "StageForNextReboot" -Wait -Verbose
    
    Update configuration compliance on filtered devices in baseline staging changes for next reboot
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [String]$Name = "Make Devices Compliant $((Get-Date).ToString('yyyyMMddHHmmss'))",

    [Parameter(Mandatory=$false)]
    [Device[]]$DeviceFilter,

    [Parameter(Mandatory)]
    [ConfigurationBaseline]$Baseline,

    [Parameter(Mandatory=$false)]
    [ValidateSet("RebootNow", "StageForNextReboot")]
    [String]$UpdateSchedule = "RebootNow",

    [Parameter(Mandatory=$false)]
    [Switch]$Wait,

    [Parameter(Mandatory=$false)]
    [int]$WaitTime = 3600
)

Begin {}
Process {
    if (!$(Confirm-IsAuthenticated)){
        Return
    }
    Try {
        if ($SessionAuth.IgnoreCertificateWarning) { Set-CertPolicy }
        $BaseUri = "https://$($SessionAuth.Host)"
        $Type  = "application/json"
        $Headers = @{}
        $Headers."X-Auth-Token" = $SessionAuth.Token

        $RebootTypeMap = @{
            "RebootNow" = 0;
            "ScheduleLater" = 1;
            "StageForNextReboot" = 2;
        }
        $TemplateId = $Baseline.TemplateId
        if ($Baseline.Targets.Length -gt 0) {
            $ComplianceReportList = Get-OMEConfigurationCompliance -Baseline $Baseline -DeviceFilter $DeviceFilter
            $DeviceList = @()
            if ($ComplianceReportList.Length -gt 0) {
                # Build list of device ids that are not compliant with the baseline
                foreach ($ComplianceDevice in $ComplianceReportList) {
                    if ($ComplianceDevice.ComplianceStatus -eq "Not Compliant") {
                        $DeviceList += $ComplianceDevice.Id
                    }
                }
            }
            if ($DeviceList.Length -gt 0) {
                $TargetPayload = Get-JobTargetPayload $DeviceList
                $UpdatePayload = Get-ConfigurationPayload -Name $Name -TemplateId $TemplateId -TargetPayload $TargetPayload -RebootType $RebootTypeMap[$UpdateSchedule]
                # Update configuration
                $UpdateJobURL = $BaseUri + "/api/JobService/Jobs"
                $UpdatePayload = $UpdatePayload | ConvertTo-Json -Depth 6
                Write-Verbose $UpdatePayload
                $JobResp = Invoke-WebRequest -Uri $UpdateJobURL -UseBasicParsing -Headers $Headers -ContentType $Type -Method POST -Body $UpdatePayload
                if ($JobResp.StatusCode -eq 201) {
                    Write-Verbose "Update job creation successful"
                    $JobInfo = $JobResp.Content | ConvertFrom-Json
                    $JobId = $JobInfo.Id
                    Write-Verbose "Created job $($JobId) to update configuration..."
                    if ($Wait) {
                        $JobStatus = $($JobId | Wait-OnJob -WaitTime $WaitTime)
                        return $JobStatus
                    } else {
                        return $JobId
                    }
                }
                else {
                    Write-Error "Update job creation failed"
                }
            } else {
                Write-Warning "All devices compliant with baseline"
                return "Completed"
            }
        }
        else {
            Write-Warning "No devices to make compliant"
        }
    }
    Catch {
        Resolve-Error $_
    }
}

End {}

}

