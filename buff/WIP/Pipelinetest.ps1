Set-PSReadLineOption -AddToHistoryHandler {
    param($Script)
    $regex = '\s*\.\s*\"(?<File>.*)\"'
    return ($Script -notmatch $regex)
}

$C = $Colors = Ninmonkey.Console\Join-Hashtable -BaseHash @{

} -OtherHash ($Colors ?? @{})
$C
throw 'left off here'
function Show-Pipeline {
    begin {
        'ShowPipeline -> Begin -> {0,2}.{1,2}' -f @(
            $MyInvocation.PipelinePosition, $MyInvocation.PipelineLength
        )

        Write-ConsoleColorZd
    }
}



