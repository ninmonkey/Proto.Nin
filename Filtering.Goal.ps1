function Filtering {}

h1 'filter by taypes'

@'
filtering NotBlank

    filtering NotBlank -prop 'PropName'
    filtering NotBlank -prop 'PropName'

filtering NotWhitespace





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