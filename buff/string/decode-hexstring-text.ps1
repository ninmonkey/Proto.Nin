using namespace System.Collections.Generic


if ($false -and 'tests.ps1') {

    $expected = [byte[]] ([convert]::FromHexString('EFBBBFEFBBBF7B0A20202020226D6574'))

    ConverFrom-HexString.Proto 'EF BB BF EF BB BF 7B 0A 20 20 20 20 22 6D 65 74'
    | Should -BeExactly $Expected

    ConverFrom-HexString.Proto 'EFBBBFEFBBBF7B0A20202020226D6574'
    | Should -BeExactly $Expected
}


function ConvertFrom-HexString.Proto {
    <#
    hex string or list of hex strings to bytes

    #>
    [Alias('from->hexStr.Proto')]
    [Cmdletbinding()]
    param(
        # Hex as string, or list of strings
        # note: zero validation atm
        # Expects 'EE BB FF'
        # zero performance
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]

        [string[]]$HexString
    )
    begin {
        $regex = @{
            Pair = @'
(?x)
    ^
    # single token, always 2
    (?<Pair>
        [0-9a-fAF]{2}
    )
    $
'@
        }

        # class HexByteString.Proto {
        class HexByteStringProto {
            [list[byte]]$rawBytes = [list[byte]]::new()
            [string]$rawString

        }
        $byteStr = [Text.StringBuilder]::new()
        $bytes = [List[byte]]::new()
        $infoObj = [HexByteStringProto]::new()

    }
    process {
        throw @'
left off. was going to be an obect like

    [HexByteStringProto]
        rawString = 'ff 9a 22'


    [convert]::FromHexString(('ff 9a 22' -replace '\s+', ''))
        255, 154, 34

'@





        $HexString
        $byteStr.Append(($HexString -join ''))
        foreach ($line in $HexString) {
            $terms = $line -split '\s+'
            foreach ($item in $terms) {
                if ($item -notmatch $regex.pair) {
                    throw "Invalid term, expects hex pairs like: 'efbb' or 'ef bb'"
                }
                # $bytestr
                # $byteStr.
                # $byteStr.

            }


        }
    }
    end {
        return [HexByteStringProto]@{

        }

    }
}