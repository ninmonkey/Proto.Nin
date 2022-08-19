
# Appeared to work on solo test.
((Get-Command Debug-ExposeInternalItem).ScriptBlock.Attributes.TypeId)
https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
#(gcm Debug-ExposeInternalItem).ScriptBlock.Attributes.TypeId -match 'IsExperimental').count -gt 0
$c ??= @{}
$c.Blue = $PSStyle.Foreground.FromRgb(103, 163, 181)
$c.Reset = $PSStyle.Reset

H1 'Find commands marked experimental'

foreach ($Cmd in @(Get-Command -m Ninmonkey.Console)) {
    "$cmd ?"
    if (($Cmd.ScriptBlock.Attributes.TypeId -match 'IsExperimental').count -gt 0) {
        $msg = "${fg:green}$Cmd$($c.Reset)"
        [Console]::write( $msg )
        Hr 1
        $Cmd.ScriptBlock.Attributes.TypeId.Name | csv2
    } else {
        [Console]::Write( '.' )
    }
    # [console]::Write( $PSStyle.Reset )
}