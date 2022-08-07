Using namespace System.Collections.Generic
using namespace System.Text
#Requires -Version 7




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
    <#
    see more

    -
    - Base Class Constructors: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7#calling-base-class-constructors
    - Implementing IComparable https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7#inheriting-from-interfaces

    #>


    # not written to be performant, but useful

    [ValidateNotNull()][string]$RawOriginal = [String]::Empty
    [byte[]]$EncodedText = @()
    [string]$EncodingName = 'utf-8' # should be a Encoder getter
    [Text.Encoding]$Encoder

    # alias HighlightedDisplayString
    [ValidateNotNull()][string]$HighlightedDisplayString = [String]::Empty
    [ValidateNotNull()][string]$ControlCharDisplayString = [String]::Empty


    # was means the text *before* encoding it was blank or not
    # [bool]$WasTrueNull # should never reach
    [bool]$WasBlank
    [bool]$WasWhiteSpace

    [int]$ByteCount
    # [bool]$WasControlChars // regex Cc?

    [int]$ByteCount_AsUtf8
    [int]$ByteCount_AsUnicode
    [int]$ByteCount_Ascii

    [byte[]]$EncodedText_AsUtf8
    [byte[]]$EncodedText_AsUnicode
    [byte[]]$EncodedText_AsAscii


    # future: make encoding optional
    # EncodedTextResult ( [string]$InputString, [String]$EncodingName ) {

    EncodedTextResult ( [string]$InputString, [object]$Encoding ) {
        newEncoding utf-8
        newEncoding unicode
        newEncoding ascii

        [int]$ByteCount_AsUtf8
        [int]$ByteCount_AsUnicode
        [int]$ByteCount_Ascii

        if ($null -eq $InputString) {
            throw 'Required string was missing'
        }
        if ($InputString.length -eq 0) {
            throw 'String is empty!'
        }
        if ($Encoding -is 'System.Text.Encoding') {
            $this.Encoder = $Encoding
            Write-Debug "As Encoder: $Encoding"
        } else {
            $this.Encoder = newEncoding $Encoding
            Write-Debug "As String -> NewEncoding: $Encoding"
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
        $this.ControlCharDisplayString = $InputString | Format-ControlChar

        $this.EncodingName = $this.Encoder.WebName

        $this.EncodedText = $this.Encoder.GetBytes( $InputString )
        $this.ByteCount = $this.Encoder.GetByteCount( $InputString )
        # $this.EncodedText = $this.Encoder.GetMaxCharCount()

        # this.Encoding als has these
        # $this.Encoder_MaxByteCount = $this.Encoder.GetMaxByteCount()
    }
}

<#
Pester test
    validate .Length and .ToArrays.count are equal

#>

$Samples = @{
    Family3  = '👨‍👧‍👶'
    Monkey   = '🐒'
    Newlines = "line1`n`nline3`ttab"
    Ascii    = 'Hi world', @(0..127 | ForEach-Object { [char]$_ } | Join-String -sep '.') | Join-String -sep ';'
}
$enc = newEncoding utf-8
$enc.GetByteCount( $Samples.Family3 )

hr
$newEnc = newEncoding unicode
$results = $Samples.Values | ForEach-Object {
    $cur = $_
    [EncodedTextResult]::new( $cur, 'utf-8' )
    [EncodedTextResult]::new( $cur, $newEnc )
}

$results
$results.count | Label 'count $results'

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

#   @{

#    [system.text.encoding]::ASCII.getbytes($sampleStr).count
#    [system.text.encoding]::UTF8.getbytes($sampleStr).count
#    [system.text.encoding]::unicode.getbytes($sampleStr).count

# }