function _findNewest.proto {
    # super quick based on 
    param(
       [argumentCompletions('All', 'pbix', 'json', 'ps1', 'png', 'cs', 'ipynb')]
       [parameter(Mandatory, Position=0)]
       [string[]]$Filetype,

       [ValidateSet('LastWriteTime', 'Name', 'Length')]
       [string]$SortBy = 'LastWriteTime',

       [ArgumentCompletions('5minutes', '5hours', '48hours', '5days', '1month', '1year')]
       [string]$ChangedWithin = '7hours',

       [int][Alias('max')]$LimitCount = 400
    )
    $argsFd = @(
        '--changed-within', $ChangedWithin,        
        '--color', 'always',
        $Filetype | %{ 
            '-e', $Filetype
        }
    )
    $argsFd | Join-String -sep ' ' -op 'fd ' | Write-ConsoleColorZd 'gray70'
    #Write-Information 
    $global:fzfLast = & 'fd' @argsFd
    | sort { $_ | StripAnsi | gi | %{ $_.$SortByProp }}
    | select -First $LimitCount
    | fzf -m --ansi #--color=always
}


#_findNewest.proto ps1 -SortBy LastWriteTime -ChangedWithin 5minutes
