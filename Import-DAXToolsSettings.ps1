$XMLFile = $PSScriptRoot + '\XML\DAXTools.xml'
$xml= [XML] (Get-Content $XMLFile)
$env:basedir = ($xml.DAXTools.BaseSettings.basedir)
$env:DynMgmtUtils = ($xml.DAXTools.BaseSettings.DynMgmtUtils)
$env:workdir = ($xml.DAXTools.BaseSettings.workdir)