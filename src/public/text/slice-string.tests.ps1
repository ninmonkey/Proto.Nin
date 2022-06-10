BeforeAll {
    . (Join-Path $PSSCriptRoot 'slice-string')
}

Describe 'Slice-String' {
    BeforeAll {
        $Sample = @{
            WikiAnts  =
            'Ants are eusocial insects of the family Formicidae and, along with the related wasps and bees, belong to the order Hymenoptera. Ants appear in the fossil record across the globe in considerable diversity during the latest Early Cretaceous and early Late Cretaceous, suggesting an earlier origin. Ants evolved from vespoid wasp ancestors in the Cretaceous period, and diversified after the rise of flowering plants. More than 13,800 of an estimated total of 22,000 species have been classified. They are easily identified by their geniculate (elbowed) antennae and the distinctive node-like structure that forms their slender waists.'

            WikiLemor = 'Lemurs are not monkeys'
        }

        $Expected = @{
            WikiAnts = @{
                First5 = $Sample.WikiAnts -split '' | Select-Object -First 5 | Join-String -sep ''
                Last5  = $sample.WIkiAnts -split '' | Select-Object -Last 5 | Join-String -sep ''
            }
        }

    }
    Describe 'Pipe' { }
    It 'wip' {
        { throw 'WIP left off here' } | Should -Not -Throw
    }
    Describe 'Format-TruncateString' {
        BeforeAll {
            $Sample = 'sdfds'
        }
        It 'Constrains Max Length' {
            It 'Out of Bounds Does Not Throw' {
                { Format-TruncateString -text 'abcd' -first 20 } | Should -Not -Throw
                { Format-TruncateString -text 'abcd' -first -20 } | Should -Not -Throw
                { Format-TruncateString -text 'abcd' -Last 20 } | Should -Not -Throw

            }

            Format-TruncateString -text 'abcd' -first 20
            | Should -Be 'abcd'

        }
        It '"<Label>": "<Sample>" == "<Expected>"' -ForEach @(
            @{
                Sample   = $Sample.WikiAnts
                Label    = 'First5'
                Expected = $Expected
            }

        ) {
            # Format-Column -Text $Sample
            return $true

            # Set-ItResult -sc -Because 'to add more dynamically generated tests'

        }
    }
}

<#>
$Sample = 'MethodInvocationException: Exception calling "ToCharArray" with "2" argument(s): "Index was out of range. Must be non-negative and less than the size of the collection.'
# TruncateString 'a '

$t1 = Format-TruncateString -Text $Sample -First 5
$t2 = Format-TruncateString -Text $Sample -Last 5


$t1 -eq 'Metho'
$t2 -eq 'tion.'
#>