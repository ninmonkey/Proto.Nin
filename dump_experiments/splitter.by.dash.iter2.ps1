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

$offsets.Actual = $found.Matches | ForEach-Object {
    $endAt = $_.Index + $_.Length
    [pscustomobject]@{
        PSTypeName = 'dev.nin.SplitterMatchPosResult'
        StrLen     = $_.Length
        StartAt    = $_.Index
        EndAt      = $endAt
        Value      = $_.Value
    }
}

$curGuid = 0

$CaptureOut = $str.LinesEscaped
| Select-Object -Skip 1
| ForEach-Object {
    $curLine = $_
    $curId = 0
    $offsets.Actual | ForEach-Object {
        $curMatchResult = $_

        try {
            $subStr = $curLine.Substring( $curMatchResult.StartAt, $curMatchResult.StrLen )
        } catch {
            Write-Warning "$Failed parsing  id: $Id, guid: $guid,"
        }
        [pscustomobject]@{
            Capture    = $substr ?? "`u{2400}"
            Id         = $CurId++
            Guid       = $curGuid++
            StrLen     = $subStr.Length
            OrigStrLen = $curMatchResult.StrLen
            StartAt    = $curMatchResult.StartAt
            EndAt      = $curMatchResult.EndAt
            OrigValue  = $curMatchResult.Value
            # Found =

        }
        $Null = 1
    }
}


$cur0 = $offsets.Actual
$cur0 | Csv2
h1 'preview'
$Str.LinesEscaped | s -First 100
return
$curId = 0
# $Str.LinesEscaped | s -First 100 | ForEach-Object { }

h1 'single'

h1 '$captureOut'

$CaptureOut | s -f 80 -ExcludeProperty orig*
| Format-Table


return
$curLine = $Str.LinesEscaped[7]
$curLine
$prev = 0
# foreach ($cur in $cur0) {
#     $max = $curLine.Length - $cur

#     $curline.Substring
#     # $curLine.
# }

