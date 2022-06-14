
function fd_NewQueryTerm_Paths {
    param( [Parameter(ValueFromPipeline, Mandatory)] [object[]]$RootPaths , [Alias('AsString')][switch]$AsSingleString )
    process {
        #$whatRoots = $venvList | %{ $_.FullName | Join-String -op '--search-path ' -DoubleQuote }
        $prefixed_searchTerm = $RootPaths | Get-Item | ForEach-Object { $_.FullName | Join-String -op '--search-path ' -DoubleQuote }
        if ( -not $AsSingleString ) {
            return $prefixed_searchTerm ; return;
        }
        $renderAsOne = $prefixed_searchTerm | Join-String -sep ' '
        return $renderAsOne
        #fd activate --search-path $venvList.FullName
    }

}
(Get-PSProvider -PSProvider FileSystem).drives.root | csv2 | label 'AllRoots'
$venvList | csv2 | Label 'in  ->'

fd_NewQueryTerm_Paths -RootPaths @( (Get-PSProvider -PSProvider FileSystem).drives.root ) #| %{ $_ -split ' '}
Hr
fd_NewQueryTerm_Paths -RootPaths $venvList | UL | label 'out <- [string[]]'
fd_NewQueryTerm_Paths -RootPaths $venvList -AsSingleString | label 'out <- -AsString'
Hr
