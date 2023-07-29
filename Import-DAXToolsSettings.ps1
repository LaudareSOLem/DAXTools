$xml = [XML](Get-Content (($PSScriptRoot).FullName + '\XML\DAXTools.xml'))
$env:Basedir = ($xml.DAXTools.BaseSettings.Basedir)
$env:DynMgmtUtils = ($xml.DAXTools.BaseSettings.DynMgmtUtils)