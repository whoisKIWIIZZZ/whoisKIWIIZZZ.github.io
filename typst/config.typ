#import "tufted-lib/tufted.typ" as tufted-lib
#import "lib/shell.typ": profile-web
#import "lib/ui.typ"

#let tufted = tufted-lib
#let html-grid = tufted.html-grid
#let today = datetime.today()
#let year = today.year()

// ─────────────────────────────────────────────────────────────────────────────
// 站点外观
//
// 字体走 fontsource CDN：英文 EB Garamond（老式数字），中文 Noto Serif SC。
// 样式表顺序即层叠顺序，site.css 在最后，负责覆盖前面所有规则。
// ─────────────────────────────────────────────────────────────────────────────
#let fonts = (
  "https://cdn.jsdelivr.net/npm/@fontsource/eb-garamond@5.3.0/400.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/eb-garamond@5.3.0/400-italic.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/eb-garamond@5.3.0/500.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/eb-garamond@5.3.0/600.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/eb-garamond@5.3.0/700.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/noto-serif-sc@5.3.0/400.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/noto-serif-sc@5.3.0/500.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/noto-serif-sc@5.3.0/600.css",
  "https://cdn.jsdelivr.net/npm/@fontsource/noto-serif-sc@5.3.0/700.css",
)

#let stylesheets = fonts + (
  "https://cdnjs.cloudflare.com/ajax/libs/tufte-css/1.8.0/tufte.min.css",
  "/assets/tufted.css",
  "/assets/theme.css",
  "/assets/custom.css",
  "/assets/site.css",
)

#let scripts = (
  "/assets/code-blocks.js",
  "/assets/format-headings.js",
  "/assets/theme-toggle.js",
  "/assets/contributions.js",
)

// ─────────────────────────────────────────────────────────────────────────────
// 顶栏导航
//
// 新增页面：在 content/ 下建 <页面名>/index.typ，再在这里加一条。
// ─────────────────────────────────────────────────────────────────────────────
#let nav-links = (
  "/": "Home",
  "/CV/": "CV",
  "/Projects/": "Projects",
  "/Memoir/": "Memoir",
)

#let footer-links = (
  "©" + str(year) + " Shouzhuo Yi",
  [Powered by #link("https://github.com/Yousa-Mirage/Tufted-Blog-Template")[Tufted-Blog-Template of _Typst_]],
)

// 单栏版式：CV / Projects / Memoir 等长文页面
#let template = tufted.tufted-web.with(
  header-links: nav-links,
  lang: "zh",
  title: "Shouzhuo Yi",
  css: stylesheets,
  js-scripts: scripts,
  header-elements: (),
  footer-elements: footer-links,
)

// 双栏版式：首页
#let home = profile-web.with(
  header-links: nav-links,
  lang: "zh",
  title: "Shouzhuo Yi",
  css: stylesheets,
  js-scripts: scripts,
  footer-elements: footer-links,
)
