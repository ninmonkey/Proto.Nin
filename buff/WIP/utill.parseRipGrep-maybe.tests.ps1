BeforeAll {
    . (Get-Item -ea stop (Join-Path $PSScriptRoot 'util.parseRipGrep-maybe.ps1 ' ))
}

Describe 'parsing RipGrep' {
    BeforeAll {
        $cachedJson = Get-Content (Get-Item -ea stop (Join-Path $PSScriptRoot 'cachedJson.jsonl' ))
        $firstLine = $cachedJson | Select-Object -First 1
        $firstMatchingLine = $cachedJson | Select-Object -First 1 -Skip 1
        $lastLine = $cachedJson | Select-Object -Last 1
        # $parsed = $cachedJson | _processRipgrepResult
    }

    It 'ShouldNotThrow: <JsonText> at <Index>' -ForEach @(
        @{ JsonText = $cachedJson[0] ; Index = 0 }
        @{ JsonText = $cachedJson[0] ; Index = 5 }
    ) {

        { [RipGrepResultRecord]::new( $JsonText ) }
        | Should -Not -Throw

        { [RipGrepResultRecord]::new( $JsonText, 5 ) }
        | Should -Not -Throw

    }
}
