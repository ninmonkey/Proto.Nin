BeforeAll {
    # . (gi -ea stop (join-path $PSScriptRoot 'HTML-entity-encoding-wrapper.ps1'))
    $src = (Get-Item $PSCommandPath) -replace '\.tests\.ps1$', '.ps1'
    . (Get-Item -ea stop $src )
}

Describe 'Future Commands' {
    It 'Encode ur' {
        $start = 'https://docs.microsoft.com/system.web.httputility.urldecode?view=net-6.0#system-web-httputility-urldecode(system-string)'
        $Expected = 'https%3A%2F%2Fdocs.microsoft.com%2Fsystem.web.httputility.urldecode%3Fview%3Dnet-6.0%23system-web-httputility-urldecode(system-string)'
        [System.Net.WebUtility]::UrlEncode($Start)
        | Should -Be $Expected
    }
}
Describe 'HTML [en|de]code entities' {
    BeforeAll {
        $Sample = 'Hi "world"'
        $SampleEscaped = 'Hi &quot;world&quot;'
        $SampleWithNewline = "hi 'world'`nline 2"
        $SampleFromGCPipe = @(
            '&'
            $null
            ''
            '"'
        )
    }
    It 'Escaping' {
        $Sample
        | EscapeHtmlEntity
        | Should -Be $SampleEscaped
    }
    It 'From Escaped' {
        $SampleEscaped
        | UnEscapeHtmlEntity
        | Should -Be $Sample
    }

    It 'Round Trip' {
        $SampleEscaped
        | UnEscapeHtmlEntity
        | EscapeHtmlEntity
        | Should -Be $SampleEscaped
    }

    It 'Allows Null' {
        { $SampleFromGCPipe | EscapeHtmlEntity }
        | Should -Not -Throw
        { $SampleFromGCPipe | UnEscapeHtmlEntity }
        | Should -Not -Throw
    }
}
