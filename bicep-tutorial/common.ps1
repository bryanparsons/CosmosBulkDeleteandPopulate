Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}

$global:ResourceGroup="RG-BICEP-DEMO-001"
$Global:Location="uksouth"
$Global:TagDepartment="finance"
$Global:TagCostCenter="cost 123"
$Global:TagOwner="janedoe@cool.com"

$Global:environment="dev"

$Global:TagsArray = @( `
    "Cost center=$Global:TagCostCenter",`
    "Business Department=$Global:TagDepartment")