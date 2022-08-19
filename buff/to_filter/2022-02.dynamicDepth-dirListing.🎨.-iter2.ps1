$ConfigRun = @{
    '01_minimal'      = $false
    '02_minimal'      = $false
    '03_append_stack' = $true
}
$Config = @{
    LimitRoot  = 15
    LimitTier1 = 7
    RootDir    = @(
        # gi 'c:\nin_temp'
        Get-Item 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Ninmonkey.Console'
    )
}
Set-Alias 'Write-Color' Write-ConsoleColorZd

$PSDefaultParameterValues['Format-IndentText:IndentString'] = '  '
$PSDefaultParameterValues['Format-IndentText:IndentString'] = '  '
$PSDefaultParameterValues['Format-IndentText:IndentString'] = '┐'
| Write-Color magenta -bg 'gray15'


$Color = @{
    <#
    hsl(42, 38%, 60%)
    xyz(38.9635, 40.7973, 21.7407)
    c0a972
    #>
    'Folder'         = '#ffe097'
    'FillBGDark'     = ' ' | Write-Color -fg gray10 -bg gray15
    'FillBgDarkAlt'  = "${fg:gray10}${bg:gray15}"
    'FillBgDarkAlt2' = @(
        $PSStyle.Foreground.FromRgb(255 / 10, 255 / 10, 255 / 10)
        $PSStyle.Background.FromRgb(255 * .15, 255 * .15, 255 * .25)
    ) -join ''
}

$Color.Values | ForEach-Object { $_ | Format-ControlChar }
# | str hr



function InvokeDynamicFormatTest {
    <#
        .synopsis
            .
        .notes
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        [Alias('PSPath', 'Path', 'RootDirectory')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{

        }

        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        $RootDir = Get-Item -ea stop $InputObject
        # got 3 themes now tgo run it on

        Push-Location (Join-Path $Config.RootDir '..')
        H1 "$($Config.RootDir)"
        $depth = 0

        $parents = Get-ChildItem $Config.RootDir -Directory
        | Select-Object -First $Config.LimitRoot

        $LabelRootName = Get-Item $Config.RootDir | To->RelativePath
        $LabelRootName
        $depth++
        # $depth = 1
        $depth++
        $parents | ForEach-Object {
            $curPar = $_
            # TierN -> part1] show folders
            $labelCurrentLocation = $curPar | To->RelativePath
            $labelCurrentLocation = $curPar.Name
            $labelCurrentLocation
            | Write-Color -fg $Color.Folder
            | Format-IndentText $depth



            # either recurse or end
            $depth++

            $filesN = Get-ChildItem -Path $curPar -File -Force
            | Select-Object -First $Config.LimitTier1


            $filesN
            | To->RelativePath
            | Format-IndentText $depth

            Br
            $depth--


            # TierN -> part2] files

            # Get-Item .


            # $curPar.Name
            # | Format-IndentText $depth

            # 6$depth++
            # Get-ChildItem $curParent | ForEach-Object Name
            # | Format-IndentText $depth
            # $depth--

        }
        $depth--
    }


    end {
    }
}


# & {
$TestConfigList = @(

    @{
        Label        = 'all defaults'
        Description  = 'first test desc background'
        FunctionArgs = @{
            'RootDir' = $Config.RootDir

        }
    }
    @{

        Label        = ''
        Description  = ''
        FunctionArgs = @{
            'RootDir'            = $Config.RootDir

            'FormatIndentString' = '␠␠'
            | Write-Color -fg 'gray40' -bg 'gray20'

        }
    }
    @{

        Label        = ''
        Description  = ''
        FunctionArgs = @{
            'RootDir'            = $Config.RootDir

            'FormatIndentString' = '  '
            | Write-Color -fg 'gray10' -bg 'gray15'

        }
    }
) | ForEach-Object { [pscustomobject]$_ } | Add-IndexProperty

$TestConfigList
