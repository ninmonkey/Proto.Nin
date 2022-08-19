
$TypeData = @{
    TypeName                  = 'nin.SummarizedObject.Property'
    DefaultDisplayPropertySet = 'Value', 'Name', 'Type', 'Reported', 'TypeStr' # FL
    DefaultDisplayProperty    = 'MergedType' # FW
    DefaultKeyPropertySet     = 'Name', 'Value' # sort and group
}
Update-TypeData @TypeData -Force


Get-Item . | io | Format-Table
Get-Item . | io | s -First 3 | Format-List