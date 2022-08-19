$PSDefaultParameterValues['rLs:Infa'] = 'Continue'

function Get-RecentChildIem {
    # sugar for fast files
    [Alias('rLs')]
    [CmdletBinding()]
    param(
        # root path[s] to use
        [string[]]$Path = '.',

        # files changed within a timeframe
        [ArgumentCompletions('30seconds', '5minutes', '2hours', '2days')]
        [string]$ChangedWithin,

        [ArgumentCompletions('LastWriteTime', 'Name', 'FullName', 'Length', 'Extension')]
        [string]$SortBy,
        [switch]$Descending,
        # Relative strips colors, leave as-is to keep colors
        [switch]$Relative, [switch]$Help
    )
    if($Help) { Start 'https://github.com/sharkdp/fd#fd' ; return; }
    $fdArgs = @(
        if($ChangedWithin) {  '--changed-within', $ChangedWithin  }
        foreach($p in $Path) { 
             # todo: verify if it is 1] --search-path="." or 2] --search-path "."
             @(
             '--search-path='
             gi $P -ea stop | Join-String -DoubleQuote FullName
             ) -join ''
        }
        #gi $Path -ea stop
        if( -not ($Env:NO_COLOR )) { '--color=always'}
    )

    $query = & 'fd' @fdArgs 
    $cmdInfo = $fdArgs | Join-String -sep ' ' -os "`n" -op ( "`ninvoke -> {0} items`n    fd " -f $query.count ) 
    | New-Text -fg 'gray40' # toggle this off to remove pansies requirement
    

    $Sorted = $query
    if( $SortBy ) {
        $Sorted = $query | sort -Property { 
          $_ | StripAnsi | gi | % $SortBy
        } -Descending:$Descending
    }

    if( -not $Relative ) { 
       $sorted
       $cmdInfo | Write-Information
       return
    }
    $sorted | To->RelativePath
    $cmdInfo | Write-Information
}


rls -Path (gi .\.vscode )

