using module .\classes\JiraDateTime.psm1
using module .\classes\AtlassianContext.psm1
using module .\classes\PowerAtlassianGlobal.psm1
using module .\classes\RestMethod\RestQueryKvp.psm1
using module .\classes\RestMethod\RestMethodQueryParams.psm1
using module .\classes\RestMethod\RestMethodBody.psm1
using module .\classes\RestMethod\RestMethodJsonBody.psm1
using module .\classes\RestMethod\RestMethod.psm1
using module .\classes\RestMethod\BodyRestMethod.psm1
using module .\classes\RestMethod\FileRestMethod.psm1
using module .\classes\RestMethod\FormRestMethod.psm1

# grab classes and functions from files
$privateFiles = Get-ChildItem -Path $PSScriptRoot\private -Recurse -Include *.ps1 -ErrorAction SilentlyContinue
$publicFiles = Get-ChildItem -Path $PSScriptRoot\public -Recurse -Include *.ps1 -ErrorAction SilentlyContinue

if(@($privateFiles).Count -gt 0) { $privateFiles.FullName | ForEach-Object { . $_ } }
if(@($publicFiles).Count -gt 0) { $publicFiles.FullName | ForEach-Object { . $_ } }

#aliases
Set-Alias -Name "New-JiraContext" -Value "New-AtlassianContext" -Scope "Global"
Set-Alias -Name "New-ConfluenceContext" -Value "New-AtlassianContext" -Scope "Global"
Set-Alias -Name "Open-JiraSession" -Value "Open-AtlassianSession" -Scope "Global"
Set-Alias -Name "Open-ConfluenceSession" -Value "Open-AtlassianSession" -Scope "Global"
Set-Alias -Name "Close-JiraSession" -Value "Close-AtlassianSession" -Scope "Global"
Set-Alias -Name "Close-ConfluenceSession" -Value "Close-AtlassianSession" -Scope "Global"

Export-ModuleMember -Function $publicFiles.BaseName

if($null -eq $global:PowerAtlassian) {
	$global:PowerAtlassian = New-Object PowerAtlassianGlobal
}

$onRemove = {
	if ($global:PowerAtlassian) {
		Remove-Variable -Name PowerAtlassian -Scope global
	}
}

$ExecutionContext.SessionState.Module.OnRemove += $onRemove
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $onRemove