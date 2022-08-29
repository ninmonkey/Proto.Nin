using namespace System.Collections.Generic

$Sample = @{
    ImplicitArray     = 0..10
    Empty_Array       = @()
    Empty_Hash        = @{}
    Empty_OrderedHash = [ordered]@{}
    Empty_Dict        = 'NYI'
}
[list[object]]$list = 0..10
[list[object]]$empty_list = @()
[list[int]]$int_list = 0..10
$Sample.List_ImplicitCtor = $list
$Sample.Empty_List = $empty_list
$Sample.List_TypeAsInt = $int_list


# $sample

# Hr

# $tinfo = $Sample.EmptyArray.GetType()

function Get-TypeInformationInteractive {
    [Alias('LookAt')]
    param(

        # input
        [AllowEmptyCollection()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,
        # refactor to enum ds
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet(
            'FormatShortList',
            'Min_asTable', 'Min_asList',
            'Table_GoodDefaults',
            'List_GoodDefaults',
            # 'Expand_ImplementedInterfaces',
            # 'Expand_ImplementedInterfaces_NoGroup',

            # newer
            'ImplementedInterfaces_AsUL',
            'Expand_Default_ImplementedInterfaces',
            'Expand_Table_ImplementedInterfaces_NoGroup'
        )]
        [string]$FormatMode,

        [string]$Label
    )

    process {
        $tinfo = if ($InputObject -is 'type') {
            $tinfo = $InputObject
        } elseif ($InputObject -is 'string') {
            $tinfo = $InputObject -as 'type'
        } else {
            $InputObject.GetType()
        }

        $firstElem = @($InputObject)[0]?.GetType()
        $firstTinfo = $firstElem

        # ($InputObject.Empty_List)[0]?.ToString()
        # [Nullable[object]]$firstElem = @($InputObject)[0]
        # [Nullable[object]]$firstTinfo = ($firstElem)?.GetType()

        # .GetType | shortType
        if ($Label) {
            H1 -Name $Label
        } else {
            H1 -Name ($Tinfo | shortType)
        }

        Label 'TypeName' ($Tinfo | shortType)
        if ($firstTinfo) {
            Label 'FirstElem' ($firstTinfo | shortType)
        }
        Label 'Count' $Tinfo.Count
        Label 'Length' $Tinfo.Length
        #
        # }

        switch ($FormatMode) {
            'FormatShortList' {
                $tinfo | Format-List Access, Modifiers, Name, *display*, *attr*, *imple*, *inter*
            }
            'Min_asList' {
                $tinfo | Format-List *display*
            }
            'Min_asTable' {
                $tinfo | Format-Table *display*
            }
            'Table_GoodDefaults' {
                $tinfo | Format-Table Name, BaseType, NameSpace, *display*
            }
            'List_GoodDefaults' {
                $tinfo | Format-List name, Namespace, *display*, baseType, @{name = 'BaseTypeDisplay'; expression = { $_.BaseType -as 'type' | shortType } }, @{
                    Name       = 'DisplayInterfaces'
                    Expression = {
                        $_.ImplementedInterfaces | shortType
                    }
                }
            }
            'ImplementedInterfaces_AsUL' {
                $tinfo.ImplementedInterfaces | shortType | UL
            }
            'Expand_Default_ImplementedInterfaces' {
                $tinfo.ImplementedInterfaces
            }
            'Expand_Table_ImplementedInterfaces_NoGroup' {
                $tinfo.ImplementedInterfaces | Format-Table -GroupBy { $true } -AutoSize
            }
            default { throw "ShouldNeverReach:$FormatMode  $_ " }
        }
    }
}
Hr -fg magenta


if ('Chunk1') {
    $fmtMode = 'FormatShortList'
    H1 -fg magenta $FmtMode

    LookAt -InputObject $Sample.Empty_Array -FormatMode $fmtMode -Label 'EmptyArray: @()'
    Hr
    LookAt -InputObject $Sample.Empty_List -FormatMode $fmtMode -Label 'Empty [List[object]] = @()'
    Hr
    LookAt -InputObject $Sample.List_TypeAsInt -FormatMode $fmtMode -Label '[list[int]]$int_list = 0..10'
}
if ('Chunk2') {
    $fmtMode = 'Min_asList'
    H1 -fg magenta $FmtMode
    LookAt -InputObject $Sample.Empty_Array -FormatMode $fmtMode -Label 'EmptyArray: @()'
    Hr
    LookAt -InputObject $Sample.Empty_List -FormatMode $fmtMode -Label 'Empty [List[object]] = @()'
    Hr
    LookAt -InputObject $Sample.List_TypeAsInt -FormatMode $fmtMode -Label '[list[int]]$int_list = 0..10'

    $fmtMode = 'Min_asTable'
    H1 -fg magenta $FmtMode
    LookAt -InputObject $Sample.Empty_Array -FormatMode $fmtMode -Label 'EmptyArray: @()'
    Hr
    LookAt -InputObject $Sample.Empty_List -FormatMode $fmtMode -Label 'Empty [List[object]] = @()'
    Hr
    LookAt -InputObject $Sample.List_TypeAsInt -FormatMode $fmtMode -Label '[list[int]]$int_list = 0..10'
}
if ('Chunk3') {
    $fmtMode = 'List_GoodDefaults'
    H1 -fg magenta $FmtMode
    LookAt -InputObject $Sample.Empty_Array -FormatMode $fmtMode -Label 'EmptyArray: @()'
    Hr
    LookAt -InputObject $Sample.Empty_List -FormatMode $fmtMode -Label 'Empty [List[object]] = @()'
    Hr
    LookAt -InputObject $Sample.List_TypeAsInt -FormatMode $fmtMode -Label '[list[int]]$int_list = 0..10'
}
#
# LookAt -InputObject 'dsfd ' -FormatMode 'FormatSHortList' -Label 'asfd'