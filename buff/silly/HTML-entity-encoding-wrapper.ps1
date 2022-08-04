
function UnEscapeHtmlEntity {
    <#
    .synopsis
        un-escaped already escaped html entities
    .example
        Pwsh> 'Hi &quot;world&quot;'  | Html->UnEscapeEntity
        Hi "world"
    .notes
        see also:
        [System.Web.HttpUtility] | fm | ? Name -match '(en|de)code|coding|url|query|html'
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.uri?view=net-6.0
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility?view=net-6.0
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.web.httputility?view=net-6.0
    #>
    [Alias( 'Html->UnEscapeEntity' )] # 'Html->UnEscape'
    [OutputType('System.String')]
    param(
        [AllowNull()][Parameter(ValueFromPipeline)]
        [string]$InputText
    )
    process {
        [System.Web.HttpUtility]::HtmlDecode($InputText)
    }
}

function EscapeHtmlEntity {
    <#
    .synopsis
        escape html entities
    .example
        Pwsh> 'Hi &quot;world&quot;' | EscapeHtmlEntity

        Hi &amp;quot;world&amp;quot;
    .notes
        see also:
        [System.Web.HttpUtility] | fm | ? Name -match '(en|de)code|coding|url|query|html'
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.uri?view=net-6.0
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility?view=net-6.0
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.web.httputility?view=net-6.0
    #>
    [Alias( 'Html->EscapeEntity' )] # 'Html->Escape'
    [OutputType('System.String')]
    param(
        [AllowNull()][Parameter(ValueFromPipeline)]
        [string]$InputText
    )
    process {
        [System.Web.HttpUtility]::HtmlEncode($InputText)
    }
}




