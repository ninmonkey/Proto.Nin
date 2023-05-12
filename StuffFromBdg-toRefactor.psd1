using namespace System.Collections.Generic
# "`n`n#### -> Enter BDG_lib"
$PSDefaultParameterValues['Connect-JCOnline:Verbose'] = $true
$PSDefaultParameterValues['Set-JCOrganization:Verbose'] = $true
$PSDefaultParameterValues['Get-JCType:Verbose'] = $true
$PSDefaultParameterValues['Get-JCObject:Verbose'] = $true
$PSDefaultParameterValues['Invoke-JCApi:Verbose'] = $true
$PSDefaultParameterValues['*-JC*Api:Verbose'] = $true

. (Join-Path $PSScriptRoot 'mapping.ps1')

$_manualStaticPath = 'C:\Users\cppmo_000\SkyDrive\Documents\2022\client_BDG\self\output'

foreach ($c in $cmds) {
    $PSDefaultParameterValues["${c}:Verbose"] = $true
    $global:PSDefaultParameterValues["${c}:Verbose"] = $true
}


enum SemState {
    Basic # bluels
    NormalFg# nothing
    BrightFg
    Warn
    Critical
    Bad
    Good
}


function formatBlankText {
    <#
            .SYNOPSIS
                remplace empty str and nulls with symbols
            .DESCRIPTION
                "`u{2420}" = '␠'
                $null = '␀'
                empty array
                '@(␀)' ?
            #>
    [OutputType('System.String', 'System.Object')]
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(ValueFromPipeline)]$InputObject,

        [switch]$NoRecurse
    )
    if ($null -eq $InputObject) {
        return '[␀]'
    }
    if ($InputObject -is 'array' -and $InputObject.count -eq 0) {
        return '[empty[]]'
        return '[ @() ]'
        return '@(␀)'
    }
    if ($InputObject -is 'String') {
        if ($InputObject.Length -eq 0) {
            return '[␠]'
        }
        if ( [string]::IsNullOrWhiteSpace( $InputObject )) {
            return '[blank ␠]'
        }
    }
    # pass thru if conditions are false
    # or maybe recurse with InputObject.ToString()
    if ( $NoRecurse) {
        return $InputObject
    }
    [string]$implicitText = ($InputObject)?.ToString() ?? ''
    [string]$fromImplicit = formatBlankText $implicitText -NoRecurse
    return $fromImplicit
    #  if( [string]::IsNullOrWhiteSpace( $ImplicitText ) )  {
    #  }

    #  return $inputObject
}

function formatCallStack {
    <#
    .notes
        a way to execute in correct current scope, not self?
        or, super easy, just drop the final frames to do that

    .notes
        warning: NYI
    .EXAMPLE
        PS> Get-PSCallStack | formatCallStack
            Get-PSCallStack | formatCallStack FuncName
            formatCallStack -InputObject (Get-PSCallStack)
            formatCallStack -InputObject (Get-PSCallStack) FuncName
    .EXAMPLE
        PS> formatCallStack FuncName
            formatCallStack
    .link
        GetClrCallStack\Get-ClrCallStack
    .link
        Microsoft.PowerShell.Utility\Get-PSCallStack
    #>
    [CmdletBinding()]
    [OutputType('System.Text', 'Management.Automation.CallStackFrame')]
    param(
        # PassThru returns objects, all other modes are text
        [ValidateSet('FuncNameCrumbs', 'PassThru')]
        [string]$FormatMode = 'FuncNameCrumbs',

        [Alias('CallStackFrames')]
        [Parameter(ValueFromPipeline)]
        [Management.Automation.CallStackFrame[]]$InputObject
    )

    begin {
        [list[Management.Automation.CallStackFrame]]$items = @()
    }
    process {
        foreach ($x in $InputObject) { $items.Add( $x) }
    }
    end {
        if ( $inputObject.Count -le 0 ) {
            Write-Debug 'input failed, fallback to invoke Get-PSCallStack'
            [list[object]]$cStack = [list[object]]@(
                Microsoft.PowerShell.Utility\Get-PSCallStack
            )
        }
        $cStack ??= [list[object]]@(
            Microsoft.PowerShell.Utility\Get-PSCallStack
        )

        # [list[object]]$cStack = @($InputObject ?? (Get-PSCallStack))
        switch ($FormatMode) {
            'FuncNameCrumbs' {
                # left to right
                $cStack.Reverse()
                $cStack | Join-String -sep ' 🠞 ' { $_.FUnctionName }
            }
            'PassThru' { return $cStack }

            default {
                #none?
                return $cStack
            }
        }
    }

    # $call | at 1 | s *
    # [list[object]]$info = $call
    # $info.Reverse()
    # $info  | Join-String -sep ' 🠞 ' { $_.FUnctionName }


}

function _getContent {
    <#
    .synopsis
        sugar to quickly read exports
    .LINK
        BDG_Lib\_getContent
    .LINK
        BDG_Lib\_setContent
    #>
    param(            # name is used for filepath
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,

        # Root if not automatic
        [Parameter()]
        [string]$ExportPath = $AppConf.ExportPrefix ?? $_manualStaticPath
    )

    $RootExportDir = Get-Item $_manualStaticPath
    $FilePath = (Join-Path $RootExportDir $Name)
    if (!(Test-Path)) {
        Write-Error -ea continue "Path missing! '$FilePath' "
        return
    }
}

function _setContent {
    <#
    .synopsis
        sugar to quickly pipe exports, using JSON and/or CSV
    .EXAMPLe
        get-date
        | _setContent -ExportPath Temp -Name 'datetime' -Both
    .LINK
        BDG_Lib\_getContent
    .LINK
        BDG_Lib\_setContent
    #>
    param(
        # any content
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # name is used for filepath
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,

        # Root if not automatic
        [Parameter()]
        [ArgumentCompletions('Cache', 'Prefix', 'Temp')]
        [string]$ExportPath = $AppConf.ExportPrefix ?? $_manualStaticPath,

        [Alias('JsonAndCsv')]
        [switch]$Both
    )
    begin {

        Write-Warning '_getContent() needs the new argument completions "$ExportPath" mapping logic as well'

        if ($ExportPath -in @('Cache', 'Prefix', 'Temp')) {
            $ExportPath = switch ($ExportPath) {
                'Cache' {
                    $AppConf.ExportCache
                }
                'Prefix' {
                    $AppConf.ExportPrefix
                }
                'Temp' {
                    $AppConf.ExportTemp
                }
                default {
                    $ExportPath
                }
            }
            Write-Debug "ExportPath is now: '$ExportPath'"
        }
        $items = [list[object]]::new()
        $RootExportDir = Get-Item $ExportPath
    }
    process {
        $items.AddRange( $InputObject )
    }
    end {
        $DestName = Join-Path $RootExportDir $Name

        $destPath = @{
            Path = $DestName
        }
        if ( -not $Both ) {

            $items | Set-Content @destPath
            return


        }
        $dest_json = $destPath.Path + '.json'
        $dest_csv = $destPath.Path + '.csv'

        $Items | ConvertTo-Json
        | Set-Content -Path $dest_json
        'wrote: "{0}"' -f ($dest_json) | Write-Verbose

        $Items | ConvertTo-Csv
        | Set-Content -Path $dest_csv
        'wrote: "{0}"' -f ($dest_csv) | Write-Verbose

    }

}


bdgLog "`n"
(Get-Date).ToShortTimeString()
| bdgLog -Category ModuleEvent ('[{1}]--> enter {0}' -f @(
        $PSCommandPath | Get-Item | ForEach-Object Name
        $PID
    )
)

function Write-WhatScriptAmI {
    <#
    .synopsis
        really simple sugar for printing $PSCommandPath pathname
    #>
    param( $PSCommandPathRef )

    $PSCommandPathRef ??= $PSCommandPath
    $PSCommandPathRef | Split-Path -Leaf | bdgLog (Label 'current file' -fg magenta -bg gray70)
}
Export-ModuleMember -Function @(
    # new
    'formatBlankText'

    # older
    'Write-WhatScriptAmI'
    '_setContent'
    '_getContent'
    # new
    # 'mergeHash'
)

(Get-Date).ToShortTimeString()
| bdgLog -Category ModuleEvent '--> enter {Always_first'
| bdgLog -Category ModuleEvent ('<-- exit  {0}' -f @($PSCommandPath.Name))
