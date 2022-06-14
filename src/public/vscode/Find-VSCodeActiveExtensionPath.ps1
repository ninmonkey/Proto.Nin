function Find-VSCodeActiveExtensionPath {
    <#
    .synopsis
        find current extension based on write times
    .example
        Find-VSCodeActiveExtensionPath
        Find-VSCodeActiveExtensionPath -ListAll
    .NOTES
        I thought 'LastAccessTime' would actually give better results
        but it was giving the wrong paths. modified was more accurate in my tests.
        maybe if recursion was used.

        PS>
            # recursion like this ended up giving the same max values, even though I have one of
            the two extensions disabled.
            $allPwshExtensions = Get-ChildItem "$Env:UserProfile/.vscode/extensions" 'ms-vscode.powershell*'
            $allPwshExtensions | %{
                ls . -Depth 3 | Measure-Object -Property LastWriteTime -Maximum | ft
            }

            Count Average Sum Maximum               Minimum StandardDeviation Property
            ----- ------- --- -------               ------- ----------------- --------
            27             6/14/2022 10:27:29 AM                           LastWriteTime
            27             6/14/2022 10:27:29 AM                           LastAccessTime


            Count Average Sum Maximum               Minimum StandardDeviation Property
            ----- ------- --- -------               ------- ----------------- --------
            27             6/14/2022 10:27:29 AM                           LastWriteTime
            27             6/14/2022 10:27:29 AM                           LastAccessTime
    #>
    [Alias('Find-VSCode.ActiveExtensionPath')]
    [OutputType('System.IO.FileSystemInfo')]
    [Cmdletbinding()]
    param(
        # Instead, list all extension paths
        [Alias('All')]
        [parameter()][switch]$ListAll
    )
    $query = Get-ChildItem "$Env:UserProfile/.vscode/extensions" 'ms-vscode.powershell*'
    | Sort-Object LastWriteTime -Descending

    if ($ListAll) {
        return $query
    }

    $query | Select-Object -First 1
    return


    # | & { # I thought you could conditonally branch like this?
    #     if ($ListAll) {
    #         return $_
    #     }
    #     $_ | Select-Object -First 1
    # }
}


