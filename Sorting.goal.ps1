function Sorting {}

h1 'heading'

@'
Sorting StrLen
Sorting Str Len
    [ Shortest | Longest ]
Sorting Str UnicodeLen


# not sure
Sorting Str
    UnicodeLen
    LenCodepoints
    CountCodepoints
    CodepointsCount

gci fg:\
| Sorting Color
    Arg1
        [ Hue | Int32 |  Hsl | Lab | Lch | Grayscale.. ]

gci fg:\
| Sorting Color

Sorting Str
'@ | bat -l ps1
# | Join-String -sep "`n"
# | _join_TextLines
| Label 'foo'

