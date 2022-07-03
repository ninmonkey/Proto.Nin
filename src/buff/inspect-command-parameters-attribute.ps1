function _pinfo {
    <#
    .SYNOPSIS
        really bad, inspect command's paramater's attributes
    # inspect parameters of commands using get-command
    .EXAMPLE
        Pwsh> @((gcm Get-ChildItem).pstypenames ; (gcm ls).pstypenames )
        | sort -Unique
        | convert 'type' | shortType -NoColor | sort | csv2 | cl

        # outputs:

        [AliasInfo], [CmdletInfo], [CommandInfo], [object]
    #>
    param(
        # NameOf?
        # todo:completer: add completer for attribute names
        # usually one of [AliasInfo], [CmdletInfo], [CommandInfo]
        [Parameter(Mandatory, position = 0)]
        [object]$CommandName = 'get-help',
        [Parameter(Mandatory, position = 1)]
        [string[]]$ParameterName = @('detailed', 'full')
    )
    $ParameterName | ForEach-Object {
        $ParameterName = $_;
        Write-ConsoleHeader $CommandName | Write-Information

        $cmdInfo = Get-Command $CommandName

        $cmdMeta = @{
            PSTypeName    = 'proto.nin.inspect.parameters.summary'
            CmdName       = $CommandName
            AllParameters = $CmdInfo.parameters
            Parameters    = @($ParameterName | ForEach-Object {
                    $cur = $_
                    try {
                        $CmdInfo.Parameters[$cur]
                    } catch {
                        Write-Error "not found:'$cur', $_ "
                    }
                }
            )
        }
        # ParameterMetadata
        $cmdMeta.'ParamAttributes' = $cmdMeta.AllParameters.GetEnumerator()
        | ForEach-Object {
            $Key = $_.Key
            $Value = $_.Value
            [System.Management.Automation.ParameterMetadata]$pValue = $_.Value
            $_.Value -is 'ParameterMetadata' | Join-String -op 'Should be of type ' | Write-Debug
            return $pValue
        }

        <#
            > $cmdMeta.ParamAttributes | % Attributes | % typeid | % fullname | sort -Unique
                System.Management.Automation.AliasAttribute
                System.Management.Automation.Internal.CommonParameters+ValidateVariableName

            # https://github.com/PowerShell/PowerShell/blob/b5277c0fb771edca57e98b0ebb6faa1ad256f852/src/System.Management.Automation/engine/CommonCommandParameters.cs#L239
        #>


        # ($cmdMeta.Parameters | ForEach-Object { $_ } ) # redundant unroll?
        # # $cmdMeta.'ParamAttributes' = $cmdMeta.Parameters | %{
        # $sfd = ForEach-Object {
        #     # ($cmdMeta.Parameters| %{ $_ } ) # redundant unroll?
        #     [pscustomobject]@{
        #         Name = ''
        #     }
        #     $cmdMeta.Parameters[0].Attributes

        # }
        [pscustomobject]$cmdMeta

    }
}


$Pinfo = _pinfo 'Get-Help' 'Detailed', 'Full', 'example'
$Pinfo | Format-List

# (Get-Command Get-Help).Parameters[$name]
# | Add-Member -NotePropertyName 'Command' -NotePropertyValue $Name -PassThru
# _compareParam
# ( Get-Command Get-Help).Parameters[$name].Attributes
# }



function _pinfo_minimal {
    {
        # some inspection of parameters
        param( [string[]]$NameList )
        $NameList | ForEach-Object
        $Name = $_; Write-ConsoleHeader $name;
        ( Get-Command Get-Help).Parameters[$name]
        ( Get-Command Get-Help).Parameters[$name].Attributes
    }
}

