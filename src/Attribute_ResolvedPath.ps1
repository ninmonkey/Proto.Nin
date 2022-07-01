Using namespace System.Management.Automation
<#
intro on custom attributes:
- https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
- https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms/

- https://docs.microsoft.com/en-us/dotnet/standard/attributes/writing-custom-attributes#custom-attribute-example


> Retrieving Multiple Instances of an Attribute Applied to the Same Scope
https://docs.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes#retrieving-multiple-instances-of-an-attribute-applied-to-the-same-scope

cs: <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/generics-and-attributes>
        public class GenericClass2<T, U> { }

        [CustomAttribute(info = typeof(GenericClass2<,>))]
        class ClassB { }

#>

class StringToFileInfoTransformationAttribute : ArgumentTransformationAttribute {

    [object] Transform(
        [EngineIntrinsics] $EngineIntrinsics,
        [object] $InputData
    ) {
        $PathAsText = 'temp:\foo.log'
        $File = Get-Item $PathAsText -ea Ignore
        if ( -not $file) {
            $File = New-Item -Path $PathAsText -ItemType File -ea Ignore
            Write-Host -fore green $File.GetType().FullName
        }

        return $File
    }

}

function Test-Transform {
    param(
        [StringToFileInfoTransformationAttribute()]
        [string]$Filepath
    )
    $filepath | shortType
    $filepath
}

Test-Transform 'temp:\fake.log'

Hr -fg magenta
'hi' | sc temp:\fake.log
$PathAsText = 'temp:\fake.log'
$maybeItem = [StringToFileInfoTransformationAttribute()]$PathAsText
Hr -fg pink
$maybeItem | shortType
$maybeItem



class ResolvedFileInfo : Attribute {
    <#
    .synopsis
        ensures an [IO.FileInfo] object, even if file does not exist. optionally create it.
    .DESCRIPTION
        AssertExisting attribute?

        I could always return a [FileInfo]

        There was modes

        1] resolve file, else create it, or
        2] only error if the file doesn't exist

    new:
        default:
            resolve, silently error returning [IO.FileInfo]
        CreateMissing:
            create then get file info
        ErrorWhenMissing
            always throw exception when file does not exist

    #>
    [string]$Path = [string]::Empty

    # if false, create filepath
    [bool]$CreateMissing
    [bool]$ErrorIfMissing
    # [bool]$ErrorIfMissing
    [string] ToString() {
        # to refactor: renderAttributeAsDefined
        $render = @(
            '[ResolvedFileInfo('
            'CreateMissing'
            @(
                $this.CreateMissing ? '' : '=$false'
                $this.ErrorIfMissing ? '' : '=$false'
            ) -join ', '
            ')]'
        ) -join ''
        return $render
    }
}



function testIt {
    [cmdletbinding()]
    [outputtype('System.IO.FileInfo')]
    param(
        [ResolvedFileInfo(CreateMissing)]
        [Parameter()]
        $AlwaysCreatePath,

        # explicit bools for semantics in a demo
        [ResolvedFileInfo(CreateMissing = $false, ErrorIfMissing = $false)]
        [Parameter()]
        $WithoutErrorOrCreate,

        [ResolvedFileInfo()]
        [Parameter()]
        $ErrorIfMissingPath
    )
    [pscustomobject]@{
        CreateMissing              = '?'
        ErrorIfMissing             = '?'
        Path                       = '?'
        param_AlwaysCreatePath     = $AlwaysCreatePath
        param_WithoutErrorOrCreate = $WithoutErrorOrCreate
        param_ErrorIfMissing       = $ErrorIfMissingPath
    }
    # ErrorIfMissingPath = '?' #$ErrorIfMissingPath


    # AllowCreatePath    = '?' #$AllowCreatePath

    $null = 'no-op'
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