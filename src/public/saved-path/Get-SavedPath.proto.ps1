class SavedPath {
    [string]$Label
    [string]$Path
    [string]$Description
    [string[]]$Tags = @()
}
function _genSavedPaths {
    <#
     from: https://docs.tabulareditor.com/te2/Advanced-features.html#in-programdatatabulareditor
     #>
    $Top = @{}
    $Top.TabularEditor = @(
        [SavedPath]::new(
            <# Label #> 'BPARules',
            <# Path  #> (Join-Path $Env:ProgramData 'TabularEditor/BPARules.json'),
            <# Desc  #> 'rules for all users'
        )
        [SavedPath]::new(
            <# Label #> 'TOMWrapper.dll',
            <# Path  #> (Join-Path $Env:ProgramData 'TabularEditor/TOMWrapper.dll'),
            <# Desc  #> 'usable in your .net projects'
        )
        [SavedPath]::new(
            <# Label #> 'Preferences.json',
            <# Path  #> (Join-Path $Env:ProgramData 'TabularEditor/Preferences.json'),
            <# Desc  #> 'usable in your .net projects'
        )
    )
    Write-Warning "Paths not finished: $PSCommandPath , from <https://docs.tabulareditor.com/te2/Advanced-features.html#in-programdatatabulareditor> "
}


function Get-SavedPath.proto {
    [CmdletBinding()]
    param()

    _genSavedPaths

}