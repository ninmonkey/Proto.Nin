function SplitByPartition {}
function SelectListBySlice {
    # Python rules
}


h1 'filter by taypes'

@'

# SplitOnPartition

# ex: iterate single line log files

    PS> 'date: severity: error: json # sample line
    | -part ':' -Names 'date', 'severity', 'error', 'json'

outputs
    @{ Date = '2022-01-14', Severity = .., Error = .., Json = ..  }



## maybe?

  $source = 'a'..'z'
    ... | Slice '::-1'
    ... | Slice '0:2'
    ... | Slice '0:2:4'



        $Source.Count

        #
        $Source.Slice('0:3')
            # 'a', 'b', 'c' '

        $Source.Slice('0:3')
            # 'a', 'b', 'c' '
'@ | bat -l ps1
| Join-String
| Label 'foo'
# | Join-String -sep "`n"
# | _join_TextLines

# function _join_TextLines {
#     [Alias('-joinNL')]
#     [cmdletBinding()]
#     # join string by newline
#     $Config = @{
#         Delim = "`n"
#     }

#     $Input | Join-String -sep "`n"
# }