#import "lib/site.typ": page
#import "lib/components.typ" as ui

// ─────────────────────────────────────────────────────────────────────────────
// 站点外观
//
// 版式来自 guanchengwan.github.io，样式表只有一份：assets/site.css。
//
// 字体与参考站完全一致，一共三套：
//   Trebuchet MS  正文与界面（参考站的基准字体，系统自带，零下载）
//   Fraunces      大标题（参考站 .founder-hero__title 用的那套）
//   Sora          拉开字距的大写标签（参考站 .founder-hero__eyebrow 用的那套）
//
// 参考站自己是从 fonts.googleapis.com 引的，那边在国内访问不稳，
// 这里换 jsdelivr 上的 fontsource，同一批字体文件，unicode-range 分片一致。
// ─────────────────────────────────────────────────────────────────────────────
#let css = (
  "https://cdn.jsdelivr.net/npm/@fontsource-variable/fraunces@5.3.0/index.css",
  "https://cdn.jsdelivr.net/npm/@fontsource-variable/sora@5.3.0/index.css",
  "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css",
  // 登录过站点的浏览器缓存了旧版 CSS（曾有头像圆角残留的旧版本），
  // 版本号变化迫使浏览器强制拉新；更新 site.css 样式后记得把 v= 递增
  "/assets/site.css?v=2",
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
  "/Awards/": "Awards",
)



// ─────────────────────────────────────────────────────────────────────────────
// 人物侧栏
//
// `ui.profile` 的第三个参数是联系入口的 (图标类名, 文字, 链接) 序列。
// 图标从 Font Awesome 取：fas fa-envelope、fas fa-graduation-cap、
// fab fa-github、fas fa-music、fas fa-file-pdf 等。
// ─────────────────────────────────────────────────────────────────────────────
#let profile = ui.profile(
  image("content/imgs/me.jpg", alt: "Shouzhuo Yi"),
  "Shouzhuo Yi",
  bio: "Hongyi Honor Class, School of Computer Science, Wuhan University",
  links: (
    ("fas fa-envelope", "Email", "mailto:yishouzhuo@whu.edu.cn"),
    ("fab fa-github", "GitHub", "https://github.com/whoisKIWIIZZZ"),
    // ("fas fa-graduation-cap", "Google Scholar", "https://scholar.google.com/"),
    // // Font Awesome 5 免费版没有 fa-bilibili，用 fa-play 表示视频站
    // ("fas fa-play", "Bilibili", "https://space.bilibili.com/454587686"),
  ),
)

#let template = page.with(
  title: "Shouzhuo Yi",
  lang: "zh",
  nav: nav-links,
  sidebar: (profile,),
  footer-copyright: "© " + str(datetime.today().year()) + " Shouzhuo Yi.Thx Typst!",
  css: css,
  js-scripts: js-scripts,
)
