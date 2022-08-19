Join-Regex -Regex @(
    Join-Regex -Text ('Developer/Engineer/Programmer' -split '/') | Join-String -os '?'
    Join-Regex -Text ('Senior/Junior/Professional/Expert' -split '/') | Join-String -os '?'
)

Join-Regex -Text ('Developer/Engineer/Programmer' -split '/') | Join-String -op '(' -os ')?'


$optSegment = @{
    OutputPrefix = '('
    OutputSuffix = ')?'
}
$optGroup = @{
    OutputPrefix = '(', '?<Name>' -join ''
    OutputSuffix = ')?'
}
Join-Regex -Text ('Developer/Engineer/Programmer' -split '/') | Join-String @optSegment
Join-Regex -Text ('Developer/Engineer/Programmer' -split '/') | Join-String @optSegment
Join-Regex -Text ('Developer/Engineer/Programmer' -split '/') | Join-String @optGroup


function wrapTextBasic {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        [Alias('op')]
        [Parameter(Position = 0)]
        [string]$Prefix,

        [Alias('os')]
        [Parameter(Position = 1)]
        [string]$Suffix
    )
    process {
        $Prefix ??= '('
        $Suffix ??= ')'
        @(
            '('
            $InputText
            ')'
        ) -join ''
    }
}
enum WrapStyle {
    Under
    Dunder
    RegexOptional
    RegexNamedGroup
    PwshStaticMember
    PwshMember
    PwshVariable
    # PwshVarOptionalItem
    Parenthesis
    Bracket
    Brace
}
function wrapText_iter2 {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        [Alias('op')]
        [Parameter(Position = 0)]
        [string]$Prefix,

        [Alias('os')]
        [Parameter(Position = 1)]
        [string]$Suffix,

        # some support args
        [Parameter()]
        [string]$Argument1,

        # maybe param 1?
        [Parameter()]
        [WrapStyle]$Style
    )
    begin {
        if ( $Null -eq $Prefix ) {
            $Prefix = '('
        }
        if ( $Null -eq $Suffix) {
            $Suffix = ')'
        }
        switch ($Style) {
            ([WrapStyle]::Brace) {
                $Prefix = '{'
                $Suffix = '}'
            }
            ([WrapStyle]::PwshVariable) {
                $Prefix = '{'
                $Suffix = '}'
            }
            ([WrapStyle]::Bracket) {
                $Prefix = '['
                $Suffix = ']'
            }
            ([WrapStyle]::Parenthesis) {
                $Prefix = '{'
                $Suffix = '}'
            }
            ([WrapStyle]::Under) {
                $Prefix = '_'
                $Suffix = ''
            }
            ([WrapStyle]::Dunder) {
                $Prefix = '__'
                $Suffix = ''
            }
            ([WrapStyle]::RegexOptional) {
                $Prefix = '('
                $Suffix = '?)'
            }
            ([WrapStyle]::RegexNamedGroup) {
                $Prefix = @(
                    '(?<'
                    $Argument1 ?? 'Name'
                    '>'
                ) -join ''
                $Suffix = ')'
            }
            default {
                throw "Unhandled enum value: $($_)"

            }
        }
    }
    process {
        @(
            $Prefix
            $InputText
            $Suffix
        ) -join ''
    }
}


function wrapText {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        # maybe param 1?
        [Parameter(Position = 0, Mandatory)]
        [WrapStyle]$Style,


        [Alias('op')]
        [Parameter()]
        [string]$Prefix,

        [Alias('os')]
        [Parameter()]
        [string]$Suffix,

        # some support args
        [Alias('Arg1')]
        [Parameter()]
        [string]$Argument1,

        [Alias('Arg2')]
        [Parameter()]
        [string]$Argument2

    )
    begin {
        if ( $Null -eq $Prefix ) {
            $Prefix = '('
        }
        if ( $Null -eq $Suffix) {
            $Suffix = ')'
        }
        switch ($Style) {
            ([WrapStyle]::Brace) {
                $Prefix = '{'
                $Suffix = '}'
            }

            # ([WrapStyle]::PwshVariableOptionalItem) {
            #     # ([WrapStyle]::PwshVariableOptionalItem) {
            #     $Prefix = '($'
            #     $Suffix = ')?'
            #     $Prefix = @(
            #         '(?<'
            #         $Argument1 ?? 'Name'
            #         '>'
            #     ) -join ''
            # }
            ([WrapStyle]::Bracket) {
                $Prefix = '['
                $Suffix = ']'
            }
            ([WrapStyle]::Parenthesis) {
                $Prefix = '('
                $Suffix = ')'
            }
            ([WrapStyle]::Under) {
                $Prefix = '_'
                $Suffix = ''
            }
            ([WrapStyle]::Dunder) {
                $Prefix = '__'
                $Suffix = ''
            }
            ([WrapStyle]::RegexOptional) {
                $Prefix = '('
                $Suffix = ')?'
            }
            ([WrapStyle]::PwshVariable) {
                $Prefix = '$'
                $Suffix = ''

            }
            ([WrapStyle]::RegexNamedGroup) {
                $Prefix = @(
                    '(?<'
                    $Argument1 ?? 'Name'
                    '>'
                ) -join ''
                $Suffix = ')'
            }
            ([WrapStyle]::PwshMember) {
                # $One.Two
                $Prefix = @(
                    '$'
                    $Argument1 ?? 'Name'
                ) -join ''
                $Suffix = @(
                    '.'
                    $Argument2 ?? 'Member'
                ) -join ''
            }
            ([WrapStyle]::PwshStaticMember) {
                # $One.Two
                $Prefix = @(
                    '$'
                    $Argument1 ?? 'Name'
                ) -join ''
                $Suffix = @(
                    '::'
                    $Argument2 ?? 'Member'
                ) -join ''
            }
            default {
                throw "Unhandled enum value: $($_)"

            }
        }
    }
    process {
        @(
            $Prefix
            $InputText
            $Suffix
        ) -join ''
    }
}
H1 'header'
$StyleList | UL | Label 'enum [WrapStyle]'
$StyleList = [WrapStyle] | Get-EnumInfo | ForEach-Object name | Sort-Object

H1 'invoke without args'
H1 -fg purple '---- unwrap'
Label 'Type' 'No args, no join'
Label 'Code' ' .. | wrapText'
$StyleList | ForEach-Object {
    $Style = [WrapStyle]$_
    'a'..'c' | wrapText -style $Style
}
# function _joinBy {
#     [scriptBlock]
# }

H1 -fg purple '---- none'
H1 -fg purple '---- unwrap'
$StyleList | ForEach-Object {
    $Style = [WrapStyle]$_
    Label '[WrapStyle]::' $Style -sep ''
    'a'..'c' | wrapText -style $Style | UL
}

function _showExample {
    # todo: actual pipeline invoke passing variable to it
    # instead of $input hack
    param(
        [Alias('SB', 'ScriptBlock')]
        [scriptBlock]$JoinByScriptBlock
    )
    if ( -not $JoinByScriptBlock ) {
        $Input; return;
    }
    $Input | & $JoinByScriptBlock
}

H1 -fg purple '---- unwrap'
$StyleList | ForEach-Object {
    $Style = [WrapStyle]$_
    Label '[WrapStyle]::' $Style -sep ''
    'a'..'c' | wrapText -style $Style | UL
}


'a'..'e'
| _showExample -ScriptBlock { $input | UL }

0..4
| _showExample -ScriptBlock { $input | UL }



& {
    H1 -fg white -bg purple 'No Args'
    $StyleList | ForEach-Object {
        $Style = [WrapStyle]$_
        # this could be wrapText itself, but to prevent confusion
        'a'..'c' | wrapText -style $Style
    }
}
& {
    H1 -fg white -bg purple 'One, Two'
    $StyleList | ForEach-Object {
        $Style = [WrapStyle]$_
        Label '[WrapStyle]::' $Style -sep ''
        'a'..'c' | wrapText -style $Style -Arg1 'One' -Arg2 'Two'
    }
}

# H1 -fg purple '---- unwrap'
# $StyleList | ForEach-Object {
#     $Style = [WrapStyle]$_
#     # this could be wrapText itself, but to prevent confusion
#     Label '[WrapStyle]::' $Style -sep ''
#     'a'..'c' | wrapText -style $Style | UL
# }
