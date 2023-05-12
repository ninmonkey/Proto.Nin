<#
see more:
    https://dotnetcoretutorials.com/2021/08/10/generating-random-numbers-in-net/
#>
$wordCache ??= @{}


$wordCache.German ??= (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/oprogramador/most-common-words-by-language/master/src/resources/german.txt') -split '\r?\n'
$wordCache.GermanCount = $wordCache.German.Count


$randGenBasic = [Random]::new()
function p.randInt {
    <#
        .SYNOPSIS
            rand int in the range [min, max)]
        .notes
            [Random] also supports: NextBytes , NextDouble, NextInt64 , NextSingle
        .link
            System.Security.Cryptography.RandomNumberGenerator
        .link
            System.Random
    #>
    [OutputType('System.Int64')]
    param( [int]$Min = 0, [int]$Max = 1 )
    return $randGenBasic.NextInt64($Min, $Max)
}

# function p.randNumber {
#     $randGenBasic.Gext
# }

function p.randWord {
    [OutputType('String')]
    param()
    $offset = p.randInt -min 0 -max $wordCache.GermanCount
    return $wordCache.German[$offset]
}

p.randInt 0 3
p.randWord
