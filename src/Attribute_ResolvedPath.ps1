# intro on custom attributes:
#     https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
#     https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms/

class ResolvedFilepath : Attribute {
    <#
    .synopsis
        ensures the path exists, else error
    .DESCRIPTION
        I could always return a [FileInfo]

        There's two modes

        1] resolve file, else create it, or

        2] only error if the file doesn't exist
    #>
    [string]$Path = [string]::Empty

    # if false, create filepath
    [bool]$ErrorIfMissing
}



function testIt {
    param(
        [ResolvedFilepath()]
        [Parameter()]
        $AllowCreatePath,

        [ResolvedFilepath(ErrorIfMissing)]
        [Parameter()]
        $ErrorIfMissingPath
    )
    [pscustomobject]@{
        AllowCreatePath    = $AllowCreatePath
        ErrorIfMissingPath = $ErrorIfMissingPath
    }
}

$Config = @{
    LogPath1 = 'temp:\fake.log'
}
Remove-Item $Config.LogPath1 -ea ignore

@(
    ig '[color], [state]'
    Get-Date
)
| Set-Content -Path $Config.LogPath1 -PassThru

testIt -errorIfMissingpath $Config.LogPath1
# Get-Content $Config.LogPath1