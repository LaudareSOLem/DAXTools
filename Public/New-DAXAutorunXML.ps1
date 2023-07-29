function New-DAXAutorunXML {
    <#
    .SYNOPSIS
        Creates autorun.xml files for unattended client actions with ax32.exe

    .DESCRIPTION
        Creates autorun.xml files for unattended client actions with ax32.exe. The client action log file defined in the XML will be located in the defined workdir. Returns the created XML file.
    
    .PARAMETER AutorunAction
        The type of desired autorun action. Accepts 'CIL', 'FullDBSync' and 'ImportXPO'.

    .PARAMETER Path
        Target path for the created XML files. If not specified, it will be written to this modules workdir as defined in the 'begin' block of New-DAXAutorunXML.ps1

    .PARAMETER XPO
        Path to an XPO to import


    .NOTES
        Tags: CIL, Autorun, XML

    .Example
        PS C:\> New-DAXAutorunXML -AutorunAction CIL -Path c:\XMLFiles
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('CIL', 'FullDBSync', 'ImportXPO')]
        [string]$AutorunAction,

        [Parameter(Mandatory = $false)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$XPO

    )
    
    begin {

        $basedir = $env:programdata + '\DAXTools'
        $workdir = $env:Basedir + '\workdir'
        $XPO = "C:\temp\dummy.xpo"
        $XMLName = 'DAXTools_autorun.xml'
        $Line1Base = '<AxaptaAutoRun exitWhenDone="true" version="6.0" logFile="'
        $Line3 = '</AxaptaAutoRun>'
        $Timestamp = Get-Date -Format yyyy.MM.dd_HH.mm.ss
        if (!(Test-Path $workdir)) { new-item -Itemtype Directory -Path $env:Basedir -Name "workdir" -force }

    }    

    process {

        switch ($AutorunAction) {

            CIL {
                $Line1 = $Line1Base + $workdir + "\DAXTools_Autorun_CIL_" + $Timestamp + ".log" + '">'
                $LineCIL = '    <compileil/>'
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $Line1, $LineCIL, $Line3
            }

            FullDBSync {
                $Line1 = $Line1Base + $workdir + "\DAXTools_Autorun_FullDBSync_" + $Timestamp + ".log" + '">'
                $LineSync = '    <Synchronize/>'
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $Line1, $LineSync, $Line3
            }

            ImportXPO {
                $Line1 = '<ComingSoon>'
                $LineXPO = '    <Ipromise/>'
                $Line3XPO = '</ComingSoon>'
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $Line1, $LineXPO, $Line3XPO
            }
        }
    }

    end {
        return $XMLFile.FullName
    }
}
New-DAXAutorunXML -AutorunAction CIL -Path C:\_Backup_Alte_Festplatten\
#Export-ModuleMember -Function New-DAXAutorunXML