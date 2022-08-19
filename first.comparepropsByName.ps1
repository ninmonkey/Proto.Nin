class TableRow {
    [Alias('ColumnName')]
    [string]$ItemNum
    # [string]$Row1Name
}

function comparePropByProp {
    <#
        future:
        colorize matching property values (same in the row)
    ColumnName =
        Item Number (first, second, third)

    .example
        Gci -path . |
    ## example output  ##

        <blank> | 1         | 2         | 3
              - | -         | -         | -
            Name| foo.ps1   | foo.png   | cat.png
        BaseName| foo       | foo       | cat

    #>
    [OutputType('proto.comparePropByProp.Summary')]
    [CmdletBinding()]
    param(
        # target object
        [object[]]$InputItems
    )
    $tList = $InputItems
    if ((-not $tList) -or $tList.Count -lt 1 ) {
        throw 'Invalid input, expects array'
    }

    $dbg = [ordered]@{
        ListLength = $tList.Count
    }
    $tList = Get-PSCallStack | formatCallStack
    $tFirstElem = @($tList)[0]
    $firstElemPropNames = $tFirstElem.psobject.properties.name | Sort-Object -Unique
    $everyPropNames = $tList | ForEach-Object { $_.psobject.properties.name } | Sort-Object -Unique
    $firstElemPropNames | Join-String -sep ', '

    $dbg | Format-Table | Out-String | Write-Debug
    #@($tList)[0].psobject.properties.name

}
function cat {
    $target = Get-PSCallStack
    comparePropByProp $target

}
function bar { Get-Content }
function foo { bar }

$SampleList =

# future: there's a way to make IG export an entire record so you
# can completely remove this wrapper component

function _newPerson {
    param( [int]$Count = 1)
    foreach ($x in 1..$Count) {
        [pscustomobject]@{
            Region  = NameIt\ig '[Region]'
            State   = NameIt\ig '[state]'
            Color   = NameIt\ig '[color]'
            Address = NameIt\ig '[address]'
            Name    = NameIt\ig '[person]'
            Id      = NameIt\ig '#'
        }
    }
}

$empList ??= _newPerson -count 20

$emplist | Format-Table







