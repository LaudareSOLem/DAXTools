function Invoke-DAXFullCIL {
    <#
    .SYNOPSIS
        Starts ax32.exe with an autorun XML file to do a full CIL compilation in silent mode. 

    .DESCRIPTION
        Sets the AXModelStore to NoInstallMode, creates a CIL compilation autorun XML file and starts up ax32.exe to do a full unattended CIL compilation.
        Made with <3 by LaudareSOLem

    .PARAMETER WhatIf
        If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.

    .PARAMETER Confirm
        If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.

    .NOTES
        Tags: CIL, ax32.exe
        Author: Sven Ontl

    .Example
        PS C:\> IInvoke-DAXFullCIL

        Starts ax32.exe with an autorun XML file to do a full CIL compilation in silent mode.

    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    begin {

        $DMUps1 = 'C:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities\Microsoft.Dynamics.ManagementUtilities.ps1'
        $Today = (Get-Date -Format yyyy_MM_dd)
        $TodaysLogPath = "C:\ProgramData\DAXTools\Logs\" + $Today + '\Invoke-Invoke-DAXFullCIL\'

        $Timestamp = Get-Date -Format yyyy.MM.dd_HH.mm.ss
        $LogFile = $LogPath + 'Invoke-ANXCILCompilation_' + $Timestamp + '.log'
        if (!(Test-Path $TodaysLogPath)) { New-Item -ItemType Directory -Path $TodaysLogPath -force } 
 
        Start-Transcript $LogFile

        try {   
            Import-Module $DMUps1 -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Error "Microsoft.Dynamics.ManagementUtilities.ps1 not found." -Category ObjectNotFound
            return $false
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess(
            ("Starting full CIL compilation"),
            ("Would you like to start a full CIL compilation? This may take a while."),
                "Start full CIL compilation")
        ) {
            Set-AXModelStore -NoInstallMode | Out-Null
            New-ANXAutorunXML -XMLType CIL -Path $LogPath | Invoke-ANXUnattendedClientAction -Action CIL
        }
    }

    end {
        
    }

}
Export-ModuleMember -Function Invoke-ANXCILCompilation