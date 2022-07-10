

function FixTable {
    param( [string[]]$PropList = @('Name', 'length', 'LastWriteTime') )
    process {
        $Input | Format-Table -Property $propList -AutoSize
    }
}

Get-ChildItem | FixTable



function FixTable {
    param(
        [string[]]$PropList = @('Name', 'length', 'LastWriteTime'),
        [string[]]$SortBy = @('FullName', 'Name', 'LastWriteTime'),
        [object]$GroupBy = { $true }
    )
    process {
        $Input
        | Sort-Object -Property $SortBy -Descending
        | Format-Table -Property $propList -AutoSize -GroupBy ${true}
    }
}
