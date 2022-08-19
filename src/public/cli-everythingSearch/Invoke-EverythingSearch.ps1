{
    $App = @{ Root = Get-Item . }
$BinEs = Get-Command 'C:\Program Files\Everything\Everything.exe'
$ExampleQuery = @{
    OneDriveLog = 'ext:odl;odlgz;odlsent;aold path:ww:"c:\"'
}
}
function Invoke-EverythingSearch {
    <#
    .synopsis
        minimal everything search commandline
    .LINK
        https://www.voidtools.com/support/everything/command_line_interface/
    #>
    [Alias('Es')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Query,


        [Parameter()]
        [switch]$WhatIf,

        [Parameter()]
        [hashtable]$Options = @{}
    )
    $Config = Join-Hashtable @{} ($Options ?? @{})
    $esArgs = @(
        $Query

    )

    # $esArgs | Join-String -Separator ' ' -op 'Everything.Exe'
    $esArgs | Join-String -Separator ' ' -op "Everything.Exe ${fg:yellow}"
    | Join-String -os "${fg:clear}"
    | Write-Information

    if ($WhatIf) {
        $esArgs | Join-String -Separator ' ' -op "Everything.Exe ${fg:yellow}"
        | Join-String -os "${fg:clear}"
        return
    }
    # $query = 'ext:odl;odlgz;odlsent;aold path:ww:"c:\"'

    & $BinEs @esArgs

}

# Invoke-EverythingSearch $ExampleQuery.OneDriveLog -WhatIf
