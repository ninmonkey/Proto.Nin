function _sortaRandWord {
    'a'..'e' | Get-Random -Count 20 | str csv | SplitStr ', ' | Join-String
}
function reset {
    $w1 = $Null
    $w2 = $null
}
$w1 ??= _sortaRandWord
$w2 ??= _sortaRandWord
$w1; $w2
$WordLen = $w1.Length

$AllPossible1 = 1..($wordLen) | ForEach-Object {
    $w1.Substring(0, $_) #| Str Prefix 'Try: '
}
$AllPossible2 = 1..($wordLen) | ForEach-Object {
    $w2.Substring(0, $_) #| Str Prefix 'Try: '
}
$AllPossible1 | str ul | Write-Color 'green'
$AllPossible2 | str ul | Write-Color 'pink'
[string[]]$matchesOther = @()

$AllPossible | ForEach-Object {
    $cur = $_
    if ($w2 -match $cur) {
        'yay'
    } else {
        '.'
    }


    # <# options: #> [regex]::
}

$w1 | Write-Color 'blue' | str prefix '$w1 = '
$w2 | Write-Color 'blue' | str prefix '$w2 = '