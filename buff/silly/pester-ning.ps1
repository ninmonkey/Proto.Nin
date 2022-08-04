$PesterConfig = New-PesterConfiguration

$PesterConfig.Output.StackTraceVerbosity = 'FirstLine' # None, FirstLine, Filtered and Full [def: filtered]
$PesterConfig.Output.Verbosity = 'Detailed' # None, Normal, Detailed, Diagnostic [def: normal]


$PesterConfig.Run.PassThru = $true
$PesterConfig.run.SkipRemainingOnFailure = 'None' # None, Run, Container and Block. [def: None]


if ($false) {
    #$res = Invoke-Pester -Configuration $PesterConfig |
    # actual invoke
    $res = Invoke-Pester -Configuration $PesterConfig

}