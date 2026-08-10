$navItems = @(
    @{ File = 'index.html'; Label = 'HOME'; Link = 'index.html' },
    @{ File = 'about.html'; Label = 'ABOUT US'; Link = 'about.html' },
    @{ File = 'service.html'; Label = 'SERVICES'; Link = 'service.html' },
    @{ File = 'testimonial.html'; Label = 'TESTIMONIALS'; Link = 'testimonial.html' },
    @{ File = 'corporate.html'; Label = 'CORPORATE TRAVEL'; Link = 'corporate.html' },
    @{ File = 'faq.html'; Label = 'FAQ'; Link = 'faq.html' },
    @{ File = 'contact.html'; Label = 'CONTACT'; Link = 'contact.html' },
    @{ File = 'login.html'; Label = 'LOGIN'; Link = 'login.html' },
    @{ File = 'ai.html'; Label = 'AI ASSISTANT'; Link = 'ai.html' }
)

function Build-NavHtml {
    param(
        [string]$CurrentFile,
        [string]$NavClass,
        [string]$NavId
    )

    $items = foreach ($item in $navItems) {
        $active = if ($item.File -eq $CurrentFile) { ' class="active"' } else { '' }
        '        <li><a' + $active + ' href="' + $item.Link + '">' + $item.Label + '</a></li>'
    }

    return @"
    <nav class=\"$NavClass\" id=\"$NavId\">
      <ul>
$($items -join "`n")
      </ul>
    </nav>
"@
}

Get-ChildItem -Path . -Filter '*.html' | ForEach-Object {
    $file = $_.FullName
    $name = $_.Name
    $content = Get-Content -Raw -Path $file

    $header = Build-NavHtml -CurrentFile $name -NavClass 'new show' -NavId 'mobileMenu'
    $side = Build-NavHtml -CurrentFile $name -NavClass 'side-menu' -NavId 'sideMenu'

    $newContent = $content -replace '(?s)<nav class="new[^"]*"[^>]*>.*?</nav>', $header
    $newContent = $newContent -replace '(?s)<nav class="side-menu"[^>]*>.*?</nav>', $side

    if ($newContent -ne $content) {
        Set-Content -Path $file -Value $newContent
        Write-Host "Updated $name"
    }
}
