using namespace System.Management.Automation

class ValidateNotBlankAttribute : ValidateArgumentsAttribute {
    <#
    .synopsis
        minimum sugar to prevent whitespace
    .NOTES
    future parameters:
        - Allow [String]::Empty
        - Allow exactly $Null literal
        - Allow whitespace without ansi control codes
    .LINK
        Ninmonkey.Console\Format-RemoveAnsiEscape
    #>
    [void] Validate(
        [object] $arguments,
        [EngineIntrinsics] $engineIntrinsics
    ) {
        if ( [string]::IsNullOrWhiteSpace($Arguments)) {
            throw 'Value Must not be Blank ($null, empty, or whitespace'
        }
    }
}