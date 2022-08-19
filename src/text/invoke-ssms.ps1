$DocString = @'
Ssms
    [scriptfile] [projectfile] [solutionfile]

    [-S servername] [-d databasename] [-G] [-U username] [-E] [-nosplash] [-log [filename]?] [-?]

see:

    https://docs.microsoft.com/en-us/sql/ssms/ssms-utility?view=sql-server-ver16
    https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-external-tools-register
    https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-external-tools

Run this for more:

    Sssms.exe -?

scriptfile Specifies one or more script files to open. The parameter must contain the full path to the files.

projectfile Specifies a script project to open. The parameter must contain the full path to the script project file.

solutionfile Specifies a solution to open. The parameter must contain the full path to the solution file.
'@
$fullPath = Get-Item 'E:\SQL-Server\Microsoft SQL Server Management Studio 18\Common7\IDE\SSms.exe'
$binSSMS = Get-Command $fullPath -CommandType Application -ea stop
$ServerName = 'localhost:2849'
$LogPath = Get-Item 'temp:\ssms-invoke.log'


$Conf = @{
    ServerName = $ServerName
    LogPath    = Get-Item 'temp:\ssms-invoke.log'
}

Get-Content $COnf.LogPath

Write-Warning '
    two attrs
        [1] nyi, die if invoked
        [2] exclusive parametersets
'

class NotImplementedParameter : Attribute {
    <#
    .synopsis
    sf
    .DESCRIPTION
    intro on custom attributes:
        https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
        https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms/
    #>
    [string]$Reason = [string]::Empty
    [bool]$AllowIgnore # IsNotFatal
}
function Invoke-SSMS {
    <#
    .SYNOPSIS
        launch SSMS connection to PowerBI
    .notes
        exact order from docs
            [scriptfile] [projectfile] [solutionfile]
        [-S servername] [-d databasename] [-G] [-U username] [-E] [-nosplash] [-log [filename]?] [-?]

    #>
    [Alias('SSMS')]
    [cmdletbinding()]
    param(
        [NotImplementedParameter(Reason = 'sdf', AllowIgnore)]
        [Parameter()]
        [string]$ScriptFile,


        # for [ -S servername ]
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompletions('localhost:1234', 'NIN8\SQL2019')]
        [string]$ServerName,

        # for [ -d databasename ], aka instance name?
        # [Alias('Db')]
        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompletions('SQL2019', 'master')]
        [string]$DatabaseName,

        # for [ -U username ], aka instance name?
        [Alias('UserSQL')]
        [ArgumentCompletions('nin8\cppmo_000')]
        [string]$SQLAuthUsername,

        # for [ -E ] windows implicit auth
        [Alias('U')]
        #
        [switch]$WindowsAuth,


        # [Parameter()]

        # for [ -log [filename]?]  servername ]
        # 'temp:\ssms-invoke.log'
        [Parameter()]
        [string]$LogPath = 'temp:\ssms-invoke.log',


        # show sommand line to run, does not execute
        [Alias('WhatIf')]
        [switch]$TestOnly,

        # help
        [switch]$Help
    )
    $ResolvedLog = Get-Item $LogPath -ea ignore
    if ( -not $ResolvedLog ) {
        $ResolvedLog = New-Item -Path $LogPath -ItemType File
    }

    $ResolvedLog | Write-Debug


    if ($Help) {
        return $DocString
    }
    $binSSMS = Get-Command $fullPath -CommandType Application -ea SilentlyContinue
    if ( -not $BinSSMS ) {
        throw " Path to SSMS was not valid: '$fullPath'"
    }

    [object[]]$CmdArgs = @()

    if ($TestOnly) {
        $cmdArgs | Join-String -sep ' ' -op 'ssms.exe '
        return
    }

    $cmdArgs | Join-String -sep ' ' -op "$($BinSSMS) "
    | Write-Information
    & $binSSMS @cmdArgs
}
$cmdArgs = @(
    '-S', $ServerName
    '-log'
    $LogPath
)

Invoke-SSMS -Test -ServerName 'NIN8\SQL2019' -DatabaseName 'SQL2019' -WindowsAuth -SQLAuthUsername 'nin8\cppmo_000'
# $cmdArgs = @(
#     if($Conf.ServerName) {
#         '-S'
#         $Conf.ServerName
#     }
#     if(
# )


$FullPath | Get-Item | ForEach-Object FullName

# & $binSSMS @cmdArgs
# & $BinSSMS @('-?')