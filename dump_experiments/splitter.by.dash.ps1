$App ??= @{ Root = Get-Item . }
$App.Source0 = Get-Item 'C:\nin_temp\csv\bad_on_purpose.not_a_csv.csv'

$str ??= @{
    RawLines = (Get-Content $App.Source0)
}
$Str.LinesEscaped = $((Get-Content -Raw $App.Source0) -replace ' ', '␠') -split '\r?\n'
$Str.LinesRaw = ((Get-Content -Raw $App.Source0)) -split '\r?\n'
$Regex = @{}
$lines = $Str.RawLines
$cur = $str.LinesEscaped
$cur

$Str.ColNames = $cur[1]
$Str.Bars = $cur[7]

$Str.Bars -split '[-]'

$found = $str.Bars | Select-String -Pattern '[-]+' -AllMatches
$found | Format-List; $found | Format-Table -AutoSize; $found;

$offsets ??= @{ }
$offsets.firstIter = $found.Matches | ForEach-Object index
$cur0 = $offsets.firstIter
$cur0 | Csv2
h1 'preview'
$Str.LinesEscaped | s -First 100

$Str.LinesEscaped | s -First 100
| ForEach-Object {
    $_
}

h1 'single'

$target = $Str.LinesEscaped[7]
$target
$prev = 0
foreach ($offset in $cur0) {

}