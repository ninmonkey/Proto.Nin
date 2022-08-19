
# convert to hashtable where keys and values are not the smae
# to allow custom sp

function New-RandomSampleData {
    [Alias('Stuff')]
    [CmdletBinding()]
    param(
        [ValidateSet(
            'Int', # Arg2: Min/Max
            'Double', # Same
            'Text', #
            'Guid',
            'sdf',
            'sdffds'
        )]
        [string]$SampleKind = 'person'
    )
    $SubNameOrArgs = @{
        'Person' = @(
            '[person]', '[lastname?]', '[firstname?]'
        )
        'Color'  = @{
            'PansiesObject'
            'RGB'
            'HSL'
            'CIE or other'
        }
        'Text'   = @{
            'char'     = @{
                'Ascii' = 'sets min,max'
                'Utf8'  = 'sets min,max'
            }
            'word'     = @{}
            'sentence' = @{}
        }

    }



}

return

