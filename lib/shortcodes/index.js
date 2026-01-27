/**
 * techdoc shortcodes
 */

/**
 * Register all shortcodes
 * @param {import("@11ty/eleventy").UserConfig} eleventyConfig
 */
export function registerShortcodes(eleventyConfig) {
  // Current year shortcode
  eleventyConfig.addShortcode("year", () => String(new Date().getFullYear()));
}
