# techdoc - Eleventy Theme Specification

## Overview

Minimal structural Eleventy theme for tech documentation. **No colors. Sites style everything.**

## Version Requirements

- Eleventy: **3.1.2+** (latest stable)
- Node.js: **18+**

## Philosophy

The theme provides **structure only**:
- Layouts (base, docs, blog, api)
- Collections (blog posts, docs pages)
- Filters (dateFormat, slugify, t() for i18n)
- JavaScript (theme toggle, mobile menu, language switcher)
- Minimal structural CSS (reset, layout, utilities)

Sites provide **all visual styling**:
- Colors (CSS custom properties)
- Typography (fonts, sizes)
- Decorative styles (shadows, borders, gradients)
- Branding/logos

## Installation

### New Site (Recommended)

```bash
mkdir my-site && cd my-site
npm init -y
npm install @11ty/eleventy techdoc
npx techdoc init
```

The `init` command scaffolds a complete site and prompts for CSS style choice.

### CSS Style Choices

When running `npx techdoc init`, users choose from:

1. **Minimal** (default)
   - Basic CSS custom properties
   - Simple light/dark mode
   - No framework dependencies

2. **C64**
   - Basic C64 style
   - Blocky
   - Block monospace font
   - C64 blues

3. **None**
   - No CSS generated
   - User provides all styling from scratch

## Package Structure

```
techdoc/
├── package.json
├── lib/
│   ├── index.js              # Main plugin entry
│   ├── virtual-templates.js  # Registers layouts via addTemplate()
│   ├── filters/index.js      # All filters
│   ├── plugins/
│   │   ├── collections.js    # Blog/docs collections
│   │   └── markdown.js       # Markdown config
│   └── shortcodes/index.js   # Shortcodes (year, etc.)
├── templates/layouts/
│   ├── base.njk              # HTML shell
│   ├── docs.njk              # Two-column with sidebar
│   ├── blog.njk              # Blog post layout
│   └── api.njk               # API reference
├── assets/
│   ├── css/
│   │   ├── reset.css         # Minimal CSS reset
│   │   ├── layout.css        # Structural grid/flexbox
│   │   └── utilities.css     # Accessibility helpers
│   └── js/
│       ├── main.js           # Entry point
│       ├── theme-toggle.js   # Dark/light mode
│       ├── mobile-menu.js    # Mobile navigation
│       └── language-switcher.js
└── bin/
    └── init.js               # CLI scaffolding tool
```

## Configuration

Config goes in eleventy.config.js

## Layouts

### base.njk
Minimal HTML shell with:
- Proper `<head>` with meta tags, Open Graph
- Skip link for accessibility
- Header with nav
- Main content area
- Footer
- Blocks: `{% block head %}`, `{% block content %}`, `{% block scripts %}`

### docs.njk
Extends base. Two-column layout:
- Sidebar with docs navigation
- Main content area
- Responsive (stacks on mobile)

### blog.njk
Extends base. Article layout:
- Post metadata (date, author)
- Back to blog link
- Article content

### api.njk
Extends base. API reference:
- Sidebar with API nav
- Main content area

## API Documentation Generation

**CRITICAL: API documentation MUST be 100% generated. No hand-written API docs in git.**

The `api.njk` layout displays generated API documentation. The generation process:

1. **Source**: Language-specific documentation (C# XML docs, Dart doc comments, JSDoc, etc.)
2. **Generator**: Each site implements a generator script that parses source docs
3. **Output**: Markdown files in `src/api/` directory (gitignored)
4. **Build**: Generator runs before Eleventy build

### Generation Requirements

- API markdown files (`src/api/*.md`) MUST be gitignored
- Generator script MUST be in `scripts/` or `tools/` directory
- Build command MUST run generator before Eleventy: `npm run generate-api && npx @11ty/eleventy`
- Each class gets a summary page (just member list with links)
- Each member (method, property, type) gets its own detail page

### Example: C# XML Docs

For C# projects like RestClient.Net:

```bash
# .gitignore
src/api/*.md
!src/api/_index.md  # Optional hand-written index

# package.json scripts
{
  "scripts": {
    "generate-api": "node scripts/generate-api-docs.js",
    "build": "npm run generate-api && npx @11ty/eleventy",
    "dev": "npm run generate-api && npx @11ty/eleventy --serve"
  }
}
```

Generator reads `.xml` doc files from C# build output and generates:
- One markdown file per namespace
- One markdown file per class (summary only - member list with links)
- One markdown file per member (full details: signature, parameters, returns, examples)

### Example: Dart Doc Comments

For Dart projects:

```bash
# Generate JSON from dartdoc
dart doc --output=doc-json --format=json

# Generator parses doc-json/ and creates src/api/*.md
node scripts/generate-api-docs.js
```

### Page Structure

**Class summary page** (`src/api/httpclient-extensions.md`):
```markdown
# HttpClientExtensions Class

Extension methods for HttpClient.

## Namespace
`RestClient.Net`

## Methods
| Method | Description |
|--------|-------------|
| [GetAsync](/api/getasync/) | Make a type-safe GET request |
| [PostAsync](/api/postasync/) | Make a type-safe POST request |
```

**Member detail page** (`src/api/getasync.md`):
```markdown
# GetAsync Method

Make a type-safe GET request.

## Signature
\`\`\`csharp
public static async Task<Result<TSuccess, HttpError<TError>>> GetAsync<TSuccess, TError>(...)
\`\`\`

## Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| url | AbsoluteUrl | The request URL |
...

## Returns
...

## Example
...
```

## Filters

| Filter | Usage | Description |
|--------|-------|-------------|
| `dateFormat` | `{{ date \| dateFormat }}` | Localized date (respects `lang`) |
| `isoDate` | `{{ date \| isoDate }}` | ISO 8601 for JSON-LD |
| `limit` | `{{ posts \| limit(5) }}` | Limit array length |
| `capitalize` | `{{ str \| capitalize }}` | Capitalize first letter |
| `slugify` | `{{ str \| slugify }}` | URL-safe slug |
| `t` | `{{ "key" \| t(lang) }}` | Translation lookup |
| `altLangUrl` | `{{ url \| altLangUrl(currentLang, targetLang) }}` | Language URL switching |

## Required Site Data

### src/_data/site.json
```json
{
  "title": "My Site",
  "description": "Site description",
  "url": "https://example.com"
}
```

### src/_data/navigation.json
```json
{
  "main": [
    { "text": "Docs", "url": "/docs/" },
    { "text": "Blog", "url": "/blog/" }
  ],
  "footer": [
    {
      "title": "Resources",
      "items": [
        { "text": "GitHub", "url": "https://github.com/..." }
      ]
    }
  ],
  "docs": [
    { "text": "Getting Started", "url": "/docs/" },
    { "text": "Installation", "url": "/docs/installation/" }
  ]
}
```

## CSS Custom Properties

Sites MUST define these for the theme to render properly:

```css
:root {
  /* Required */
  --color-bg: #fff;
  --color-text: #111;
  --color-primary: #0066cc;
  --color-border: #e5e5e5;

  /* Optional (have sensible defaults) */
  --sidebar-width: 250px;
  --content-width: 65ch;
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-4: 1rem;
  --space-8: 2rem;
}

[data-theme="dark"] {
  --color-bg: #111;
  --color-text: #f0f0f0;
  --color-primary: #66b3ff;
  --color-border: #333;
}
```

## Tests

There are Playwright tests for the sample website. They are at techdoc/tests

## i18n Support

Enable with:
```javascript
{
  features: { i18n: true },
  i18n: { languages: ["en", "zh"] }
}
```

Create `src/_data/i18n.json`:
```json
{
  "en": {
    "nav": { "docs": "Documentation", "blog": "Blog" },
    "blog": { "back": "Back to Blog" }
  },
  "zh": {
    "nav": { "docs": "文档", "blog": "博客" },
    "blog": { "back": "返回博客" }
  }
}
```

Create language-specific content in `src/zh/`.

## Bundled Plugins

The theme includes and configures:
- `@11ty/eleventy-plugin-syntaxhighlight` - Code syntax highlighting
- `@11ty/eleventy-plugin-rss` - RSS feed generation
- `@11ty/eleventy-navigation` - Navigation plugin

## Updates Flow Automatically

Layouts are registered via Eleventy's Virtual Templates API (`addTemplate()`). When you `npm update techdoc`, new layouts are used immediately - no manual syncing required.

## Verification Checklist

- [ ] `npx techdoc init` scaffolds working site
- [ ] `npm run dev` serves site successfully
- [ ] All 4 layouts render (base, docs, blog, api)
- [ ] Dark mode toggle works
- [ ] Mobile menu works
- [ ] Theme CSS has NO colors (sites must provide)
- [ ] i18n works when enabled
- [ ] RSS feed generates
- [ ] Syntax highlighting works
- [ ] API docs are 100% generated (no `src/api/*.md` in git)
- [ ] `npm run build` runs generator before Eleventy
