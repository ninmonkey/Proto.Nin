#Requires -Version 7.0
#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}

# first 2022-06-20

Describe '_fmt_ HexString' -Tag '_fmt_', 'Text', 'RawText' {
    BeforeAll {
        # Wait-Debugger
        $x = 10
        . (Get-Item -ea break ( Join-Path $PSScriptRoot '_fmt_asHexByteStr.proto.ps1' ))
        $Sample = @{
            RawBytes1 = [byte[]]( 0xf4, 3, 0x22, 0xff)
        }
    }
    # It 'Config: Always two digits' -ForEach @(
    It 'PadZero = <PadWithZero>, AlwaysTwo = <AlwaysTwoChars> is <Expected>' -ForEach @(
        @{
            PadPrefixWithZero = $true
            AlwaysTwoChars    = $true
            ExpectedExact     = 'f4 03 22 ff'
        }
    ) {
        $sample.RawBytes1 | _fmt_asHexByteStr.Proto -config @{
            PadPrefixWithZero = $PadPrefixWithZero
            AlwaysTwoChars    = $AlwaysTwoChars
        }
        | Should -BeExactly $ExpectedExact
        # $Expected
    }
}


# $Config = @{
#     PadPrefixWithZero = $true
#     AlwaysTwoChars    = $True
# }

# function _fmt_asHexByteStr.Proto {
#     $Input | ForEach-Object {
#         ('{0,2:x}' -f $_) -replace '\s', 0
#     }
# }

# # $allBytes = [IO.File]::ReadAllBytes((Get-Item $Target).FullName)
# $allBytes[0..10] | ForEach-Object { '{0:x}' -f $_ }
# $allBytes[0..10] | _fmt_asHexByteStr.Proto}