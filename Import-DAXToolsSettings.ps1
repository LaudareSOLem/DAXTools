$XMLFile = $PSScriptRoot + '\XML\DAXTools.xml'
$xml= [XML] (Get-Content $XMLFile)
$xml
$env:Basedir = ($xml.DAXTools.BaseSettings.Basedir)
$env:DynMgmtUtils = ($xml.DAXTools.BaseSettings.DynMgmtUtils)