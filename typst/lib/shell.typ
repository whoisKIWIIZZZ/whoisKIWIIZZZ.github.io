/*******************************************************************************
侧栏版式模板

与 tufted-lib 的单栏版式相对：左侧固定人物栏，右侧正文栏。
首页使用这个模板；CV / Projects / Memoir 等长文页面继续用单栏模板。
*******************************************************************************/

#import "../tufted-lib/tufted.typ" as tufted-lib

#let profile-web(
  header-links: (),
  title: "Shouzhuo Yi",
  lang: "zh",
  sidebar: (),
  footer-elements: (),
  css: (),
  icon: "/assets/favicon.ico",
  js-scripts: (),
  content,
) = {
  show: tufted-lib.template-math
  show: tufted-lib.template-refs
  show: tufted-lib.template-notes
  show: tufted-lib.template-figures

  set text(lang: lang)

  html.html(
    lang: lang,
    {
      html.head({
        html.meta(charset: "utf-8")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.title(title)
        html.link(rel: "icon", href: icon)

        for (css-link) in css {
          html.link(rel: "stylesheet", href: css-link)
        }
        for (js-src) in js-scripts {
          html.script(src: js-src)
        }
      })

      html.body({
        html.header(
          class: "site-header",
          html.elem("nav", attrs: (:), {
            html.a(href: "/", "Home")
            for (href, label) in header-links {
              if href != "/" {
                html.a(href: href, label)
              }
            }
          }),
        )

        html.elem("div", attrs: (class: "shell"), {
          html.elem("aside", attrs: (class: "sidebar"), sidebar.join())
          html.elem("main", attrs: (class: "content"), {
            html.elem("section", attrs: (:), content)
          })
        })

        html.footer(class: "site-footer", {
          for (i, element) in footer-elements.enumerate() {
            if i > 0 {
              html.elem("span", attrs: (class: "footer-sep"), "·")
            }
            element
          }
        })
      })
    },
  )
}
