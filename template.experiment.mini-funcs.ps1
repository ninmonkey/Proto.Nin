function _join_TextLines {
    [cmdletBinding()]
    param()
    $Config = @{
        Delim = "`n"
    }
    end {
        $_ | Join-String -sep "`n"
    }
}


function joinStr.1 {
    [CmdletBinding()]
    param(
        [Alias('By')]
        [Parameter(ValueFromPipeline)]
        [object[]]$InputObject
    )
    $Config = @{
        Delim = "`n"
    }
    end {
        $InputObject -join "`n"
        # $_ | Join-String -sep "`n"
    }
}

function splitStr.0 {
    throw "NYI, text completer from 'JoinStr.0'"
}
function joinStr.0 {
    param(
        # next: arg completer szuggests names mapping to newline or whitespace etc
        [ArgumentCompletions('`n', ', ', '')]
        $Delim = ''
    )
    end {
        [list[object]]$Types = $Input | Get-Unique -OnType
        $types.Reverse()
        return $Types
        # 'show help'
        # $Types -join ''
    }
}

$actual = $files | unique_byType
$Expected.Count | Label 'expected'
Get-ChildItem -d 2 | unique_byType


function unique_byType {
    param( )
    end {
        [list[object]]$Types = $Input | Get-Unique -OnType
        $types.Reverse()
        return $Types
        # 'show help'
        # $Types -join ''
    }
}
function unique_byText {
    param( )
    end {
        [list[string]]$unique_str = $Input | Sort-Object -Unique
        $unique_str.Count | Label 'Count'
        return $unique_str
        # 'show help'
        # $Types -join ''
    }
}









'a', 'e', 'c', 1, 9, '9'
| unique_byText | joinStr
return

'a'..'e' | JoinStr
JoinStr -InputObject @('z'..'q')


# ---- minimal pipeed
function f22 {
    param( $x = ', '  )
    end {
        $Input | Join-String -sep ', '
    }
}

'a'..'e' | f22



'a'..'e' | f22

$files = Get-ChildItem . -Depth 2
$expected = $files | Get-Unique -OnType
$actual = $files | unique_byType

$Expected.Count | Label 'expected'


Get-ChildItem -d 2 | unique_byType
# function _join_TextLines {
#     [Alias('-joinNL')]
#     [cmdletBinding()]
#     param()

#     # join string by newline
#     $Config = @{
#         Delim = "`n"
#     }

#     $_ | Join-String -sep "`n"
# }