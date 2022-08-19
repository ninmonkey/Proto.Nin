
function Get-ManpageHelp.proto {
    <#
    .synopsis
        sugar to view man pages on windows, (almost)
    .notes
        doesn't invoke sub-command help pages

        class1:
            gh help repo
            gh help repo list

            gh alias --help

    .EXAMPLE
        nman rg
        nman rg -Short
    #>
    [Alias('nMan.proto')]
    [cmdletbinding()]
    param(
        # Actual binary name
        # [ValidNativeCommand()]
        # [ValidNativeCommand(OneOrNone=$True)]
        [Parameter(Mandatory)]
        [string]$Command,

        # whether to use '--help' or '-h'
        [Alias('Abbr')]
        [Parameter()]
        [switch]$Short,

        # for extra args, like 'nman gh repo list'
        # *might* need to set position for this and/or command for UX
        [Alias('Rest')]
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$RemainingArgs,

        # Test generated command, without executing native command
        [Alias('WhatIf')]
        [switch]$TestOnly
    )
    $bin = Get-Command -CommandType Application -ea SilentlyContinue -Name $Command
    | Select-Object -First 1
    $binBat = Get-CommandType Application -ea stop -name 'bat'

    #$bin | label 'stuff'
    if ( -not $bin ) {
        return "InvalidCommand: $Command"
    }
    $binArgs = @(
        $Short ? '-h' : '--help'
        # '--color=always'
        $RemainingArgs
    )

    $binArgs | Join-String -sep ' ' -op $Command
    | Write-Information

    if ($TestOnly) {

    }

    & $bin @binArgs
    | & $BinBat @(
        '-l'
        'man'
    )
}

if ($false) {
    Set-Alias 'nMan' 'Get-manpagehelp' -Force -Description 'Using "man" has issues because the formatter agressively converts it to Get-Help' # else it opens get-help
    @'
    ## Example Mappings

    nman fd
    nman fd -Short

        fd --help
        fd -h

        nman fd        => fd --help
        nman fd -short => fd -h

    nman gh --short
    nman gh repo
    nman gh repo list

        gh -h
        gh help repo
        gh help repo list

        is there a diff between 'gh help <x>' and '--help' ?
        the former I would think is safer if parsing errors occur,
        ( starts in help mode)

    so
        nman <cmd>
        nman <cmd> <extraArgs>
            nman gh repo list

            cmd = gh
            extraArgs = repo list

            final =
                gh help repo list
                gh help <cmd> <extra>

'@
}