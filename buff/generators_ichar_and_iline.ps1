function ichar  {
   param( [int]$Count = 1 )
   'a'..'z' | Get-Random -Count $count | Join-String -sep ''
}
function iline { 
   param( [int]$Count = 1, [int]$Columns = 80 ) 
   1..$Count | %{ ichar -Count $Columns }
}

0..1000 | %{ (ichar 20)  } | Out-Null

