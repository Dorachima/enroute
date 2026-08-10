from pathlib import Path
import re

nav_items = [
    ('index.html', 'HOME', 'index.html'),
    ('about.html', 'ABOUT US', 'about.html'),
    ('service.html', 'SERVICES', 'service.html'),
    ('testimonial.html', 'TESTIMONIALS', 'testimonial.html'),
    ('corporate.html', 'CORPORATE TRAVEL', 'corporate.html'),
    ('faq.html', 'FAQ', 'faq.html'),
    ('contact.html', 'CONTACT', 'contact.html'),
    ('login.html', 'LOGIN', 'login.html'),
    ('ai.html', 'AI ASSISTANT', 'ai.html'),
]

header_template = """    <nav class="new show" id="mobileMenu">
      <ul>
{items}
      </ul>
    </nav>"""

side_template = """       <nav class="side-menu" id="sideMenu">
          <div class="close-btn" id="closeBtn">&times;</div>
          <ul>
{items}
          </ul>
       </nav>"""

for html_path in sorted(Path('.').glob('*.html')):
    name = html_path.name
    lines = []
    for fname, label, link in nav_items:
        active = ' class="active"' if fname == name else ''
        lines.append(f'        <li><a{active} href="{link}">{label}</a></li>')
    header = header_template.format(items="\n".join(lines))
    side = side_template.format(items="\n".join(lines))

    text = html_path.read_text(encoding='utf-8')
    text_new = re.sub(r'<nav class="new[^"]*"[^>]*>.*?</nav>', header, text, count=1, flags=re.S)
    text_new = re.sub(r'<nav class="side-menu"[^>]*>.*?</nav>', side, text_new, count=1, flags=re.S)

    if text != text_new:
        html_path.write_text(text_new, encoding='utf-8')
        print('Updated', html_path)
