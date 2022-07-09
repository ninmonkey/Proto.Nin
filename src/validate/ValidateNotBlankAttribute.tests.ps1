BeforeAll {
    $Source = $PSCommandPath -replace '\.tests.ps1$', '.ps1'
    . (Get-Item -ea stop $Source)
}

Describe 'ValidateNotBlankAttribute' {
    It 'Basic Invoke does not throw' {
        {
            function Foo {
                #no invoke
                [CmdletBinding()]
                param(
                    [ValidateNotBlank()]
                    [Parameter(Mandatory)]$Text
                )
            }
        } | Should -Not -Throw
    }
    It 'Invoke With Blank' -Tag 'ResearchBestWayToTest', 'UsingCustomAttribute' {
        function t0 {
            [cmdletbinding()]param(
                [ValidateNotBlank()]$Value
            )
            "'$Value'"
        }

        { t0 'notBlank' }
        | Should -Not -Throw -Because 'IsNotBlank'

        { t0 '' }
        | Should -Throw -Because '[String]::Empty'

        { t0 $Null }
        | Should -Throw -Because 'Literal $null value'
    }
}