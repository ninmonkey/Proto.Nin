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

function TruncateString {
    # $str.ToCharArray(  ($str.length - 10), 10) -join ''
    [CmdletBinding(DefaultParameterSetName = 'FromStart')]
    param(
        # Source
        [Alias('Text')]
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

    $UserLen = $First ?? $Last
    $MaxLen = $InputObject.Count


    $StartIndex = 0
    $MaxSubStrLength = $MaxLen - $StartIndex
    $SubStrLength = [math]::min( $UserLen, $MaxSubStrLength )

    $StartIndex =
    switch ($PSCmdlet.ParameterSetName) {
        'fromStart' {
            $StartIndex = 0
            $SubStrLength = 0 + $First
            $SubStrLength = [int]::Min( $SubStrLength, $MaxSubStrLength)
            $chars = $InputObject.GetChar($StartIndex, $SubStrLength)
            return $chars -join ''
        }
        'fromEnd' {
            $StartIndex = 'x'
        }
        default {
            throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
        }
    }
}


$Sample = 'MethodInvocationException: Exception calling "ToCharArray" with "2" argument(s): "Index was out of range. Must be non-negative and less than the size of the collection. (Parameter '
# TruncateString 'a '