
function Get-ManpageHelp {
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
    [Alias('nMan')]
    [cmdletbinding()]
    param( [string]$Command, [switch]$Short )
    $bin = Get-Command -CommandType Application -ea SilentlyContinue -Name $Command
    | Select-Object -First 1

    #$bin | label 'stuff'
    if ( -not $bin ) {
        return "InvalidCommand: $Command"
    }
    & $bin @(
        $Short ? '-h' : '--help'
        # '--color=always'
    )
}

Set-Alias 'nMan' 'Get-manpagehelp' -Force -Description 'Using "man" has issues because the formatter agressively converts it to Get-Help' # else it opens get-help
if ($false) {
    @'
    ## Example Mappings

    nman fd
    nman fd -Short

        fd --help
        fd -h


'@
}