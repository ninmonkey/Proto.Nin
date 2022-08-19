$target = Get-Item -ea stop 'C:\nin_temp\temp_fetch\PowerShellNotebook\markdownExamples\multiplePSLines.ipynb'
@'
# see more:
        int Read()
        int Read(char[] buffer, int index, int count)
        int Read(System.Span[char] buffer)


'@

$allBytes = [IO.File]::ReadAllBytes((Get-Item $Target).FullName)
$allBytes[0..10] | ForEach-Object { '{0:x}' -f $_ }

& {
    # Touch -Path 'temp:\iwr.ipynb' -ea ignore
    # $script:DestPath = Get-Item 'temp:\iwr.ipynb' -ea stop
    # $Response = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/dfinke/PowerShellNotebook/master/MarkdownExamples/multiplePSLines.ipynb'
    # $Stream = [System.IO.StreamWriter]::new($DestPath.FullName, $false, $Response.Encoding)
    return
    try {
        $bStream = [IO.StreamReader]::new($Target.FullName)
        $x = 120
        # $bStream.

        'worked'
    } catch {
        throw  "File could not be read: ${_}"

    } finally {
        $bStream.Dispose()
    }
}


& {
    'do stuff '
}