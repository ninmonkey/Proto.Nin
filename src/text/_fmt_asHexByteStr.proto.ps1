Import-Module Ninmonkey.Console

# first 2022-06-20
function _fmt_asHexByteStr.Proto {
    <#
    .SYNOPSIS
        converts bytes (or tiny int) to hex string pairs
    #>
    [cmdletBinding()]
    param(
        [Alias('Bytes')]
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [hashtable]$Options
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
            PadPrefixWithZero = $true
            AlwaysTwoChars    = $True
        }
    }

    process {
        $InputObject | ForEach-Object {
            if ($Config.AlwaysTwoChars) {
                $fstr = '{0:x}' -f $_
                ('{0,2:x}' -f $_)
            } else {
                $fstr = '{0:x}' -f $_
            }
            $render = $fstr -f @( $_ )
            if ($Config.PadPrefixWithZero) {
                $render = $render -replace '\s', 0
            }

            return $render
        }
    }
}

# $allBytes = [IO.File]::ReadAllBytes((Get-Item $Target).FullName)
$allBytes[0..10] | ForEach-Object { '{0:x}' -f $_ }
$allBytes[0..10] | _fmt_asHexByteStr.Proto



65534
0xf4, 03, 22, 0xff