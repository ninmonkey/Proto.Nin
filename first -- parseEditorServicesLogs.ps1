$Regex = @{}
#  New-ADUser -name $gebruiker -DisplayName $Gebruiker -GivenName 'dsfsd'


# $sess = @'
# {"status":"started","languageServiceTransport":"NamedPipe","languageServicePipeName":"\\\\.\\pipe\\PSES_ivsz0u0s.v2g","debugServiceTransport":"NamedPipe","debugServicePipeName":"\\\\.\\pipe\\PSES_baurejod.uvy"}
# '@ | from->Json
# Get-Item $sess.languageServicePipeName


$bin7z = gcm -CommandType Application '7z' | s -first 1
$args7z = @(
    'i'
)

& $bin7z @args7z | %{
    $row = $_
    $_ -replace '\s{2,}', '🙊' -replace '\s+', '🐱' -replace '\d+', {
        $PSStyle.Background.Green()
    }

    # "Item: $row"
}
#  | cl
# (7z i) -split '\r?\n' | %{



return
$Named = @{
    MaybeConf   = Get-Item -ea ignore 'c:\Users\cppmo_000\AppData\Roaming\Code\User\globalStorage\ms-vscode.powershell-preview\sessions\PSES-VSCode-37080-273303.json'
    Pipe1       = Get-Item -ea ignore '\\.\pipe\PSES_ivsz0u0s.v2g'
    LangService = Get-Item -ea ignore '\\\\.\\pipe\\PSES_ivsz0u0s.v2g'

}
Write-Warning 'sci: can I pipe listen? in response to <https://discord.com/channels/180528040881815552/446531919644065804/1008134998882254860>'

throw 'left off here,
    datetime regex fails ->
        it''s a multil line log, so fetch all lines up to the next datetime
'
<#
view log using:

    PS> gc $curLog | bat -l json
#>
# $error.Clear()



function _find-newestEditorServicesLog {
    [OutputType('System.IO.FileInfo')]
    [CmdletBinding()]
    param()
    # currently just preview
    $splatFindItem = @{
        Recurse = $true
        Path    = "${Env:AppData}\Code\User\globalStorage\ms-vscode.powershell-preview\logs\"
        Filter  = 'EditorServices.log'
    }

    $query = Get-ChildItem @splatFindItem | Sort-Object LastWriteTime -desc | Select-Object -First 1
    if ($query.count -ne 1) {
        throw 'OneOrNoneFailed'
    }
    $query | Join-String -op 'Found: ' -DoubleQuote FullName | Write-Information
    $query
}
$Regex.LogLine = @'
(?x)
(?<Prefix>.*?)(?<Rest>\{.*$)
'@
$curLog = _find-newestEditorServicesLog -infa 'continue'

class parsedLog {
    [string]$LineNumber

    [AllowNull()]
    [datetime]$Date

    [bool]$IsMatch
    [string]$ShortDisplayString = ''

    [AllowNull()]
    [object]$Data

    [string]$RawString
    # [string]$DataShortString = ''
}
# 1660432916-846dd07f-8b80-48da-b89f-186d382dabda1660432366858\EditorServices.log'"
function _parse-EditorServicesLog {
    [cmdletBInding()]
    param()

    $curLine = 0
    Get-Content $curLog | ForEach-Object {
        try {
            $maybeDate = Get-Date
            # $maybeDate = [datetime](($_ -split ' ', 4 | Select-Object -First 3) -join ' ')
        } catch {
            $maybeDate = $Null
            $maybeDate = Get-Date
        }
        $maybeData = "[`u{2400}]" # $Null
        $shortLine = $_
        if ($_ -match $Regex.LogLine) {
            $maybePrefix = ($matches.Prefix)?.tostring() ?? ''
            $Rest = ($matches.Rest)?.tostring() ?? ''
            $maybeData = $Rest

            if ( -not [string]::IsNullOrWhiteSpace($MaybeData)) {
                try {
                    $MaybeData = $MaybeData | from->Json
                } catch {
                    $MaybeData = $Null
                }

            }
            # if ( -not [string]::IsNullOrWhiteSpace($MaybeData)) {
            #     try {  '{@(  [pscustomobject]@{ Key = $_.key; Value = $_.value | s …'  | from->Json } catch { 'no' }
            #     $maybeData = $maybeData | ConvertFrom-Json -ea ignore
            # }
        }
        $record = @{
            RawString       = $_
            Data            = $maybeData
            IsMatch         = -not ($null -eq $maybeData)
            LineNumber      = $curLine++
            DataShortString = $maybeData
            Date            = $maybeDate
        }
        [pscustomobject]$record
    }
}
function _formatShortStr {
    <#
    .notes
        goal, make it super easy to pipe to my command that displays properties shortened

            h1 'default, some props are too long'

        this almost works, except a couple which are breaking the column for all
            ls env: | ft -autosize

        Goal Invoke
            ls env: | _formatSHortStr -prop 'Value' -passThru | ft -AutoSize
            ls env: | _formatSHortStr -prop 'Value' -passThru | fl * -force

        Sugar for
            ls env: | %{
            @(
                [pscustomobject]@{
                    Key = $_.key
                    Value = $_.value | shortStr -HeadCount 40 -TailCount 10
                }
            )
            } | Ft -AutoSize

    #>
}


'z'..'a' -join '_'
'z'..'a' -join '_' | shortStr
'z'..'a' -join '_' | shortStr -HeadCount 3 -TailCount 3
if ($True) {
    $Color = @{
        Fg    = $PSStyle.Foreground.FromRgb('#c6b8e9')
        FgDim = $PSStyle.Foreground.FromRgb('#dbcfff')

        Reset = $PSStyle.Reset
    }

    Get-Process | ForEach-Object name | shortStr -Options @{
        AlwaysQuoteInner = $False ;
        TotalPrefix      = $Color.Fg;
        TotalSuffix      = $Color.Reset;
        Separator        = @(
            $Color.Reset
            $Color.FgDim
            '...'
            $Color.Reset
            $Color.Fg
        ) -join ''
    }
}



# $log_lines = Get-Content (Get-Item 'c:\Users\cppmo_000\AppData\Roaming\Code\User\globalStorage\ms-vscode.powershell-preview\logs\1660432916-846dd07f-8b80-48da-b89f-186d382dabda1660432366858\EditorServices.log')
$records = _parse-EditorServicesLog #-ea break
$records
$records | Format-Table LineNumber, IsMatch, Data, RawString


'z'..'a' -join '_'
'z'..'a' -join '_' | shortStr
'z'..'a' -join '_' | shortStr -HeadCount 3 -TailCount 3

h1 'done'
return

