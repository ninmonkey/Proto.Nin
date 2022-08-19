

function FixTable {
    <#
    .SYNOPSIS
        This is both [1] notebook sugar and [2] standardizes output
    .DESCRIPTION
        There are quirks depending on which kernel, the host,
        plus any custom formatters (like for files)
    #>
    param(
        [string[]]$PropList = @('Name', 'length', 'LastWriteTime')

    )
    process {
        $Input | Format-Table -Property $propList -AutoSize
    }
}

Get-ChildItem | FixTable



function fancyFixTable {
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

function FixTable {
    param( [string[]]$PropList = @('Name', 'length', 'LastWriteTime') )
    process {
        $Input | Format-Table -Property $propList -AutoSize
    }
}
