
function New-DAXAutorunXML {
    <#
    .SYNOPSIS
        Creates autorun.xml files for unattended client actions with ax32.exe

    .DESCRIPTION
        Creates autorun.xml files for unattended client actions with ax32.exe. The client actions log file inside the XML will be set to this modules workdir as defined in XML/DAXTools.xml. Returns the created XML files FullName.
    
    .PARAMETER AutorunAction
        The type of desired autorun action. Accepts 'CIL', 'FullDBSync' and 'ImportXPO'.

    .PARAMETER Path
        Target path for the created XML files. If not specified, it will be written to this modules workdir as defined in XML/DAXTools.xml

    .PARAMETER XPO
        FullName of the XPO to import

    .NOTES
        Tags: CIL, Autorun, XML

    .Example
        PS C:\> New-DAXAutorunXML -AutorunAction CIL -Path c:\XMLFiles

    .Link
        For more information, visit https://github.com/LaudareSOLem/DAXTools/wiki/Command-index
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('CIL', 'FullDBSync', 'ImportXPO', 'Test')]
        [string]$AutorunAction,
        [Parameter(Mandatory = $false)]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [string]$XPO

    )
    
    begin {

        $workdir = $env:Basedir + 'workdir'
        $XMLName = 'DAXTools_AX32autorun_' + $AutorunAction + '.xml'
        $Timestamp = Get-Date -Format yyyy.MM.dd_HH.mm.ss
        $XMLLine1 = '<AxaptaAutoRun exitWhenDone="true" version="6.0" logFile="' + $workdir + "\DAXTools_" + $AutorunAction + '_' + $Timestamp + ".log" + '">'    
        $XMLLine2CIL = '    <compileil/>'
        $XMLLine2Sync = '    <Synchronize/>'
        $XMLLine2XPO = '    <XpoImport file="' + $XPO + '" />'
        $XMLLine3XPO = '    <Run type="class" name="CreateClass" method="main" />'
        $XMLLine2Test = '    <Test/>'
        $XMLLineEnd = '</AxaptaAutoRun>'
                
        if (!(Test-Path $workdir)) { New-Item -Itemtype Directory -Path $env:Basedir -Name "workdir" -force }

    }    

    process {

        switch ($AutorunAction) {

            CIL {               
                $XMLcontent = @(
                    $XMLLine1,
                    $XMLLine2CIL,
                    $XMLLineEnd
                )
                
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $XMLcontent
            }

            FullDBSync {
                $XMLcontent = @(
                    $XMLLine1,
                    $XMLLine2Sync,
                    $XMLLineEnd
                )
                
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $XMLcontent
            }

            ImportXPO {
                if (!($XPO)) {
                    Write-Error "Please provide an XPO file" -Category SyntaxError
                    return $false
                }

                $XMLcontent = @(
                    $XMLLine1,
                    $XMLLine2XPO,
                    $XMLLine3XPO,
                    $XMLLineEnd
                )
                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $XMLcontent
            }

            Test {                              
                $XMLcontent = @(
                    $XMLLine1,
                    $XMLLine2Test,
                    $XMLLineEnd
                )

                $XMLFile = New-Item -Path $workdir -Name $XMLName -ItemType File -Force
                Add-Content $XMLFile.FullName -Value $XMLcontent
            }
        }
    }

    end {

        if (Test-Path $XMLFile) {
            return $XMLFile.FullName
        }
        else {
            Write-Error "Something went wrong." -Category NotSpecified
            return $false
        }
    }
}
#Export-ModuleMember -Function New-DAXAutorunXML

New-DAXAutorunXML -AutorunAction CIL

