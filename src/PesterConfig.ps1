$RunNamed = @{
    'integrationFromDocs' = $false
    'Basic_NotBlank'      = $True
}

if ($RunNamed.Basic_NotBlank) {
    H1 'Basic_NotBlank'
    $MyOptions = @{
        Run    = @{ # Run configuration.
            PassThru                 = $true # Return result object after finishing the test run.
            # 'Container' = @{}
            # 'ExcludePath' = @{}
            # 'Exit' = @{}
            # 'PassThru' = @{}
            # 'Path' = @{}
            # 'ScriptBlock' = @{}
            'SkipRemainingOnFailure' = 'Block' # [None, Run, Container and Block]
        }
        # 'SkipRun' = @{}
        # 'TestExtension' = @{}
        # 'Throw' = @{}
        # Path        = @{}
        # ExcludePath = @{}
        # Container   = @{}
        Output = @{
            # CIFormat = @{}
            Verbosity           = 'detailed' # [None, Normal, Detailed and Diagnostic]
            StackTraceVerbosity = 'FirstLine' # [None, FirstLine, Filtered and Full]
            # StackTraceVerbosity = 'Filtered' # [None, FirstLine, Filtered and Full]
        }
        Filter = @{ # Filter configuration
            Tag = 'none'
            # ExcludeTag = @{}
            # Line = @{}
            # ExcludeLine = @{}
            # FullName = @{}
        }

    }
    $PesterConfig = New-PesterConfiguration -Hashtable $MyOptions
    Invoke-Pester -Configuration $PesterConfig -ov 'lastInvokePester'

    Label 'SavedResultsToVar' (NameOf { $lastInvokePester })
}


if ($RunNamed.integrationFromDocs) {
    & {
        H1 'invoke Integration'
        $MyOptions = @{
            Run    = @{ # Run configuration.
                PassThru = $true # Return result object after finishing the test run.
            }
            Output = @{
                Verbosity = 'detailed'
            }
            Filter = @{ # Filter configuration
                Tag = 'Core', 'Integration' # Run only Describe/Context/It-blocks with 'Core' or 'Integration' tags
            }
        }

        $PesterConfig = New-PesterConfiguration -Hashtable $MyOptions

        Invoke-Pester -Configuration $PesterConfig
    }
}