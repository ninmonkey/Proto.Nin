using namespace System.Collections.Generic

$ExampleConfig = @{
    RootDir = Get-Item -ea stop 'H:\datasource_staging_area\2022-06\vscode-cur\pq-memory-timeout-2022-06-25_10_18\20220625T100018\exthost1\output_logging_20220625T100032'
}

Push-Location -StackName 'inline.util' $ExampleConfig.RootDir

function _processRipgrepResult {
    <#
    .SYNOPSIS
        convert ripgreps output to powershell objects
    .EXAMPLE
        PS> $cachedJson ??= rg memory --json
            $parsed = $cachedJson | _processRipgrepResult
    #>
    [CmdletBinding()]
    param(
        [AllowNull()]
        [Parameter(ValueFromPipeline)]
        [string]$InputText
    )
    begin {
        $curIndex = 0
    }
    process {
        if ($null -eq $InputText) {
            return
        }
        $InputText -split '\r?\n'
        | ForEach-Object {
            $Line = $_
            if ( [string]::IsNullOrWhiteSpace($InputText) ) {
                return
            }
            try {
                $addMemberSplat = @{
                    NotePropertyName  = 'Index'
                    NotePropertyValue = $curIndex++
                    PassThru          = $true
                    TypeName          = 'logs.parsedRipgGrepResult'
                }

                $Line | ConvertFrom-Json -ea stop
                | Add-Member @addMemberSplat
            } catch {
                Write-Error "Failed parsing line as Json doc: '$Line'" -ea continue
            }
        }

    }
}
<#
    console rendering of example

    begin   @{path=}                                                                                     0
    match   @{path=; lines=; line_number=27471; absolute_offset=798137; submatches=System.Object[]}      1
    match   @{path=; lines=; line_number=63959; absolute_offset=3125145; submatches=System.Object[]}     9
    end     @{path=; binary_offset=; stats=}                                                            10
    summary @{elapsed_total=; stats=}                                                                   11

#>
class RipGrepResultRecord {
    <#

    converts a single-line of json to an object

    example input:
        {"type":"match","data":{"path":{"text":"17-Power Query.log"},"lines":{"text":"FATAL ERROR: NewSpace::Rebalance Allocation failed - JavaScript heap out of memory\r\n"},"line_number":28601,"absolute_offset":835596,"submatches":[{"match":{"text":"memory"},"start":76,"end":82}]}}

    #>
    [ValidateSet('begin', 'end', 'match', 'summary')]
    [string]$Type
    [object]$Data
    [int]$Index = 0
    hidden [string]$RawJson = [String]::Empty  # disable if memory intensive

    RipGrepResultRecord(
        [object]$Type, [object]$Data, [int]$Index
    ) {
        $this.Type = $Type
        $this.Data = $Data
        $this.Index = $Index
    }
    # RipGrepResultRecord( [string]$JsonDoc) {
    # $this.RipGrepResultRecord::New( $JsonDoc, 0 )
    # }

    RipGrepResultRecord( [string]$JsonDoc, [int]$Index) {
        # $This.RipG
        $this.Index = $Index
        $This.RawJson = if ($true) {
            #
            $this.RawJson = $JsonDoc
        } else {
            [string]::Empty
        }

        try {
            $Obj = $JsonDoc | ConvertFrom-Json -ea stop
            $this.Type = $Obj.Type
            $This.Data = $Obj.Data
            $this.Index = $Index
        } catch {
            Write-Error "Failed parsing line as Json doc: '$JsonDoc'" -ea 'continue'
        }

        # Add argument validation logic here
    }

}

# $this.Devices[$slot] = $dev
#      if ( [string]::IsNullOrWhiteSpace($InputText) ) {
#             return
#         }


class ListGrepResultGroup {
    # [object]$Begin = $null
    # [list[object]]$Records = [list[object]]::new()
    # [object]$End = $Null
    # [object]$Summary = $Null

    # # function RipGrepResultGroup

    # function [object[]] Results() {
    #     return $this.Records
    # }

    # [string]ToString(){
    #     return ("{0}|{1}|{2}" -f $this.Brand, $this.Model, $this.VendorSku)
    # }
}
write-warning 'of course I needlessly classified it'
$cachedJson ??= rg memory --json
$parsed = $cachedJson | _processRipgrepResult

$firstMatch = $cachedJson | s -First 1 -Skip 1

Hr
$parsed.count
$parsed
Hr
$firstMatch
Hr
[RipGrepResultRecord]::new( $JsonText )


[RipGrepResultRecord]::new( $JsonText, 5 )