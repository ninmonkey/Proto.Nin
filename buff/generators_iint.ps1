
function iint { #iInteger {
   # super not optimized 
   # [ [ [min] [max] ] [count] ] ]
   param($Min = 0, $Max = 100, $count = 1)
   Get-Random -Minimum $min -Maximum $max -Count $Count
} 
