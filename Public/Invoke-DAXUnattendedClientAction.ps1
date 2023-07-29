function Invoke-AXUnattendedClientAction {
    <#
    .SYNOPSIS
        Runs unattended CIL compilations or database synchronisations
    .DESCRIPTION
        Starts ax32.exe with an autorun.xml file provided as a parameter to either invoke a full CIL compilation or database synchronisation.
        Accepts pipeline values, i.e. from New-AXAutorunXML.
        Returns the path to the respective log file.

    .PARAMETER XML
        Path to an ax32.exe autorun XML file.

    .PARAMETER Action
        Client action to be performed. Valid values for this parameter are 'CIL' or 'DBSync'

    .NOTES
        Tags: ax32.exe, XML, CIL, DBSync
        Author: Sven Ontl
        
    .Example
        PS C:\> Invoke-AXUnattendedClientAction -XML C:\autorun.xml -action CIL
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({ $_ -like '*.xml' })]
        [string]$XML,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateSet('CIL', 'DBSync')]
        [string]$Action
    )

    # Check if ax32.exe is installed

    $AXClient = get-command "ax32.exe" -ErrorAction SilentlyContinue
    if ($null -eq $AXClient) {
        Write-Host "##[error]ax32.exe not found." -Category NotInstalled
        return
    }
    $exe = "& '" + $AXClient.Source + "'"
    Write-Host "##[debug]XML: $XML"
    $Params = ' -lazyclassloading -lazytableloading -StartupCmd=Autorun_' + $XML + ' | Out-Null'
    $AXStartupExpression = $exe + $Params 

    Write-Host "##[debug]Starting up ax32.exe with autorun xml $XML"
    Invoke-Expression $AXStartupExpression

    # Return path of log file for error handling
    Write-Host "##[command]Check autorun log for errors"
    $LogPath = Get-Content $XML -TotalCount 1
    $LogPath = $Logpath.TrimStart('<AxaptaAutoRun exitWhenDone="true" version="5.0" logFile="')
    $LogPath = $LogPath.TrimEnd('">')
    Test-ANXAutoRunLog -Logfile $LogPath
    Remove-Item $XML
    return $LogPath
    
} # End function