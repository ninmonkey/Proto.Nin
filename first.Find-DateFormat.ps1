function formatObject? {
    <#
        .SYNOPSIS
            safe nullable failure, returned as null symbol
        .notes
            future: switch to return something other than a string,
            probably $Null or even nothing
        .example
            Find-DateFormat | sort kind | ft -GroupBy Kind FormatStr, Local, Utc
        .example
            # it's case insensitive, that wasn't my plan, but it looks cleaner
            Find-DateFormat | sort formatStr, Kind  | ft -GroupBy FormatStr FormatStr, Local, Utc
        #>
    param(
        [object]$InputObject,
        [string]$FormatString
    )
    try {
        $render = $InputObject.ToString($FormatString)
    } catch {
        $render = "[`u{2400}]"
    }
    return $render
}

class FormatStringResult {
    <#
    Typedata default should use these values
        Ft group: Kind
        sort Kind, FormatStr
        ft shoW: FormatStr, Local, Utc
    #>


    [ValidateSet('DateTime', 'DateTimeOffset')]
    [string]$Kind
    [string]$FormatStr
    [object]$Local
    [object]$Utc
}


function Find-DateFormat {
    param(
        # format strings to try
        [Parameter(ValueFromPipeline)]
        [string[]]$FormatStrings = @(
            'o', 'u', 'O', 'U',
            'yyyy-MM-ddTHH:mm:ss.fffZ',
            'yyyy-MM-ddThh:mm:ss.fffZ'
        ),

        [switch]$SkipDatetime,
        [Alias('SkipDtz')]
        [switch]$SkipDatetimeOffset



    )
    $Config = @{
        IncludeDatetime       = -not $SkipDatetime
        IncludeDatetimeOffset = -not $SkipDateTimeoffset
        FormatStrings         = $FormatStrings
    }

    $Values = $Config.formatStrings
    $Values | ForEach-Object {
        $formatStr = $_
        $now = [Datetime]::Now
        $NowZone = [DateTimeOffset]::Now

        if ($Config.IncludeDatetime ) {
            [FormatStringResult]@{
                Kind      = 'Datetime'
                FormatStr = $_ ;
                Local     = formatObject? $Now -Format $formatStr

                Utc       = formatObject? $Now.ToUniversalTime() -Format $formatStr
                # Utc       = $Now.ToUniversalTime().ToString($_)
            }
        }
        if ( $Config.IncludeDatetimeOffset ) {
            [FormatStringResult]@{
                Kind      = 'DateTimeOffset'
                FormatStr = $_ ;
                Local     = formatObject? $NowZone -Format $formatStr
                Utc       = formatObject? $NowZone.ToUniversalTime() -Format $formatStr
            }
        }
    } #| Format-Table -auto
}


Find-DateFormat