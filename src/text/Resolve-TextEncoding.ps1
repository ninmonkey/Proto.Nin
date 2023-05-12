#Requires -Version 7

<#
2022-10-19: to save/merge/module
                _getEncodings.proto | generates [e ncodingInfo[]]
                Get-TextEncoding    | User entry point
    _getEncodingsCompletionResult   | generate autocompletions for some completer

    see also
    [Jborean encoding from Gets extended attributes for a file on an NTFS volume](https://gist.github.com/jborean93/50a517a8105338b28256ff0ea27ab2c8#file-get-extendedattribute-ps1-L4)
    <C:\Users\cppmo_000\SkyDrive\Documents\2022\Pwsh\my_Github\proto.nin\src\text\Resolve-TextEncoding.ps1>

see also:
    https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding.getmaxbytecount?view=net-6.0#remarks
#>
function _getEncodingsCompletionResults.proto {
    <#
    .SYNOPSIS
        wrapper that returns completion types
    .link
        _getEncodings
    .link
        _getEncodings.proto
    #>
    # [Alias('foo')]
    [cmdletBinding()]
    param(
        # [Alias('Encoding')]
        # [Parameter(Position = 0, ValueFromPipeline)]
        # [object]$InputObject

        # optional $config
        [Parameter()][hashtable]$Options
    )
    begin {
        $Config = Join-Hashtable -OtherHash $Options -BaseHash @{
            UseColor = $true
        }
    }
    process {
        # if ($InputObject) {
        #     return
        # }

        $query = _getEncodings.proto -SetName 'Default' -SortBy 'Name'
        Write-Debug 'currently hard-coded query'

        [int]$maxLengthofNames = $query.Name | Measure-Object Length -Maximum | ForEach-Object Maximum

        $query | ForEach-Object {
            $curEncInfo = $_
            $niceName = $_.Name, $_.DisplayName, $_.CodePage -join ', '

            $nameWithColor = @(
                "${fg:gray50}"

                if ($false -and 'AlignModeBasic') {
                    $_.Name

                } else {
                    $_.Name.PadLeft( $maxLengthofNames, ' ')
                    # $_.Name.PadRight( $maxLengthofNames, ' ')
                    ' '

                }

                "${fg:gray85}"
                $_.DisplayName
                "${fg:gray50}"
                ' '
                $_.CodePage
                "${fg:clear}"
            ) -join ''

            $tooltip = if ($Config.UseColor) {
                $NameWithColor
            } else {
                $niceName
            }
            $splatNew = @{
                CompletionText = $curEncInfo.Name  # replace
                ListItemText   = $curEncInfo.DisplayName
                # ListItemText   =  $curEncInfo.Name
                ToolTip        = $tooltip
                ResultType     = ([System.Management.Automation.CompletionResultType]::Text) # which type makes sense?

            }
            [Management.Automation.CompletionResult]::new(
                <# completionText: #> $splatNew.CompletionText,
                <# listItemText: #> $splatNew.ListItemText,
                <# resultType: #> $splatNew.ResultType,
                <# toolTip: #> $splatNew.ToolTip)
        }
        # | Sort-Object # or not?
    }
}

if ($true) {
    _getEncodingsCompletionResults.proto

} else {
    _getEncodings.proto -SetName 'Default' -SortBy 'Name' | s -Last 3
    | _getEncodingsCompletionResults.proto
}
$__protoNin ??= @{}
$__protoNin['FavEncodings'] = @(
    'utf-8'
    'us-ascii'
    'utf-16'
    'utf-16BE'
    'utf-32'
    'utf-32BE'
)

function Get-TextEncoding.proto {
    [Alias('Resolve->TextEncoding')]
    [cmdletbinding()]
    param()
    throw 'this is the func is the entry point, and, would map "utf8" -> "utf-8" correct names'
}

function _getEncodings.proto {
    <#
    .synopsis
        Dynamically generate a list of [EncodingInfo[]]
    .description
        Mostly sugar for [Text.Encoding]::GetEncodings()
        with optional arguments to filter the results by

        to be used for argument completions
    .EXAMPLE
        _getEncodings.proto
        _getEncodings.proto -CodePage 65001
        _getEncodings.proto -Pattern greek
        _getEncodings.proto -SetName Main
        _getEncodings.proto -SortBy CodePage
        _getEncodings.proto -SortBy DisplayName
    .link
        Find-Encoding.proto
    .link
        Get-TextEncoding

    .outputs
          [string | None]

    #>
    [Alias('_getEncodings')]
    [OutputType( [System.Text.EncodingInfo] )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter()]
        # tweak results
        [ArgumentCompletions('Default', 'Main')]
        [string]$SetName = 'Default',

        # Sort by
        [ValidateSet('Name', 'CodePage', 'DisplayName')]
        [string]$SortBy = 'Name',

        # filter names using regex
        [Alias('Regex')]
        [ArgumentCompletions('windows', 'utf-', '^iso', '^windows', 'DOS', '^IBM', 'greek', '^x-mac-', '^x-cp', '^cp\d+' )]
        [string]$Pattern,

        # specific pages?
        [ArgumentCompletions('65001', '1252')]
        [int]$CodePage,

        # Not yet used
        [hashtable]
        $Options

    )
    $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
        RegexMainEncoding = @(
            'utf-'
        )
    }

    switch ($SetName) {
        'Default' {
            $query = [Text.Encoding]::GetEncodings()
        }
        'Main' {
            $query = [Text.Encoding]::GetEncodings()
            | Where-Object {
                foreach ($regex in $Config.RegexMainEncoding) {
                    if ($_.Name -match $regex -or $_.DisplayName -match $regex) {
                        return $true
                    }
                }
                return $false
            }
        }
        'Fav' {
            $query = [Text.Encoding]::GetEncodings()
            | Where-Object {
                foreach ($regex in $__protoNin['FavEncodings']) {
                    if ($_.Name -match $regex -or $_.DisplayName -match $regex) {
                        return $true
                    }
                }
                return $false
            }
        }
        default {
            throw "UhandledSetName: '$SetName'"
        }
    }

    if ($Pattern) {

        $query = [Text.Encoding]::GetEncodings()
        | Where-Object {
            foreach ($regex in $__protoNin['FavEncodings']) {
                if ($_.Name -match $regex) {
                    return $true
                }
            }
            return $false
        }

    }
    if ($CodePage) {
        $Query = $query
        | Where-Object {
            $_.CodePage -eq $CodePage
        }
    }

    return $Query | Sort-Object -prop $SortBy
}
