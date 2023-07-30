function Invoke-DAXUnattendedClientAction {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER 

    .NOTES
        Tags: 
        Author: Sven Ontl
        
    .Example
        PS C:\> Invoke-DAXUnattendedClientAction
#>


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({ $_ -like '*.xml' })]
        [string]$AutorunXML
    )

    begin{
        #$AutorunXMLContent = $xml= [XML] (Get-Content $AutorunXML)
        $AutorunAction = ((Get-Content $AutorunXML | Select-Object -Index 1).TrimStart("'    <")).TrimEnd("/>")

    }

    process{
        switch ($AutorunAction) {
            Synchronize { Write-Host "This is a snyc xml"  }
            Default { Write-Error "This is not an AX32.exe autorun xml"}
        }
    }

    end{

    }

}

Invoke-DAXUnattendedClientAction -AutorunXML C:\ProgramData\DAXTools\workdir\DAXTools_autorun.xml