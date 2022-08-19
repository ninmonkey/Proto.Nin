using namespace System.Collections.Generic

function ${1:FooBar} {
    <#
    .SYNOPSIS
        ${2:Stuff}
    .NOTES
        .
    .Description
        .
    .EXAMPLE
        Pwsh🐒> Gci
    #>
    # [Alias('foo')]
    [OutputType('PSObject')]
    [CmdletBinding()]
    param(
        # Main inputs
        # [Alias('Text')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # Expose additional settings, ie: it's **kwargs
        [Parameter()][hashtable]$Options = @{}
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
            SomeSetting = 'blank'
        }
        [list[object]]$items = [list[object]]::new()
    }
    process {
        foreach ($Obj in $InputObject) {
            $items.Add( $Obj ) # or: $propList.AddRange
        }
    }
    end {
        $items
    }
}
