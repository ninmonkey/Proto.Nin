function Invoke-GHRepoClone.Proto {
    <#
    .synopsis
        just gh repo clone a bunch. no error detection yet ; no should process yet.
    .synopsis
        invokes 'gh repo list' and  dynamically generates property names
    .description
        it's sugar for using json properties '--json <propertyList>'
    .notes
        future: [ArgumentCompletions( _enumGhProperty )]
    .link
        https://cli.github.com/manual
    .link
        Ninmonkey.Console\Out-Fzf
    .link
        Ninmonkey.Console\_enumerateGhProperty
    .link
        https://cli.github.com/manual/gh_help_formatting
    .link
        https://github.blog/2021-03-11-scripting-with-github-cli/
    #>
    # [RequiresCommandAttribute('Name' = 'gh', 'optional' = $false)] # future metadata attribute
    [Alias('gh->RepoList.Proto')] # forgive me, for my verbing naming sins
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Owner Name
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompletions(
            'JustinGrote', 'SeeminglyScience',
            'IndentedAutomation',
            'dfinke', 'EvotecIT', 'IISResetMe',
            'Ninmonkey', 'Jaykul', 'StartAutomating'
        )]
        [string]$OwnerName,

        # repo list name
        [Parameter(Mandatory, Position = 1)]
        [string[]]$RepoNames,

        # clone relative here, skip the subdir
        [switch]$WithoutSubdirOwner
    )
    $Failed = [list[object]]::new()

    foreach ($Repo in $RepoNames) {
        try {
            # if ($PSCmdlet.ShouldProcess("$Repo", "$Owner")) {

            if (-not $WithoutSubdir) {
                # $dest = Join-Path $OwnerName $Repo
                'gh repo clone $OwnerName/$Repo $OwnerName/$Repo'
                | Write-Verbose
                & gh repo clone $OwnerName/$Repo $OwnerName/$Repo
            } else {
                'gh repo clone $OwnerName/$Repo $OwnerName/$Repo'
                | Write-Verbose
                & gh repo clone $OwnerName/$Repo
            }
            $LongText = @(
                gh repo clone
            ) -join "`n"
            $caption = "$OwnerName/$Repo"
            $warning = 'to: "{0}"' -f @(
                Get-Item . | ForEach-Object FullName
            )
            $null = $PSCmdlet.ShouldProcess(
                'Cloning Repos',
                'warning',
                'caption'
            )

            # }

        } catch {
            $failed += @($x)
            $dbg = @{
                Owner      = $Owner
                Repo       = $Repo
                MaybeError = $error[0]
            }
            $Failed.add( $dbg )
        }
    }
    $RepoNames -join ', '
    | Label 'Attempted Clones: ' | Write-Host

    Label 'Errors' $failed.count | Write-Host
    return $failed
}

$exportModuleMemberSplat = @{
    Function = @(

        'Invoke-GHRepoClone.Proto'
    )
    Variable = @()
    # Cmdlet = @()
    Alias    = @(
        'gh->RepoList.Proto'
    )
}

Export-ModuleMember @exportModuleMemberSplat
