# From: <https://gist.github.com/IISResetMe/ef0a6ccb66019da761943f8d7e3e5763>



Get-PSReadLineOption |Get-Content -LiteralPath { $_.HistorySavePath } |ForEach-Object {
  if($_.EndsWith('`')){
    $last += "{0}`r`n" -f $_.Remove($_.Length - 1)
  }else{
    "${last}${_}"
    $last = $null
  }
} |Where-Object {$_ -like '*::*'} |ForEach-Object {
  # parse history entry as powershell script
  $errors = @()
  try {
    $replAst = [Management.Automation.Language.Parser]::ParseInput($_, [ref]$null, [ref]$errors)

    if($errors.Count -eq 0 -and $replAst -is [System.Management.Automation.Language.Ast]){
      $replAst.FindAll({
        param($childAst)

        $childAst -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and
        $childAst.Expression -is [System.Management.Automation.Language.TypeExpressionAst] -and
        $childAst.Static
      }, $true)
    }
  }
  catch{}
} |Where-Object Member -NotLike 'new' |Group-Object {
  (
    ($type = ($typeName = $_.Expression.TypeName).GetReflectionType()) -is [type] ? $type : $typename
  ).FullName
},Member -NoElement |Sort-Object Count |select -Last 25 Count,@{Name='Name';E={'[{0}]::{1}(...)'-f ($_.Name -split ', (?=[^,]+$)')}} |ft -AutoSize
@ninmonkey

