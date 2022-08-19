
function iint { #iInteger {
   # super not optimized
   # [ [ [min] [max] ] [count] ] ]
   param($Min = 0, $Max = 100, $count = 1)
   Get-Random -Minimum $min -Maximum $max -Count $Count
}


function _randColor {
  param(  [Alias('Count')][int]$TotalCount = 1 )
  foreach($i in 1..$TotalCount) {
    $r,$g,$b = Get-Random -Count 3 -Minimum 0 -Maximum 255
    [rgbcolor]::new(  $r, $g, $b)
  }
}