<#
intro on custom attributes:
- https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
- https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms/

- https://docs.microsoft.com/en-us/dotnet/standard/attributes/writing-custom-attributes#custom-attribute-example


cs: <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/generics-and-attributes>
        public class GenericClass2<T, U> { }

        [CustomAttribute(info = typeof(GenericClass2<,>))]
        class ClassB { }

#>
class ResolvedFileInfo : Attribute {
    <#
    .synopsis
        ensures an [IO.FileInfo] object, even if file does not exist. optionally create it.
    .DESCRIPTION
        I could always return a [FileInfo]

        There's two modes

        1] resolve file, else create it, or

        2] only error if the file doesn't exist
    #>
    [string]$Path = [string]::Empty

    # if false, create filepath
    [bool]$CreateMissing
    [bool]$ErrorIfMissing
    # [bool]$ErrorIfMissing
}



function testIt {
    [cmdletbinding()]
    [outputtype('System.IO.FileInfo')]
    param(
        [ResolvedFileInfo(CreateMissing)]
        [Parameter()]
        $AlwaysCreatePath,

        [ResolvedFileInfo()]
        [Parameter()]
        $ErrorIfMissingPath
    )
    [pscustomobject]@{
        CreateMissing  = '?'
        ErrorIfMissing = '?'
        Path           = '?'
        # AllowCreatePath    = '?' #$AllowCreatePath
        # ErrorIfMissingPath = '?' #$ErrorIfMissingPath
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