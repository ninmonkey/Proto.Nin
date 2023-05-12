
function distinctRunesFromClipboard {
     ((gcl ) -join '' ).EnumerateRunes() | ? Value -gt 0xff | Join-String | sort -Unique
}