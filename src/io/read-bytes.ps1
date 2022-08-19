
function Get-BytesFromFileSync.Proto {
    <#
    .SYNOPSIS
    get the raw bytes of a file
    .description
        see: also

            [IO.File]
            | ForEach-Object{
                @($_ | Find-Member *read*); @($_ | Find-Member *file* ) }

    #>
    [Alias('bytes->FromFile')]
    param(
        [ValidateScript(
            {
                if( -not (Test-Path $_)){
                    throw "File does not exist"
                }
                return $True
            }
        )]
        [Parameter()]
        [string]$FileName
    )

    [IO.File]::ReadAllBytes((Get-Item -ea stop $File))
}
