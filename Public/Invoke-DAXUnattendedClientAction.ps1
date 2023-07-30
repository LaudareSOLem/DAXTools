function Invoke-DAXUnattendedClientAction {
    <#
    .SYNOPSIS
        Runs a client action defined in an autorun XML file passed to this function.

    .DESCRIPTION
        Runs a client action defined in an autorun XML file passed to this function. Accepts pipeline values as XML input. Try using it with New-DAXAutorunXML!

    .PARAMETER AutorunXML
        Duh

    .NOTES
        Tags: 
        Author: Sven Ontl
        
    .Example
        PS C:\> Invoke-DAXUnattendedClientAction -AutorunXML C:\folder\autorun.xml
    .Example
        PS C:\> New-DAXAutorunXML | Invoke-DAXUnattendedClientAction
#>


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({ $_ -like '*.xml' })]
        [string]$AutorunXML
    )

    begin {
        $AutorunAction = ((Get-Content $AutorunXML | Select-Object -Index 1).TrimStart("'    <")).TrimEnd("/>")

    }

    process {
        switch ($AutorunAction) {
            Synchronize { Write-Host "This is a snyc xml" }
            Default { Write-Error "This is not an AX32.exe autorun xml" }
        }
    }

    end {

    }

}

Invoke-DAXUnattendedClientAction -AutorunXML C:\ProgramData\DAXTools\workdir\DAXTools_autorun.xml