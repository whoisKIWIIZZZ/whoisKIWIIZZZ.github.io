#import "lib/site.typ": page
#import "lib/components.typ" as ui

// ─────────────────────────────────────────────────────────────────────────────
// 站点外观
//
// 版式来自 guanchengwan.github.io，样式表只有一份：assets/site.css。
// Font Awesome 走 CDN，类名用 "fas fa-envelope" 这种两段写法。
// ─────────────────────────────────────────────────────────────────────────────
#let css = (
  "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css",
  "/assets/site.css",
)

#let js-scripts = ("/assets/code-blocks.js", "/assets/site.js")

// ─────────────────────────────────────────────────────────────────────────────
// 顶栏导航
//
// 新增页面：在 content/ 下建 <页面名>/index.typ，再在这里加一条。
// 第一条固定是首页，窄屏下由 CSS 把它藏起来。
// ─────────────────────────────────────────────────────────────────────────────
#let nav-links = (
  "/": "Homepage",
  "/CV/": "CV",
  "/Projects/": "Projects",
  "/Memoir/": "Memoir",
)

#let footer-follow = (
  ("https://github.com/whoisKIWIIZZZ", "GitHub"),
  ("https://space.bilibili.com/454587686", "Bilibili"),
  ("https://whoiskiwiizzz.github.io/CV/", "CV"),
)

// ─────────────────────────────────────────────────────────────────────────────
// 人物侧栏
//
// `ui.profile` 的第三个参数是联系入口的 (图标类名, 文字, 链接) 序列。
// 图标从 Font Awesome 取：fas fa-envelope、fas fa-graduation-cap、
// fab fa-github、fas fa-music、fas fa-file-pdf 等。
// ─────────────────────────────────────────────────────────────────────────────
#let profile = ui.profile(
  image("/content/imgs/me.jpg", alt: "易守拙"),
  "易守拙 (Shouzhuo Yi)",
  bio: "Hongyi Honor College, School of Computer Science, Wuhan University",
  links: (
    ("fas fa-envelope", "Email", "mailto:yishouzhuo@whu.edu.cn"),
    ("fab fa-github", "GitHub", "https://github.com/whoisKIWIIZZZ"),
    ("fas fa-graduation-cap", "Google Scholar", "https://scholar.google.com/"),
    // Font Awesome 5 免费版没有 fa-bilibili，用 fa-play 表示视频站
    ("fas fa-play", "Bilibili", "https://space.bilibili.com/454587686"),
  ),
)

#let template = page.with(
  title: "Shouzhuo Yi",
  lang: "zh",
  nav: nav-links,
  sidebar: (profile,),
  footer-copyright: "© " + str(datetime.today().year()) + " Shouzhuo Yi",
  footer-follow: footer-follow,
  css: css,
  js-scripts: js-scripts,
)
