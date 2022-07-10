
function Get-RandomColor.proto {
    <#
    .synopsis
        random 24bit color
    #>
    [OutputType('PoshCode.Pansies.RgbColor')]
    [CmdletBinding()]
    param(
        [Alias('Count')][int]$TotalCount = 1)

    foreach ($i in 1..$TotalCount) {
        $r, $g, $b = Get-Random -Count 3 -Minimum 0 -Maximum 255
        [PoshCode.Pansies.RgbColor]::new($r, $g, $b)
    }
}
$script:__state_ColorEnumerator = @{}

Write-Warning '_randomCellColorEnumerator() should return 1 color, not 1 rendered pair of FG BG'
function _randomCellColorEnumerator {
    <#
    .SYNOPSIS
        not only does this ensure random colors always return, it also is a consumable color provider
    .NOTES
        just 1 fg color or 1 bg, not both at once?
        wait, color enumerator shouldn't return a [ConsoleCellColor] thing
    #>
    param(

    )
    $Config = @{
        Width = 10
    }
    function _nextGradient {
        <#
        # .OUTPUTS
        #>
        [OutputType('PoshCode.Pansies.RgbColor')]
        [CmdletBinding()]
        param()

        $cBegin, $cEnd = Get-RandomColor.proto -TotalCount 2
        $getGradientSplat = @{
            StartColor = $cBegin
            EndColor   = $cEnd
            Width      = $Config.Width
        }
        $gradientList = Pansies\Get-Gradient @getGradientSplat
    }
    Write-Warning '(re)write _nextGradient, else rand will have same colors in gradient for fg and bg'

    $state = $script:__state_ColorEnumerator
    $isEmpty = ($null -eq $state) -or $state.stack.count -lt 2
    if ( $isEmpty -or (-not $state.stack)) {
        $state.stack = [Collections.Stack]::new( (_nextGradient ) )
    }
    if ($false) {


        $st = [Collections.Stack]::new( [object[]]@($glist))

        while ( $st.Count -ge 2 ) {
            $fg = $st.Pop()
            $bg = $st.Pop()
            $msg = New-Text 'hi world' -fg $fg -bg $bg
            [Console]::Write( $msg )
            Start-Sleep -ms 3
        } ; Start-Sleep -ms 30;
    }
}

class ConsoleCell {
    <#
    .SYNOPSIS
        Consists of one cell, or at least one glyph, with color
    #>
    [object]$FG = 'gray80'
    [object]$BG = 'gray30'
    [string]$Text = '_'

    # renders, then writes to console at the current location
    [void] Write() {
        $msg = $this.Render()
        [console]::Write( $msg )
    }

    # Renders as ansi escape sequence
    [string] Render() {
        $msg = New-Text -fg $this.FG -bg $this.BG -Text $this.Text
        return $msg.ToString()
    }

    [string] ToString() {
        $msg = '[ConsoleCell(Text={0}, FG={1}, BG={2})] = "{3}"' -f @(
            $this.Text
            $this.FG
            $this.BG
            $this.Render()
        )
        $msg | Write-Debug
        return $msg
        # return $this.Render()
    }
}
class ConsolePosition {
    <#
    .SYNOPSIS
        minimal (x,y) tuple  metadata for console stuff
    .NOTES
        once
    #>
    [int]$X = 0
    [int]$Y = 0

    ConsolePosition () {
        $This.X = 0 ; $this.Y = 0
    }
    ConsolePosition ([int]$X, [int]$Y) {
        $this.X = $X
        $this.Y = $Y
    }

    [void] ConstrainTo ( [ConsoleRect]$RectConstraint) {
        'Constrain {0} to exist within {1}' -f @(
            $This.ToString()
            $RectConstraint.ToString()
        ) | Write-Debug

        if ($This.X -lt $RectConstraint.X) {
            $This.X = $RectConstraint.X
        } elseif ($This.X -gt $RectConstraint.Right) {
            $this.X = $RectConstraint.Right
        }
        if ($This.Y -lt $RectConstraint.Y) {
            $This.Y = $RectConstraint.Y
        } elseif ($This.Y -gt $RectConstraint.Bottom) {
            $this.Y = $RectConstraint.Bottom
        }

        'NewPosition = {0}' -f @(
            $this.ToString()
        ) | Write-Debug
    }

    [string] ToString() {
        return '[ConsolePosition({0}, {1})]' -f @(
            $this.X
            $this.Y
        )
    }
}
class ConsoleRect {
    <#
    .SYNOPSIS
        minimal rect-like metadata for console stuff
    .NOTES
        todo:
            - [ ] make getter/setter .Right using cs probably
    .EXAMPLE
        PS> [ConsoleRect]::new()
        PS> $cr = [ConsoleRect]::new(0,2,3,4)

        PS> $cr.ToString()

            [ConsoleRect(0, 2, 3, 4)]


    #>
    [int]$X = 0
    [int]$Y = 0
    [uint]$Width = 1
    [uint]$Height = 1

    ConsoleRect () {
        $This.X = 0 ; $This.Y = 0; $this.Width = 1; $this.Height = 1
    }
    ConsoleRect ([int]$X, [int]$Y, [int]$Width, [int]$Height) {
        $this.X = $X
        $this.Y = $Y
        $this.Width = $Width
        $this.Height = $Height
    }
    [int] Right() {
        return ($this.X + $this.Width)
    }
    [int] Bottom() {
        return ($this.X + $this.Width)
    }

    [bool] ContainsPoint( [ConsolePosition]$Position ) {
        [bool]$allTrue = (
            (
                $Position.X -ge $This.X
            ) -and (
                $Position.X -lt $this.Right()
            ) -and (
                $Position.Y -ge $This.Y
            ) -and (
                $Position.Y -lt $This.Bottom()
            )
        )
        return $allTrue
    }
    # calculated props:
    # [bool] ContainsPoint ( [ConsolePosition]$Position ) {

    # }

    [string] ToString () {
        return '[ConsoleRect({0}, {1}, {2}, {3})]' -f @(
            $this.X
            $this.Y
            $this.Width
            $This.Height
        )
    }
}
# getter/setters not even needed?


function _wrapStep {
    <#
    .SYNOPSIS
        bounce/wrap screen's boundries
    .NOTES
        research best method to reference locations and wrap, one of
            - [console]:: vs $UI.Host is better to use for positions?
        Or maybe even ansi escapes?

    #>
    param(
        # otherwise you get clamped to the edge
        [switch]$AsPacManWrap,
        # instead, bounce
        [switch]$AsBounce
    )
}

function _randStep {
    <#
    .SYNOPSIS
        random-walk style step, no smoothing
    #>
    [OutputType('ConsolePosition')]
    [CmdletBinding()]
    param(
        [int]$MinX = -1,
        [int]$MinY = -1,
        [int]$MaxX = 1,
        [int]$MaxY = 1
        # [int]$MaxX = 1,
        # [int]$MinY = -1,
    )
    $x = RandomInt.proto -Min $MinX -Max $MaxX -count 1
    $y = RandomInt.proto -Min $MinY -Max $MaxY -count 1
    [ConsolePosition]::new($x, $y)
}


class ConsoleCursor {
    <#
    synopsis
        contains location, movement, wrapping, color, etc in one place
    #>
    [ConsolePosition]$Position = [ConsolePosition]::new(0, 0) # 0, 0 # arg transformation attribute
    [ConsoleCell]$Brush = [ConsoleCell]::new()
}
Hr

$rect = [ConsoleRect]::new(1, 4, 1, 3)
$pos = [ConsolePosition]::new(10, 10)

H1 'rect'
$rect
| Out-Default
H1 'rect.ToString()'
$rect.ToString()
Hr

H1 'Pos'
$pos
| Out-Default
H1 'Pos.ToString()'
$pos.ToString()
# function ConsoleCursor {
#     x, y
# }