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
function wrapText {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        # maybe param 1?
        [Parameter(Position = 0, Mandatory)]
        [WrapStyle]$Style,

        # Optional prefix string
        [Alias('op')]
        [Parameter()]
        [string]$Prefix,

        # Optional suffix string
        [Alias('os')]
        [Parameter()]
        [string]$Suffix,

        # First argument (when styles have parameters)
        [Alias('Arg1')]
        [Parameter()]
        [string]$Argument1,

        # Second argument (when styles have parameters)
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

function _fmt_enumSummary {
    <#
    .SYNOPSIS
        kind of sugar for quickly viewing enum and format as one
    #>
    param(
        # return names, else render?
        [Parameter()][switch]$PassThru,

        [Alias('Name')]
        # todo: EnumTypeCompletion
        [Parameter(Position = 0, ValueFromPipeline)]
        [Object]$InputEnum
    )
    process {


        # allow enum instance, enum name, or value in an enum
        # todo: refactor: as Resolve-EnumType

        if ($InputEnum -is 'enum') {
            $en = $InputEnum
        }
        # if ($InputEnum -is 'type') {
        #     $en = $InputEnum
        # }
        if ( $null -eq $en) {
            $en = $InputEnum -as 'enum'
        }
        if ($null -eq $en) {
            Write-Error "could not resolve '$InputEnum'"
        }
        if ($PassThru) {
            $en | Get-EnumInfo | Sort-Object Name
            return
        }
        $names = $en | Get-EnumInfo | ForEach-Object name | Sort-Object
        $names | UL | Label "enum [$($en.Name)]"

    }
}
# H1 -fg purple '---- unwrap'
# $StyleList | ForEach-Object {
#     $Style = [WrapStyle]$_
#     # this could be wrapText itself, but to prevent confusion
#     Label '[WrapStyle]::' $Style -sep ''
#     'a'..'c' | wrapText -style $Style | UL
# }

& {
    $ErrorActionPreference = 'break'

    H1 -bg white -fg purple 'As -PassThru'
    [System.ConsoleColor] | _fmt_enumSummary -PassThru
    [System.ConsoleColor]::Red | _fmt_enumSummary -PassThru
    'System.ConsoleColor' | _fmt_enumSummary -PassThru

    H1 -bg white -fg purple 'As'
    [System.ConsoleColor] | _fmt_enumSummary
    [System.ConsoleColor]::Red | _fmt_enumSummary
    'System.ConsoleColor' | _fmt_enumSummary
}