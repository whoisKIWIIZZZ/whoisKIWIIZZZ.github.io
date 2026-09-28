/*******************************************************************************
页面骨架

标记与 guanchengwan.github.io 的 DOM 一一对应：

  .masthead > .masthead__inner-wrap > .masthead__menu > .greedy-nav
  #main > (.sidebar > .profile_box) + (.page > .page__inner-wrap > .page__content)
  .page__footer > footer

数学公式与脚注在 HTML 下的渲染规则也放在这里。
*******************************************************************************/


// ─────────────────────────────────────────────────────────────────────────────
// HTML 渲染规则
// ─────────────────────────────────────────────────────────────────────────────

/// 行内 / 块级公式在 HTML 里输出成 SVG frame
#let show-math(content) = {
  set math.equation(numbering: "(1)")

  show math.equation.where(block: false): it => if target() == "html" {
    html.span(role: "math", html.frame(it))
  } else {
    it
  }

  show math.equation.where(block: true): it => if target() == "html" {
    html.figure(role: "math", html.frame(it))
  } else {
    it
  }

  content
}

/// 脚注编号
#let show-notes(content) = {
  set footnote(numbering: "*")
  content
}

/// 图片说明放在图片下方
#let show-figures(content) = {
  show figure: it => if target() == "html" {
    html.figure(it.caption + it.body)
  }
  content
}


// ─────────────────────────────────────────────────────────────────────────────
// 顶栏
// ─────────────────────────────────────────────────────────────────────────────

#let nav-bar(links) = html.elem("div", attrs: (class: "masthead"), {
  html.elem("div", attrs: (class: "masthead__inner-wrap"), {
    html.elem("div", attrs: (class: "masthead__menu"), {
      html.elem("nav", attrs: (id: "site-nav", class: "greedy-nav"), {
        html.elem("button", attrs: (type: "button", class: "close"), {
          html.elem("div", attrs: (class: "navicon"), {})
        })
        html.elem("ul", attrs: (class: "visible-links"), {
          for (href, label) in links {
            // 首页那一项在窄屏下由 CSS 藏起来，与参考站一致
            let home = if href == "/" { " masthead__menu-home-item" } else { "" }
            html.elem(
              "li",
              attrs: (class: "masthead__menu-item" + home),
              { html.a(href: href, label) },
            )
          }
        })
        html.elem("ul", attrs: (class: "hidden-links hidden"), {})
      })
    })
  })
})


// ─────────────────────────────────────────────────────────────────────────────
// 页面
// ─────────────────────────────────────────────────────────────────────────────

#let page(
  content,
  title: "Shouzhuo Yi",
  lang: "zh",
  nav: (),
  sidebar: (),
  footer-copyright: "",
  footer-follow: (),
  css: (),
  icon: "/assets/favicon.ico",
  js-scripts: (),
) = {
  show: show-math
  show: show-notes
  show: show-figures

  set text(lang: lang)

  html.html(
    lang: lang,
    {
      html.head({
        html.meta(charset: "utf-8")
        html.title(title)
        html.link(rel: "icon", href: icon)
        html.meta(name: "theme-color", content: "#ffffff")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")

        for (href) in css {
          html.link(rel: "stylesheet", href: href)
        }
        for (src) in js-scripts {
          html.script(src: src)
        }
      })

      html.body({
        nav-bar(nav)

        html.elem("div", attrs: (id: "main", role: "main"), {
          html.elem("div", attrs: (class: "sidebar sticky"), sidebar.join())
          html.elem("article", attrs: (class: "page"), {
            html.elem("div", attrs: (class: "page__inner-wrap"), {
              html.elem("section", attrs: (class: "page__content"), content)
            })
          })
        })

        html.elem("div", attrs: (class: "page__footer"), {
          html.elem("footer", attrs: (:), {
            if footer-copyright != "" {
              html.elem("div", attrs: (class: "page__footer-copyright"), footer-copyright)
            }
            if footer-follow.len() > 0 {
              html.elem("div", attrs: (class: "page__footer-follow"), {
                html.elem("ul", attrs: (:), {
                  for (href, label) in footer-follow {
                    html.elem("li", attrs: (:), { html.a(href: href, label) })
                  }
                })
              })
            }
          })
        })
      })
    },
  )
}
