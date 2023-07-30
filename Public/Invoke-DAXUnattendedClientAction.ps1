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
        This command will start AX32.exe in silent mode and perform the action defined in the provided autorun.xml. AX32.exe will terminate after the compilation is finished and write all output to the logfile defined in autorun.xml
    .Example
        PS C:\> New-DAXAutorunXML -AutorunAction CIL | Invoke-DAXUnattendedClientAction
        This command will run a full CIL compilation in silent mode and terminate AX32.exe after its finished.

    .Link
        For more information, visit https://github.com/LaudareSOLem/DAXTools/wiki/Command-index#invoke-daxunattendedclientaction
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