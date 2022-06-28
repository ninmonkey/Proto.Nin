
function ConvertTo-UnicodeBytes {
    <#
    .SYNOPSIS
        Sugar encodes

        gcm -Module PSFramework *completion*, *completer* | % Name
    .link
        PSFramework\New-PSFTeppCompletionResult
    .link
        PSFramework\Register-PSFTeppArgumentCompleter

    #>
    [Alias('StrToBytes')]
    [OutputType('[System.Byte[]]')]
    [cmdletBinding()]
    param(
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String[]]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
    process {
        throw 'wip, requires: [_getEncodingsCompletionResults.proto]'

        $InputObject | ForEach-Object {
            $curLine = $_


        }
        return 'sdf'
    }
}
function ConvertFrom-UnicodeBytes {
    <#
    .SYNOPSIS
        Sugar to encode/decode
    #>
    [Alias('StrFromBytes')]
    [cmdletBinding()]
    param(
        [Alias('Bytes')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
    throw 'wip, requires: [_getEncodingsCompletionResults.proto]'
}
