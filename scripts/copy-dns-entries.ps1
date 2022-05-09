[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string] $SourceSubscription,
    [Parameter(Mandatory)] [string] $SourceSharedRG,
    [Parameter(Mandatory)] [string] $TargetSubscription,
    [Parameter(Mandatory)] [string] $TargetRG,
    [Parameter(Mandatory)] [string[]] $PrivateDNSZoneNames
)

$sourceSubscription = $SourceSubscription
$targetSubscription = $TargetSubscription
$sourceSharedRG     = $SourceSharedRG
$privateDNSZoneNames = $PrivateDNSZoneNames
$targetRG           = $TargetRG

$azureAppId = $env:servicePrincipalId
$azureAppIdPassword = $env:servicePrincipalKey
$azureAppIdPassword = ConvertTo-SecureString -String $azureAppIdPassword -AsPlainText -Force
$azureAppCred = (New-Object System.Management.Automation.PSCredential -ArgumentList $azureAppId, $azureAppIdPassword)
$subscriptionId = $sourceSubscription
$tenantId = $env:tenantId

Connect-AzAccount -ServicePrincipal -SubscriptionId $subscriptionId -TenantId $tenantId -Credential $azureAppCred

foreach($privateDNSZoneName in $privateDNSZoneNames)
{

    Write-Host ("Setting current Subscription to $($sourceSubscription)")
    Set-AzContext -Subscription $sourceSubscription
    Write-Host ("Reading DNS records from $($privateDNSZoneName)")
    $dnsRecords = (Get-AzPrivateDnsRecordSet -ResourceGroupName $sourceSharedRG -ZoneName $privateDNSZoneName -RecordType A) | Select-Object -Property Name, Ttl, Records

    Write-Host ("Setting current Subscription to $($targetSubscription)")
    Set-AzContext -Subscription $targetSubscription

    foreach($record in $dnsRecords)
    {
        $recordSet = Get-AzPrivateDnsRecordSet -ResourceGroupName $targetRG -ZoneName $privateDNSZoneName -RecordType A -Name $record.Name -ErrorAction SilentlyContinue
        
        if($null -eq $recordSet)
        {
            Write-Host("Adding DNS record for $($record.Name) in $($PrivateDNSZoneName)")
            New-AzPrivateDnsRecordSet -Name $record.Name -RecordType A -ResourceGroupName $targetRG -TTL 3600 -ZoneName $privateDNSZoneName -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address $record.Records[0])
        }
        else {
            Write-Host "Record Already Exists for $($record.Name)"
            if($recordSet.Records[0].ToString() -eq $record.Records[0].ToString())
            {
                Write-Host "Same IP config no update required for $($record.Name)"
            }
            else {
                Write-Host "Updating IP config for $($record.Name)"
                New-AzPrivateDnsRecordSet -Name $record.Name -RecordType A -ResourceGroupName $targetRG -TTL 3600 -ZoneName $privateDNSZoneName -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address $record.Records[0]) -Confirm:$False -Overwrite
            }
        }
    }
}