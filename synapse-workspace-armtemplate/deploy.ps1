$ErrorActionPreference="Stop"
Set-StrictMode -Version "latest"
Clear-Host


$ResourceGroup="rg-junk-synapsedeployment-using-arm-and-powershell"
$ResourceGroupManaged="rg-junk-synapsedeployment-using-arm-and-powershell-managed"
$Location="uksouth"
$StorageAccountName="junksynapsefromwrkstn"
$FileSystemName="junkfilesystemwrkstn"
$armFile=Join-Path -Path $PSScriptRoot -ChildPath ".\arm.json"
$currentSubscriptionid=(Get-AzContext).Subscription.Id
$sqlAdminUser="johndoe"
$sqlPassWord="Pass@word123"
$currentUserId="a4e9c07e-6f7e-4c5c-a10c-a1cca1800774"
#(Get-azContext).Account.id #Should use this

New-AzResourceGroup -Location $Location -Name $ResourceGroup -Force

$armParameters=@{ 
    "name"="armsynapse001fromwrkstn" ; 
    "location"=$Location ;
    "defaultDataLakeStorageAccountName"=$StorageAccountName ;
    "defaultDataLakeStorageFilesystemName"=$FileSystemName ;
    "sqlAdministratorLogin"=$sqlAdminUser ;
    "sqlAdministratorLoginPassword"=$sqlPassWord ;
    "setWorkspaceIdentityRbacOnStorageAccount"=$true ;
    "createManagedPrivateEndpoint"=$false ;
    "defaultAdlsGen2AccountResourceId"="/subscriptions/$currentSubscriptionid/resourceGroups/$ResourceGroup/providers/Microsoft.Storage/storageAccounts/$StorageAccountName" ;
    "allowAllConnections"=$true ;
    "managedVirtualNetwork"="" ;
    "tagValues"=@{} ;
    "storageSubscriptionID"="$currentSubscriptionid" ;
    "storageResourceGroupName"="$ResourceGroup" ;
    "storageLocation"="$Location" ;
    "storageRoleUniqueId"=[System.Guid]::NewGuid().ToString() ;
    "isNewStorageAccount"=$true ;
    "isNewFileSystemOnly"=$false ;
    "adlaResourceId"="" ;
    "managedResourceGroupName"="$ResourceGroupManaged" ;
    "storageAccessTier"="Hot" ;
    "storageAccountType"="Standard_RAGRS" ;
    "storageSupportsHttpsTrafficOnly"=$true ;
    "storageKind"="StorageV2" ;
    "minimumTlsVersion"="TLS1_2" ;
    "storageIsHnsEnabled"=$true ;
    "userObjectId"=$currentUserId ;
    "setSbdcRbacOnStorageAccount"=$true ;
    "setWorkspaceMsiByPassOnStorageAccount"=$false ;
    "workspaceStorageAccountProperties"=@{} ;
}
Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters

$deploymentName=("mysynapsedeployment-{0}" -f (Get-Date).Ticks)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters -Name $deploymentName -Verbose
Write-Host "Deployment complete"