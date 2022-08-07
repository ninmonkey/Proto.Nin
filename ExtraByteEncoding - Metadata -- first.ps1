Using namespace System.Collections.Generic
using namespace System.Text



function newEncoding {
    # let the user attempt to pass anything, codepate int or string
    [OutputType('System.Text.Encoding')]
    param(
        [ArgumentCompletions('utf-8', 'unicode', 'ascii')]
        [Parameter(ValueFromPipeline, Mandatory)]
        [Alias('Name')]
        [object[]]$EncodingName
    )

    process {
        foreach ($item in $EncodingName) {
            [Text.Encoding]::GetEncoding( $Item )
        }
    }
}

function encodeAs {
    # Encode text as...
    [OutputType('[System.Byte[]]')]
    param(
        # Strings to excodee
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        # Encoding type to use
        [ArgumentCompletions('utf-8', 'unicode', 'ascii')]
        [Parameter(Mandatory, Position = 0)]

        [string]$EncodingName
    )
    begin {
        $curEncoder = newEncoding -EncodingName $EncodingName
    }
    process {
        if ($null -eq $InputText -or $InputText.count -eq 0) {
            return
        }
        $InputText ??= ''
        $curEncoder.GetBytes( $InputText )

    }
}
Write-Warning 'semantically part of it doesn''t work on encoded text and result
Instead:
    a class [StringMetadata]$OriginalText

    Then
        Encoded.Original.WasBlank => is from [StringMetadata]$OriginalText.IsBlank()

'
class EncodedTextResult {
    [ValidateNotNull()][string]$RawOriginal = [String]::Empty

    # alias HighlightedDisplayString
    [ValidateNotNull()][string]$HighlightedDisplayString = [String]::Empty
    [ValidateNotNull()][string]$ControlCharDisplayString = [String]::Empty


    # was means the text *before* encoding it was blank or not
    # [bool]$WasTrueNull # should never reach
    [bool]$WasBlank
    [bool]$WasWhiteSpace
    # [bool]$WasControlChars // regex Cc?


    EncodedTextResult ( [string]$InputString ) {
        if ($null -eq $InputString) {
            throw 'Required string was missing'
        }
        if ($InputString.length -eq 0) {
            throw 'String is empty!'
        }

        $r = 255 * .8
        $ColorGrayBG = $script:PSStyle.Background.FromRgb( $r, $r, $r)

        $this.RawOriginal = $InputString
        $this.HighlightedDisplayString = @(
            $ColorGrayBG
            $InputString
            $script:PSStyle.Reset
        ) -join ''
        $this.WasBlank = [string]::IsNullOrEmpty( $InputString )
        $this.WasWhiteSpace = [string]::IsNullOrWhiteSpace( $InputString )
        $this.WasWhiteSpace = [string]::IsNullOrWhiteSpace( $InputString )
        $this.ControlCharDisplayString = $InputString | Format-ControlChar
    }



}
$results = @(
    # [EncodedTextResult]::new(' ')
    [EncodedTextResult]::new('ds Hi')
)
$results
$results.count | Label 'count'

return
function decodeAs {
    # dEncode text from this encoding.
    [OutputType('System.Text')]
    param(
        # Strings to excodee

        [Parameter(ValueFromPipeline)]
        [bytes[]]$InputBytes,

        # Encoding type to use
        [Parameter(Mandatory, Position = 0)]
        [validateSet('utf8', 'Unicode', 'Ascii')]
        [string]$EncodingName
    )
}

$Samples = @{
    $Family3  = '👨‍👧‍👶'
    $Monkey   = '🐒'
    $Newlines = "line1`n`nline3`ttab"
    $Ascii    = 'Hi world', @(0..127 | ForEach-Object { [char]$_ } | Join-String -sep '.') | Join-String -sep ';'
}
$enc.GetByteCount( $Samples.Family3 )
$enc.GetByteCount( $Samples.Newlines )
$enc.GetByteCount( $str )

#   @{

#    [system.text.encoding]::ASCII.getbytes($sampleStr).count
#    [system.text.encoding]::UTF8.getbytes($sampleStr).count
#    [system.text.encoding]::unicode.getbytes($sampleStr).count

# }