class EncodedTextResult {
    EncodedTextResult ( [string]$InputString ) {
        if ($null -eq $InputString) {
            throw 'Required string was missing' 
        }
        if ($InputString.length -eq 0) {
            throw 'String is empty!'
        }
        $r = 255 * .8
        $ColorGrayBG = $PSStyle.Background.FromRgb( $r, $r, $r)
        $this.RawOriginal = $InputString
        $this.HighlightedDisplayString = @(
            $ColorGrayBG
            $InputString
            $script:PSStyle.Reset
        ) -join ''
        $this.EncodedText = (newEncoding 'utf-8').GetBytes( $InputString )
    }
}