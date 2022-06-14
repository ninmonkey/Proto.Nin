using namespace System
using namespace System.Linq
using namespace System.Collections
using namespace System.Collections.Generic

<#
context: https://discord.com/channels/180528040881815552/447476117629304853/982338473778352188
#>

Update-TypeData -Force -TypeName System.Object -MemberType ScriptMethod -MemberName OrderBy -Value {
    $source = $this
    if ($source -isnot [IEnumerable]) {
        $source = @($this)
    } elseif ($source -isnot [IEnumerable[object]]) {
        $source = [Enumerable]::Cast[object]($this)
    }

    , [Enumerable]::OrderBy[object,object]([IEnumerable[object]]$source, [Func[object, object]]$args[0])
}

Update-TypeData -Force -TypeName System.Object -MemberType ScriptMethod -MemberName ThenBy -Value {
    if ($this -isnot [IOrderedEnumerable[object]]) {
        throw 'Use OrderBy first'
    }

    $source = $this
    , [Enumerable]::ThenBy[object,object]([IOrderedEnumerable[object]]$source, [Func[object, object]]$args[0])
}

Update-TypeData -Force -TypeName System.Object -MemberType ScriptMethod -MemberName ToArray -Value {
    $source = $this
    if ($source -isnot [IEnumerable]) {
        $source = @($this)
    } elseif ($source -isnot [IEnumerable[object]]) {
        $source = [Enumerable]::Cast[object]($this)
    }

    , [Enumerable]::ToArray[object]([IEnumerable[object]]$source)

}

# finally

$toSort.OrderBy{ param($s) $s.Length }.ThenBy{ param($s) $s }.ToArray()