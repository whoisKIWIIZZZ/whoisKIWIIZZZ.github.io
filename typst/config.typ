#import "lib/site.typ": page
#import "lib/components.typ" as ui

// ─────────────────────────────────────────────────────────────────────────────
// 站点外观
//
// 字体走 fontsource CDN：
//   Fraunces        标题，柔软衬线，带一点旧印刷的味道
//   Source Serif 4  正文，为屏幕设计，小字号下笔画足够
//   Noto Serif SC   中文
// 样式表只有一份，assets/site.css。
// ─────────────────────────────────────────────────────────────────────────────
#let fonts = (
  "https://cdn.jsdelivr.net/npm/@fontsource-variable/fraunces@5.3.0/index.css",
  "https://cdn.jsdelivr.net/npm/@fontsource-variable/source-serif-4@5.3.0/index.css",
  "https://cdn.jsdelivr.net/npm/@fontsource-variable/noto-serif-sc@5.3.0/index.css",
)

#let scripts = ("/assets/code-blocks.js", "/assets/site.js")

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
  "©" + str(datetime.today().year()) + " Shouzhuo Yi",
  [Powered by #link("https://github.com/Yousa-Mirage/Tufted-Blog-Template")[Tufted-Blog-Template of _Typst_]],
)

// ─────────────────────────────────────────────────────────────────────────────
// 人物侧栏
//
// 每个页面都带同一块侧栏。图片按项目根给绝对路径，
// 因为这里定义、页面在 content/ 下，字符串字面量不在页面里。
// ─────────────────────────────────────────────────────────────────────────────
#let profile = (
  html.elem("div", attrs: (class: "profile"), {
    ui.avatar(image("/content/imgs/me.jpg", alt: "易守拙"))
    ui.author("易守拙", bio: "Shouzhuo Yi · WHU")
  }),
  ui.side-block("题词", [
    _花儿育种而凋 / 我们学会淡忘_ \
    _Flowers bloom only to wither/ We learn to let them fade_
  ]),
  ui.side-block("联系", ui.contact-list((
    ("Email", link("mailto:yishouzhuo@whu.edu.cn")[yishouzhuo\@whu.edu.cn]),
    ("GitHub", link("https://github.com/whoisKIWIIZZZ")[whoisKIWIIZZZ]),
    ("WeChat", "yisz0519"),
    ("网易云", "kiwiizzz"),
    ("Bilibili", link("https://space.bilibili.com/454587686")[kiwiizzz]),
    ("CV", link("https://whoiskiwiizzz.github.io/CV/")[CV]),
    ("地址", [E514, School of Computer Science, Wuhan University]),
  ))),
)

// 单栏版式：CV / Projects / Memoir
#let template = page.with(
  title: "Shouzhuo Yi",
  lang: "zh",
  layout: "doc",
  nav: nav-links,
  sidebar: profile,
  css: fonts + ("/assets/site.css",),
  js-scripts: scripts,
  footer-elements: footer-links,
)

// 双栏版式：首页
#let home = page.with(
  title: "Shouzhuo Yi",
  lang: "zh",
  layout: "profile",
  nav: nav-links,
  sidebar: profile,
  css: fonts + ("/assets/site.css",),
  js-scripts: scripts,
  footer-elements: footer-links,
)
