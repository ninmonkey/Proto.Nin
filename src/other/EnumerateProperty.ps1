using namespace System.Collections.Generic

function Get-PropertyEnumerator {
    <#
    .SYNOPSIS
        iterate on properties, mostly sugar
    .NOTES
        future: Optionally Update-TypeData adding function to [PSObject] ?
    #>
    param(
        # target object to inspect
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # Expose additional settings/or config, without
        # breaking compatibility in the future
        #  it's basically **kwargs
        [Parameter()][hashtable]$Options = @{}
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
            SortPropertyNames = $true # warning: sorts, but result is from Select-Object
        }
        [list[object]]$propList = [list[object]]::new()
    }
    process {
        # ((Get-Item . | io  )[0])

        foreach ($cur in $InputObject) {
            $propList.Add( $InputObject )

            $propertySortOrder ??= $cur.PSObject.Properties
            | ForEach-Object Name | Sort-Object -Unique
        }
    }
    end {
        'Sortby: {0}' -f @(
            $propertySortOrder | Join-String -sep ', '
        ) | Write-Debug

        foreach ($item in $propList) {
            foreach ($curProp in $item.PSObject.Properties) {
                # $PropertySortOrder
                $curProp_PropNameOrder = $curProp.PSObject.Properties
                | ForEach-Object Name | Sort-Object -Unique

                if ($Config.SortPropertyNames) {
                    $curProp | Select-Object -prop $curProp_PropNameOrder
                    continue
                }
                $curProp | Select-Object
                continue
            }
        }
    }
}


, (Get-Item .) | Get-PropertyEnumerator
# | Get-Random -Count 3

, (Get-Item .) | Get-PropertyEnumerator -Options @{
    SortPropertyNames = $false
}
# | Get-Random -Count 3
