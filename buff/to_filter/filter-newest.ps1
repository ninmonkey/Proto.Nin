

Goto (Get-Item "$Env:AppData\code\logs")
$IgnoreRegex = Join-Regex -Regex 'git', 'python', 'json' # auto escapes

fd --changed-within 10minutes --search-path (Get-Item "$Env:AppData\code\logs")
| Get-Item
| Where-Object Name -NotMatch $IgnoreRegex
| Sort-Object LastWriteTime
| To->RelativePath $Env:AppData
| fzf.exe -m --preview 'bat --style=snip,header,numbers --line-range=:200 {}'

@'
    - move to the log folder, and search using env vars
    - resolves `fd`'s text paths to [IO.FileInfo] objects
    - which allows filtering by date, filepaths, etc


'@

#| batPreview
#| gi
#| sort LastWriteTime
f




Goto (Get-Item "$Env:AppData\code\logs")
# auto invokes [Regex]::escape() and joins for you
$IgnoreRegex = Join-Regex -Regex 'git', 'python', 'json'
# output: (git)|(python)|(json)

fd --changed-within 10minutes --search-path (Get-Item "$Env:AppData\code\logs")
| Get-Item
| Where-Object Name -NotMatch $IgnoreRegex
| Sort-Object LastWriteTime
| To->RelativePath $Env:AppData
| fzf.exe -m --preview 'bat --style=snip,header,numbers --line-range=:200 {}'


