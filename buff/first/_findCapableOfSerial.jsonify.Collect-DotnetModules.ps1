Get-Module
| f 10


class SerialTestResult {
    [string]$Name = [string]::Empty
    [bool]$IsLong = $false
    [bool]$HasJsonWarning = $false
    hidden [string]$Json
    [int]$JsonLength = 0
    [object]$Instance = $null
}

function _propertyIsGood {
    param(
        # Input from $x.psobject.property
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSPropertyInfo]
        $Property,

        [int]$RenderMaxLength = 180
    )
    process {
        [string]$render = $_.Value | to->Json -wa ignore -ea ignore -Compress #| ? Length -lt $RenderMaxLength

        $test = [SerialTestResult]@{
            Name           = $Property.Name
            JsonLength     = $render.Length
            Json           = $render
            IsLong         = $render.Length -gt $RenderMaxLength
            Instance       = $Property
            HasJsonWarning = $false
        }

        try {
            $testWarning = $Property.Value | to->Json -Compress -WA Stop
        } catch {
            $test.HasJsonWarning = $true
        }

        return $test
    }
}
$props = (Get-Module)[0].psobject.properties

return
$props = (Get-Module)[0].psobject.properties
$props | _propertyIsGood | Select-Object -First 3
Write-Warning 'merge to jsonify'
function _findCapableOfSerial {

    <#
    .synopsis
        [1] see if serialization is abnormally long, [2] see if JSON depth warnings
    #>
    param(
        [int]$RenderMaxLength = 120
    )
    # [PSMemberInfoCollection<PSPropertyInfo>
    # $results = [list[object]]::new()
    (Get-Module)[0].psobject.properties | ForEach-Object {


    }
}
_findCapableOfSerial


function _exportModules {
    param(
        [switch]$IncludeEverything
    )

    $Path = 'default'

}

$Names = @{
    AllModuleProperties = @(
        'AccessMode'
        'Author'
        'ClrVersion'
        'CompanyName'
        'CompatiblePSEditions'
        'Copyright'
        'Definition'
        'Description'
        'DotNetFrameworkVersion'
        'ExperimentalFeatures'
        'ExportedAliases'
        'ExportedCmdlets'
        'ExportedCommands'
        'ExportedDscResources'
        'ExportedFormatFiles'
        'ExportedFunctions'
        'ExportedTypeFiles'
        'ExportedVariables'
        'FileList'
        'Guid'
        'HelpInfoUri'
        'IconUri'
        'ImplementingAssembly'
        'LicenseUri'
        'LogPipelineExecutionDetails'
        'ModuleBase'
        'ModuleList'
        'ModuleType'
        'Name'
        'NestedModules'
        'OnRemove'
        'Path'
        'PowerShellHostName'
        'PowerShellHostVersion'
        'PowerShellVersion'
        'Prefix'
        'PrivateData'
        'ProcessorArchitecture'
        'ProjectUri'
        'ReleaseNotes'
        'RepositorySourceLocation'
        'RequiredAssemblies'
        'RequiredModules'
        'RootModule'
        'Scripts'
        'SessionState'
        'Tags'
        'Version'
    )
}



H1 'done'
return

function _findCapableOfSerial_iter0 {
    (Get-Module)[0].psobject.properties | ForEach-Object {
        $render = $_.Value | to->Json -Compress -Depth 3 | Where-Object Length -LT 100
        if ($Render -lt 100) {
            Hr
            H1 $_.Name
            return $_.Name
        }

    }
}
_findCapableOfSerial_iter0
