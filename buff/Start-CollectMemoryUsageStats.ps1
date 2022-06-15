$script:__memAppConfig = @{
    Root = 'C:\Users\cppmo_000\SkyDrive\Documents\2022\Power-BI\buffer_excel\2022-06\memory-usage-pwsh'
}



function Test-UserIsAdmin {
    <#
    .synopsis
        test if the current user in role: [Security.Principal.WindowsBuiltInRole]::Administrator
    .example
        PS>  Test-UserIsAdmin
    #>
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Get-CurrentLogPath {
    param(
        [ArgumentCompletions('jsonl', 'csv')]
        [string]$Extension = 'jsonl',

        [ArgumentCompletions('TopN_CPU', 'TopN_RAM', 'All')]
        [string]$Label = ''
    )
    #New-LogName {
    $Date = (Get-Date).ToString('u') -split '\s+' | Select-Object -First 1
    $Base = "export-usage_${Date}-${Label}.${Extension}"
    $Full = Join-Path $script:__memAppConfig.ExportRoot $Base
    if (-not (Test-Path $Full)) {

        Write-Debug "CreatingLogFile: '$Full'"
        Write-Host "CreatingLogFile: '$Full'"
        New-Item $Full -ItemType File
        # New-Item -Path $Full -ItemType File
    }
    Get-Item $Full
}
$script:__shared = @{}

$script:__memAppConfig += @{
    ExportRoot        = Get-Item -ea stop (Join-Path $script:__memAppConfig.Root '.logs')
    StartedAsAdmin    = Test-UserIsAdmin
    DebugSuperVerbose = $false
    DelayDurationMs   = 5000
}
# ActualInvoke
$script:Paths = @{
    All_Csv       = Get-CurrentLogPath -Label All -Extension Csv
    TopNCPU_Csv   = Get-CurrentLogPath -Label TopN_CPU -Extension Csv
    All_Jsonl     = Get-CurrentLogPath -Label All -Extension Jsonl
    TopNCPU_Jsonl = Get-CurrentLogPath -Label TopN_CPU -Extension Jsonl
}

# $ErrorActionPreference = 'inquire'
# Wait-Debugger


function _processRecord {
    # transform a single process
    [cmdletbinding()]
    param( $Target )
    $now = $script:__shared['Now']


    try {
        $data = [psCustomobject]@{
            PSTypeName                 = 'pbi.memoryStats'
            UserProcessorTime          = $Target.UserProcessorTime
            TotalProcessorTime         = $Target.TotalProcessorTime
            StartTime                  = $Target.StartTime
            StartedAsAdmin             = $script:__memAppConfig.StartedAsAdmin
            PrivilegedProcessorTime    = $Target.PrivilegedProcessorTime
            Pid                        = $Target.Id
            ParentPid                  = $Target.Parent.id
            ParentName                 = $Target.Parent.Name
            Now                        = $now
            Name                       = $Target.Name
            EndTime                    = $Target.EndTime
            # memory
            NonpagedSystemMemorySize64 = $Target.NonpagedSystemMemorySize64
            PagedMemorySize64          = $Target.PagedMemorySize64
            PagedSystemMemorySize64    = $Target.PagedSystemMemorySize64
            PeakPagedMemorySize64      = $Target.PeakPagedMemorySize64
            PeakVirtualMemorySize64    = $Target.PeakVirtualMemorySize64
            PeakWorkingSet64           = $Target.PeakWorkingSet64
            PrivateMemorySize64        = $Target.PrivateMemorySize64
            VirtualMemorySize64        = $Target.VirtualMemorySize64
            WorkingSet64               = $Target.WorkingSet64
            # Path
            # MainWindowTitle
            # __NounName
        }
    } catch {
        $_ | Write-Warning
        # $_ | Label 'failed'
    }

    # foreach ($Key in $data.keys.clone()) {
    foreach ($Key in $data.psobject.properties.name) {
        $value = $Data.$Key
        try {
            Writ
            e-Debug "Serialize: ${Key}.${Value} ?"
            if ($null -eq $Value) {
                Write-Debug "`tno, was [`u{2400}]."
                continue
            }
            $val_tinfo = $Value.GetType()

            if ($Value -is 'datetime' -or $Value -is 'datetimeoffset') {
                $Data.$Key = $Value.ToString('u')
                Write-Debug "`tas Datetime"
            } elseif ($Value -is 'TimeSpan') {
                Write-Debug "`tas TimeSpan"
                $Data.$Key = $Value.ToString()
            } else {
                Write-Debug "`tNo transform"
            }
        } catch {
            Write-Warning "``failed to modify starting object, maybe use a dict instead of properties`n${_}`n"
        }


    }

    return $data
}

function _collectSample {
    # a single 'sample' of which contains procs
    [cmdletbinding()]
    param(
        [int]$LimitByCpu = 15,
        [int]$LimitByMemory = 0
    )
    # $Limit = @{
    #     CpuMax    = $LimitByCpu ?? 0
    #     MemoryMax = $LimitByMemory ?? 0
    # }

    if ($Limit.MemoryMax) {
        Write-Warning 'by which metric should I sort memory for topN?'
    }

    $script:__shared['Now'] = [datetime]::Now
    $sample = Get-Process | ForEach-Object {

        if ($script:__memAppConfig.DebugSuperVerbose) {
            $procSplat = @{
                ErrorAction = 'break'
                Debug       = $true
                Target      = $_
            }
        } else {
            $procSplat = @{
                Target = $_
            }

        }
        _processRecord @procSplat
    }

    if ($LimitByCpu) {
        $filtered = $Sample | Sort-Object CPU -Descending | Select-Object -First $LimitByCpu
    } else {
        $filtered = $sample | Sort-Object CPU -Descending
    }
    return $filtered
    # this does the get-process, handles group
}
function Test-FileTooLarge {
    param(
        $FileName,

        [ArgumentCompletions('1mb', '10mb', '200mb', '1gb')]
        [int]$LimitLength
    )
    if ($null -eq $FileName) {
        # Write-Error '-FileName param is $Null'
        throw '-FileName param is $Null'
        # return $true
    }
    $Target = Get-Item -ea ignore $FileName
    if ($null -eq $Target) {
        throw "File '$FileName' does not exist!"
        # return $true #weird case

    }
    if ($Target.Length -gt $LimitLength) {
        Throw "File is too large! '$FileName' > $LimitLength"
        # return $true
    }
    return $false
}
function Invoke-CollectAllTypes {
    [CmdletBinding()]
    param(
        $Options = @{}
    )

    $Config = NinMOnkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
        LimitByCPU  = 15
        CollectAll  = $false
        MaxLogSize  = 64mb
        ExportCsv   = $false
        ExportJsonl = $True
    }


    $Collect = @{ LimitByCPU = @() ; CollectAll = @() }
    if ($Config.ExportCsv) {
        Write-Warning 'must preserve property order, when appending, or does the command do that?'
    }
    $Paths | Format-Table -AutoSize -Wrap | Out-String | Write-Debug
    # wp -> start
    # $pgroup = _collectSample
    # $pgroup.count | Label ' $pgroup'

    if ($Config.CollectAll) {


    }


    if ($Config.LimitByCPU) {
        $Collect.LimitByCPU = _collectSample -LimitByCpu $LimitByCpu
        if ($Config.ExportJsonl) {
            if (Test-FileTooLarge -FileName $Paths.All_Jsonl -LimitLength $Config.MaxLogSize) {
                throw "Log is too large: '$($Paths.All_Jsonl)', $($Config.MaxLogSize)"
            }

            # $Collect.LimitByCPU
            $Collect.LimitByCPU
            | Sort-Object CPU -Descending
            | s -First $Config.LimitByCPU -wait
            | ForEach-Object {
                # 1-line for jsonl
                # $warningpreference = 'break'
                $_ | to->Json -Depth 2 -EnumsAsStrings -Compress
                | Add-Content -Path $paths.All_Jsonl
                # $warningpreference = 'continue'
            }
        }
        "Wrote: {0} items to '{1}'" -f @(
            $Collect.LimitByCPU.Count
            $Paths.All_Jsonl | To->RelativePath
        ) | Write-Information

        return
        if ($Config.ExportCsv) {
            throw 'nyi: see earlier'
        }
        if ($Collect.LimitByCPU.count -gt $Config.LimitByCPU) {
            Write-Warning "List >= max limit: $($Collect.LimitByCPU.count)"
        }

        # $Collect.LimitByCPU | s -f 3 | Format-List
    }
    # wp <- end

}
function Start-CollectLoop {
    $Options = @{
        LimitByCPU  = 15
        CollectAll  = $false
        MaxLogSize  = 64mb
        ExportCsv   = $false
        ExportJsonl = $True
    }
    while ($true) {
        # [console]::Write('.')
        Label 'Sleep (ms)' $script:__memAppConfig.DelayDurationMs
        Get-ChildItem .\.logs\ -Recurse -Force # | Sort Length
        Invoke-CollectAllTypes -infa 'continue' -Options $Options


        Start-Sleep -Milliseconds $script:__memAppConfig.DelayDurationMs

    }
}

Goto $script:__memAppConfig.Root
Label 'Call' 'Start-CollectLoop()'

if ($false) {
    Start-CollectLoop
}

if ($false) {


    if (-not $script:__memAppConfig.DebugSuperVerbose) {
        Invoke-CollectAllTypes -infa 'continue'# -ea break

        Get-ChildItem .\.logs\ -Recurse -Force # | Sort Length
        return
    }


    return

    & fd @('--hidden', '--no-ignore')

    $ps ??= Get-Process
    $pafter = _collectSample
    $pa1 = $pafter[0]
    _processRecord $p[45]
    Get-CurrentLogPath -Extension 'jsonl'
}