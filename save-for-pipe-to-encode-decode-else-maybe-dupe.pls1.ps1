# 2023-03-03: pass thru
Set-Alias 'jStr' -Value 'Microsoft.PowerShell.Utility\Join-String' -Description 'direct alias to the built in'
$jBytes = @{
    Sep          = ' '
    FormatString = '{0:x2}'
}

$source = Get-Item $PSScriptRoot


$s = $source.PSPath -replace 'username', 'fake'
[System.Text.Encoding]::Unicode.GetBytes($s) | jStr @jBytes

hr

$s | jStr @jBytes { [System.Text.Encoding]::Unicode.GetBytes($_) }

function _iterTextEncodings {
    [OutputType('System.Text.EncodingInfo')]
    [CmdletBinding()]
    param()
    $encList = [Text.Encoding]::GetEncodings()
    $encList | Format-Table -auto | Out-String | Write-Information

}

function _newEncoder {
    <#
    .EXAMPLE

        @(
            'utf-8', 'Unicode', 'utf-16le'
        ) | %{  [Text.Encoding]::GetEncoding( $_ ) } |ft
    .link
        System.Text.EncodingInfo
    .link
        System.Text.Encoding
    .link
        System.Text.Encoder
    .link
        System.Text.Encoding.CodePages
    #>
    [Alias('New-TextEncoder')]
    [CmdletBinding()]
    param(
        # codepage / web.header name and encodings are valid
        [ArgumentCompletions(
            'Utf-8',
            'Unicode', # tooltips explain difference
            'utf-16',
            'utf-16le',
            'us-ascii',
            'iso-8859-1',
            'latin1',
            437, # OEM
            'cp875', # was this something?
            1252,
            1250

        )]
        [Parameter(Mandatory)]
        [string[]]$Encoding
    )
    [Text.Encoding]::GetEncoding( $Encoding )
}
function _encodeText {
    <#
    .SYNOPSIS
        silly sugar to encode piped text, then render as bytes, using Join-String (for fun)
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding.getencoder?view=net-6.0#system-text-encoding-getencoder
    .link
        https://docs.microsoft.com/en-us/dotnet/standard/base-types/character-encoding
    #>
    [OutputType('System.Text')]
    param(
        [AllowNull()] # Important for user UX when piping, especially Get-Content
        [Parameter(ValueFromPipeline)][string]$InputText,

        [ArgumentCompletions(
            'Utf-8',
            'Unicode', # tooltips explain difference
            'utf-16',
            'utf-16le',
            'us-ascii',
            'iso-8859-1',
            'latin1',
            437, # OEM
            'cp875', # was this something?
            1252,
            1250
        )]
        [Parameter(Mandatory)]
        [string]$EncodingName,

        [switch]$AsBase64

    )
    begin {
        $curEncoder = _newEncoder $EncodingName
        $Config = @{
            Join_DefaultKwargs = @{
                Sep = ' '
                FormatString = '{0:x2}'
            }
            NoColor = $null -eq $env:NO_COLOR
        }
        $jBytes = $Config.Join_DefaultKwargs
    }
    process {


        if ($AsBase64) {
            throw 'write encoded bytes as base 64 instead of hex'
            $bStr = $curEncoder.GetBytes($InputText)
            | Microsoft.PowerShell.Utility\Join-String @jBytes
            return
        }

        $bStr = $curEncoder.GetBytes($InputText)
        | Microsoft.PowerShell.Utility\Join-String @jBytes
    }
}

hr
hr
$source = gi $PSScriptRoot


$s = $source.PSPath -replace 'username', 'fake'
[System.Text.Encoding]::Unicode.GetBytes($s) | jStr @jBytes
| %{ $_ -replace ' 00 ', {
     @( ' '; Write-ConsoleColorZd -InputObject '00' -fg gray10 -bg 'gray10'
     ' ' ) -join ''
}  }

hr

$s | jStr @jBytes { [System.Text.Encoding]::Unicode.GetBytes($_) }