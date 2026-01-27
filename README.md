# eleventy-plugin-techdoc

Minimal structural Eleventy theme for tech documentation. **No colors. You style everything.**

[![npm version](https://badge.fury.io/js/eleventy-plugin-techdoc.svg)](https://www.npmjs.com/package/eleventy-plugin-techdoc)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Quick Start

```bash
mkdir my-site && cd my-site
npm init -y
npm install @11ty/eleventy eleventy-plugin-techdoc
npx eleventy-plugin-techdoc init
npm run dev
```

The init command prompts for:
- **CSS style**: Minimal (light/dark), C64 (retro), or None (blank slate)
- **Sample content**: Include example docs and blog posts, or start empty

## Generated Structure

```
my-site/
├── eleventy.config.js    # Eleventy configuration
├── src/
│   ├── _data/
│   │   ├── site.json       # Site metadata
│   │   ├── navigation.json # Nav links
│   │   └── i18n.json       # Translations
│   ├── assets/css/
│   │   └── styles.css      # Your styles (YOU control this)
│   ├── docs/
│   │   ├── index.md        # Docs home
│   │   ├── api.md          # API reference
│   │   └── configuration.md
│   ├── blog/
│   │   ├── index.njk       # Blog listing
│   │   └── hello-world.md  # Sample post
│   ├── feed.njk            # RSS/Atom feed
│   └── index.njk           # Home page
```

## Configuration

### eleventy.config.js

```javascript
import techdoc from "techdoc";

export default function(eleventyConfig) {
  eleventyConfig.addPlugin(techdoc, {
    site: {
      name: "My Site",
      url: "https://example.com",
      description: "Built with techdoc",
    },
    features: {
      blog: true,      // Enable blog collections
      docs: true,      // Enable docs collections
      darkMode: true,  // Enable dark mode toggle
      i18n: false,     // Enable internationalization
    },
    i18n: {
      defaultLanguage: "en",
      languages: ["en", "zh", "es"],  // When i18n: true
    },
  });

  eleventyConfig.addPassthroughCopy("src/assets");

  return {
    dir: { input: "src", output: "_site" },
    markdownTemplateEngine: "njk",
  };
}
```

### src/_data/site.json

```json
{
  "title": "My Site",
  "description": "Built with techdoc",
  "url": "https://example.com",
  "stylesheet": "/assets/css/styles.css"
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
      "title": "Links",
      "items": [
        { "text": "GitHub", "url": "https://github.com/yourname" }
      ]
    }
  ]
}
```

## CSS Custom Properties

The theme uses CSS custom properties for layout. Your `styles.css` must define these for visual styling:

### Required Properties

```css
:root {
  /* Colors - theme provides no defaults */
  --color-bg: #fff;
  --color-text: #111;
  --color-primary: #0066cc;
  --color-border: #e5e5e5;
  --color-muted: #666;
}

/* Dark mode (if enabled) */
[data-theme="dark"] {
  --color-bg: #111;
  --color-text: #f0f0f0;
  --color-primary: #66b3ff;
  --color-border: #333;
  --color-muted: #999;
}
```

### Optional Layout Properties

```css
:root {
  /* Layout - these have fallback defaults */
  --max-width: 1200px;        /* Default: 1200px */
  --content-width: 65ch;      /* Default: 65ch */
  --sidebar-width: 250px;     /* Default: 250px */
  --header-height: 60px;      /* Default: 60px */

  /* Spacing */
  --space-2: 0.5rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
}
```

## Layouts

Four layouts are provided:

| Layout | Use For | Classes |
|--------|---------|---------|
| `layouts/base.njk` | HTML shell | `.site-header`, `.site-footer` |
| `layouts/docs.njk` | Documentation | `.docs-layout`, `.sidebar`, `.docs-content` |
| `layouts/blog.njk` | Blog posts | `.blog-post`, `.blog-container` |
| `layouts/api.njk` | API reference | Same as docs |

### Using Layouts

```markdown
---
layout: layouts/docs.njk
title: Getting Started
eleventyNavigation:
  key: Getting Started
  order: 1
---

# Getting Started

Your content here...
```

## Blog Posts

Create markdown files in `src/blog/` with `tags: posts`:

```markdown
---
layout: layouts/blog.njk
title: My First Post
date: 2025-01-22
author: Your Name
tags: posts
excerpt: A brief summary for the listing page.
---

# My First Post

Content here...
```

## Documentation Sidebar

Use `eleventyNavigation` in frontmatter for sidebar links:

```markdown
---
layout: layouts/docs.njk
title: API Reference
eleventyNavigation:
  key: API Reference
  order: 2
---
```

## RSS Feed

An RSS/Atom feed is generated at `/feed.xml` automatically from blog posts.

## Internationalization (i18n)

Enable i18n in config:

```javascript
eleventyConfig.addPlugin(techdoc, {
  features: { i18n: true },
  i18n: {
    defaultLanguage: "en",
    languages: ["en", "zh", "es"],
  },
});
```

Create translations in `src/_data/i18n.json`:

```json
{
  "en": {
    "blog": { "back": "Back to Blog" },
    "nav": { "docs": "Documentation" }
  },
  "zh": {
    "blog": { "back": "返回博客" },
    "nav": { "docs": "文档" }
  }
}
```

Create language folders: `src/zh/`, `src/es/`, etc. with translated content.

Use the `t` filter in templates:

```njk
{{ "blog.back" | t(lang) }}
```

## Bundled Plugins

techdoc includes and configures:

- `@11ty/eleventy-plugin-syntaxhighlight` - Code syntax highlighting
- `@11ty/eleventy-plugin-rss` - RSS feed generation
- `@11ty/eleventy-navigation` - Docs sidebar navigation

## Troubleshooting

### Code blocks show raw backticks

Ensure your `eleventy.config.js` returns `markdownTemplateEngine: "njk"`:

```javascript
return {
  dir: { input: "src", output: "_site" },
  markdownTemplateEngine: "njk",  // Required!
};
```

### Styles not loading

1. Check `src/_data/site.json` has `stylesheet` pointing to your CSS
2. Ensure `eleventyConfig.addPassthroughCopy("src/assets")` is in your config
3. Verify CSS file exists at `src/assets/css/styles.css`

### Docs sidebar empty

Add `eleventyNavigation` to your docs frontmatter:

```markdown
---
layout: layouts/docs.njk
title: My Page
eleventyNavigation:
  key: My Page
  order: 1
---
```

### RSS feed returns 404

Ensure `src/feed.njk` exists. Run `npx techdoc init` to regenerate it.

### Translations not working

1. Enable i18n: `features: { i18n: true }`
2. Create `src/_data/i18n.json` with language keys
3. Use dot notation: `{{ "nav.docs" | t(lang) }}`

### Dark mode toggle not working

Ensure your CSS includes `[data-theme="dark"]` styles:

```css
[data-theme="dark"] {
  --color-bg: #111;
  --color-text: #f0f0f0;
}
```

### Build errors with Eleventy 2.x

techdoc requires Eleventy 3.x. Upgrade:

```bash
npm install @11ty/eleventy@latest
```

## Local Development

For contributing to techdoc:

```bash
mkdir my-site && cd my-site
npm init -y
npm install @11ty/eleventy ../techdoc
node ../techdoc/bin/init.js
# Or if published:
# npm install @11ty/eleventy eleventy-plugin-techdoc
# npx eleventy-plugin-techdoc init
npm run dev
```

## License

MIT
