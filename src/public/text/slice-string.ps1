<#
Warning:
    a (-split '' -join '') preserves original content, but,
    if code-units get stripped off a code-point, errors can occur
    (because of encoding)

$text
    offset (allownegative)
    offsetFromEnd ( -1 * offset )

example of what this would sugar-ize

    $str.ToCharArray(  ($str.length - 10), 5) -join ''

could be represented as

        slice -10 5
        slice '-10:5'

example:

    $str.ToCharArray(  ($str.length - 12), 12) -join ''

could be represented as

        slice '-12:12'
        slice '-12:'
        slice '-12'



warning, need to define difference between
    - From X to End
        slice 'x:'

    - From X to Y
        slice 'x:y'

    - First X
        slice '0: count 5

maybe length is optional parameter besides slicing?


    first 10

        slice '10
        slice 'x'

    last 10

        slice ':-10'
        slice :-10
        slice -x

    from X to the end

        slice 'x'
        slice 'x:'

    from 3 to 5
        slice 3:5
        slice x:y
#>

# register metadata command in ninmonkey.console
if ($false) {
    Export-ModuleMember -Function @(
        'Format-TruncateString'
        'Pipe-TruncateString'
    ) -Alias @(

    ) -Variable @(

    )
}

function Format-TruncateString {
    <#
    .synopsis
        sugar to grab X chars without out of bounds --> SubStr( start, count )

    .NOTES
        no performance testing
    .link
        Proto.Nin\Format-TruncateString
    .link
        Proto.Nin\Pipe-TruncateString
    #>
    [CmdletBinding(DefaultParameterSetName = 'FromStart')]
    param(
        # Source
        [Parameter(Mandatory, Position = 0)]
        [Alias('Text')]
        [string]$InputObject,

        # FirstN chars (chars, not codepoints/runes)
        # You may pass a negative value (which switches to -Last N)
        [Parameter(
            Mandatory, Position = 1, ParameterSetName = 'FromStart')]
        [int]$First,

        # LanstN chars (chars, not codepoints/runes)
        [Parameter(
            Mandatory, Position = 1, ParameterSetName = 'FromEnd')]
        [int]$Last
    )

    # $UserLen = $First ?? $Last


    # $StartIndex = 0
    # $MaxSubStrLength = $MaxLen - $StartIndex
    # $SubStrLength = [math]::min( $UserLen, $MaxSubStrLength )
    $ResolvedParamSetName = $PSCmdlet.ParameterSetName
    if ($First -lt 0) {
        $ResolvedParamSetName = 'fromEnd'
        $Last = $First * -1
    }


    switch ($ResolvedParamSetName) {
        'fromStart' {
            # first N is:
            #   $str.ToCharArray( 0, (bounded10) )
            [string]$Target = $InputObject
            [int]$MaxLen = $Target.Length
            [int]$StartIndex = 0
            [int]$SubStrLength = 0 + $First
            [int]$BoundedStrLength = [Math]::Min( $SubStrLength, $MaxLen)
            $chars = $Target.ToCharArray($StartIndex, $BoundedStrLength)
            return $chars -join ''
        }
        'fromEnd' {
            # last N is:
            #   $str.ToCharArray(  ($str.length - 10), 10) -join ''
            [string]$Target = $InputObject
            [int]$MaxLen = $Target.Length
            [int]$BoundedStrLength = [Math]::Min( $Last, $MaxLen )
            [int]$StartIndex = $MaxLen - $BoundedStrLength
            $chars = $Target.ToCharArray($StartIndex, $BoundedStrLength)
            return $chars -join ''
        }
        default {
            throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
        }
    }
}


function Pipe-TruncateString {

    <#
    .synopsis
        wraps to allow optional pipeline with simpler parameters, maybe expose only one
    .NOTES
        no performance testing
    .link
        Proto.Nin\Format-TruncateString
    .link
        Proto.Nin\Pipe-TruncateString
    #>
    [CmdletBinding(DefaultParameterSetName = 'FromStart')]
    param(
        # Source
        [Alias('Text')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,

        # FirstN chars (chars, not codepoints/runes)
        [Parameter(
            Mandatory, Position = 0, ParameterSetName = 'FromStart')]
        [int]$First,

        # LanstN chars (chars, not codepoints/runes)
        [Parameter(
            Mandatory, Position = 0, ParameterSetName = 'FromEnd')]
        [int]$Last
    )
    process {
        Format-TruncateString -InputObject $InputObject @PSBoundParameters
    }

}

'hi'

