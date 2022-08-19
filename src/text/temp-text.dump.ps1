
function InspectUniLength {
    <#
    .SYNOPSIS
        inspect counts and lengths of unicode measurements
    #>
    [cmdletBinding()]
    param(
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
    process {



        $str = $InputObject
        $dbg = [ordered]@{
            Source      = $str
            SourceColor = "'${fg:green}${fg:gray80}${bg:gray30}${str}${fg:clear}${bg:clear}'"
            NumChars    = $str.Length
            '.Length'   = $str.Length
            '.Count'    = $str.count
        }

        if ($PassThru) {
            return [pscustomobject]$dbg
        } else {
            return $dbg
        }
    }
}



$StrSample = @{
    'Family'     = '👨‍👩‍👧‍👦'
    'Man'        = '1👨'
    'Ascii'      = 'zbfdef'
    'WhiteSpace' = ''
}



function Get-TextEncoding.proto {
    <#
    .synopsis
        returns [Text.Encoding] types
    .example
        PS> Get-TextEncoding -Codepage 65001
    .example
        PS> Get-TextEncoding -EncodingName 'utf-8'
        PS> Get-TextEncoding -EncodingName 'utf-8', 'utf-16'

    .notes
        todo
        - add encodings not found by -List
        - add non-text encodings (maybe extract to another command)
                - allow param to read encodng used by an object/struct

        signatures:

            GetEncoding(int codepage)
            GetEncoding(string name)

            GetEncoding(
                int codepage,
                System.Text.EncoderFallback encoderFallback,
                System.Text.DecoderFallback decoderFallback)


            GetEncoding(
                string name,
                System.Text.EncoderFallback encoderFallback,
                System.Text.DecoderFallback decoderFallback)

    see also:
        PS> [System.Drawing.Imaging.Encoder*

        Encoder                           EncoderFallbackBuffer             EncoderParameterValueType
        EncoderExceptionFallback          EncoderFallbackException          EncoderReplacementFallback
        EncoderExceptionFallbackBuffer    EncoderParameter                  EncoderReplacementFallbackBuffer
        EncoderFallback                   EncoderParameters                 EncoderValue

    > for information on defining a custom encoding, see the documentation for the "Encoding.RegisterProvider method"
    #>
    [Alias('Resolve->TextEncoder')]
    [OutputType('System.Text.Encoding')]
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        # [Parameter(Mandatory, Position=0, HelpMessage="doc")]
        # [TypeName]$ParameterName

        # todo

        [Alias('Name')]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory, Position = 0)]
        [string[]]$EncodingName,

        # [Alias('Name')]
        [Parameter(
            ParameterSetName = 'ByNum',
            Mandatory, Position = 0)]
        [int]$Codepage,

        [Parameter(
            ParameterSetName = 'ListOnly',
            Mandatory
        )][switch]$List,


        [Parameter()]
        [System.Text.EncoderFallback]
        $EncoderFallback,

        [Parameter()]
        [System.Text.DecoderFallback]
        $DecoderFallback

    )
    # auto import

    begin {
        if ($List ) {
            return [Text.Encoding]::GetEncodings()
        }
        if ($EncoderFallback -or $DecoderFallback) {
            throw "NYI: using params: EncoderFallback, DecoderFallback in '$PSCommandPath'"
        }
        if ($null -ne $DecoderFallback -or $null -ne $EncoderFallback) {
        }
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'ListOnly' {
                return
            }
            'ByName' {
                foreach ($name in $EncodingName) {
                    $encoding = [Text.Encoding]::GetEncoding( $name )
                    $encoding
                }
                break

            }
            'ByNum' {
                $encoding = [Text.Encoding]::GetEncoding( $Codepage )
                $encoding
                break

            }

            default {
                break
                # throw "Unexpected ParameterSetName: $($PSCmdlet.ParameterSetName)"
                Write-Error "Unexpected ParameterSetName: $($PSCmdlet.ParameterSetName)"
            }

        }

    }
}