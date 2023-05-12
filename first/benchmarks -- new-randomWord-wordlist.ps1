. (Get-Item -ea stop (Join-Path $PSScriptRoot 'new-randomWord-wordlist.ps1'))
Import-Module -ea stop 'Benchpress'

$max = 10000
bench -Technique @{
    'Join-String' = {
        0..$max | Join-String -sep ', '
    }
    '-join'       = {
        0..$max -join ', '
    }
} -GroupName 'group1' -ov 'res4'

bench -Technique @{
    'Join-String' = {
        0..$max | & { process { $_ } }
    }
    '-join'       = {
        0..$max -join ', '
    }
} -GroupName 'group1' -ov 'res4'



return
$max = 10000
bench -Technique @{
    'prand' = {
        foreach ($x in 0..$max) {

            p.randInt -min 0 -max 10
        }
    }
    'basic' = {
        foreach ($x in 0..$max) {
            Get-Random -min 0 -max 10
        }
    }
    'piped' = {
        foreach ($x in 0..$max) {
            0..10 | Get-Random -Count 1
        }
    }

} -RepeatCount 10 -ov 'res0'



return

$max = 10000
bench -Technique @{
    'Explicit'               = {
        foreach ($x in 0..$max) {
            $w = p.randWord
            $w.ToUpper()
        }
    }
    'Explicit2_invariant'    = {
        foreach ($x in 0..$max) {
            $w = p.randWord
            $w.ToUpperInvariant()
        }
    }
    'forShorthand'           = {
        foreach ($x in 0..$max) {
            $w = p.randWord
            $w | ForEach-Object ToUpper
        }
    }
    'forShorthand_invariant' = {
        foreach ($x in 0..$max) {
            $w = p.randWord
            $w | ForEach-Object ToUpperInvariant
        }
    }

    # $cmds = $ExecutionContext.InvokeCommand.GetCommands('*', 'Function,Cmdlet,Alias', $true)
    # $cmdModules = @{}

    # foreach ($_ in $cmds) {
    #     if (-not $_.Module) { continue }
    #     if (-not $cmdModules[$_.Module.Name]) {
    #         $cmdModules[$_.Module.Name] = $_
    #     }
    # }

    # $cmdModules.Keys
} -RepeatCount 3 -ov 'ovResults'
# 'ExecutionContextAndArrayList'    = {
# $cmds = $ExecutionContext.InvokeCommand.GetCommands('*', 'Function,Cmdlet,Alias', $true)
# $moduleNames = [Collections.ArrayList]::new()

# foreach ($_ in $cmds) {
#     if (-not $_.Module.Name) { continue }
#     if ($moduleNames -notcontains $_.Module.Name) {
#         $null = $moduleNames.Add($_.Module.Name)
#     }
# }
# $moduleNames
# }

# 'Get-Module -ExpandProperty Name' = {
#     $moduleNames = Get-Module | Select-Object -ExpandProperty Name
#     $moduleNames
# }
# 'foreach Get-Module'              = {
#     $moduleNames = foreach ($_ in Get-Module) {
#         $_.Name
#     }
#     $moduleNames
# }
