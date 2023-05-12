

function findParameterHelp {
    # ex: gcm sls | findParameterHelp -ParameterName 'culture' | fl *
    # Very important to use "Get-Help" not "Help"
    param(
        # name, or instance
        [Parameter(Mandatory, ValueFromPipeline)][object]$InputCommand,

        # regex to find matching names
        [string]$ParameterName )
    process {
        $cmd = Get-Command $InputCommand -ea stop
        $h_info = $cmd | Get-Help
        $h_info.parameters.parameter
        | Where-Object Name -Match $ParameterName
    }
}