function Test-ShouldProcess {
    <#
    .synopsis
        Inject should-process into a pipeline, or test formatting of ShouldProcess
    .description
       the extra boilerplate is more of a documentation than useful item
       different hosts on the same machine can/will render shouldprocess and shouldconfirm, differently
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('?ShouldProcess')]
    [CmdletBinding(
        # SupportsPaging # future: paging should probably be split out
        ConfirmImpact = 'High', PositionalBinding = $false, SupportsShouldProcess)]
    param(
        # whether to use one condition for the the full pipeline, or iterate on every one
        [Parameter()]
        [switch]$TestEachItem,

        [Parameter()]
        [int]$TestMode = 1
    )

    begin {
        function _handleShouldProcess {
            param(
                [Parameter(Mandatory, Position = 0)]
                [int]$TestMode

            )
            $ProcessMode = $TestMode
            switch ($ShouldProcessMode) {
                1 {
                    if ($PSCmdlet.ShouldProcess(
                            <# target: #> $target)) {

                    }
                }
                2 {
                    if ($PSCmdlet.ShouldProcess(
                            <# target: #> $target,
                            <# action: #> $action)) {
                    }

                }


                3 {
                    if ($PSCmdlet.ShouldProcess(
                            <# verboseDescription: #> $verboseDescription,
                            <# verboseWarning: #> $verboseWarning,
                            <# caption: #> $caption)) {

                    }
                }
                4 {

                    if ($PSCmdlet.ShouldProcess(
                            <# verboseDescription: #> $verboseDescription,
                            <# verboseWarning: #> $verboseWarning,
                            <# caption: #> $caption,
                            <# shouldProcessReason: #> $shouldProcessReason)) {

                    }
                }
                default {

                }
            }
        }

        function _handleShouldConfirm {
            param(
                [Parameter(Mandatory, Position = 0)]
                [int]$TestMode

            )
            $ShouldContinueMode = $TestMode
            switch ($ShouldContinueMode) {
                1 {
                    if ($PSCmdlet.ShouldContinue(
                            <# query: #> $query,
                            <# caption: #> $caption)) {

                    }
                }
                2 {
                    if ($PSCmdlet.ShouldContinue(
                            <# query: #> $query,
                            <# caption: #> $caption,
                            <# yesToAll: #> $yesToAll,
                            <# noToAll: #> $noToAll) ) {

                    }
                }
                3 {

                    if ($PSCmdlet.ShouldContinue(
                            <# query: #> $query,
                            <# caption: #> $caption,
                            <# hasSecurityImpact: #> $hasSecurityImpact,
                            <# yesToAll: #> $yesToAll,
                            <# noToAll: #> $noToAll) ) {
                    }

                }
                default {
                }
            }
        }
        Write-Debug 'very wip'
    }
    # process {} #declaring will automatically exhaust '$Input'
    end {
        # function _parseResult {

        # }
        function _testOnce {
            if (Test-ShouldProcess) {
                $Input
            }
        }
        function _testEachItem {
            $input | Where-Object Test-ShouldProcess
        }

        if (! $TestEachItem) {
            _testOnce
        } else {
            _testEachItem
        }
        return
        # $PSCmdlet | Get-HelpFromTypeName

    }
}


# 0..1 | Where-Object {
#     Test-ShouldProcess -mode 1
# }