/*******************************************************************************
页面模板

两种版式共用一套骨架：

  layout: "profile"  侧栏 + 正文（首页）
  layout: "doc"      单栏正文（CV / Projects / Memoir）

数学公式、脚注、交叉引用在 HTML 下的渲染规则也放在这里。
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

/// 脚注：正文里放上标，注文收进文末的脚注区
#let show-notes(content) = {
  set footnote(numbering: "*")
  content
}

/// 图片说明统一放在图片下方
#let show-figures(content) = {
  show figure: it => if target() == "html" {
    html.figure(it.caption + it.body)
  }
  content
}


// ─────────────────────────────────────────────────────────────────────────────
// 顶栏
// ─────────────────────────────────────────────────────────────────────────────

#let nav-bar(links) = html.elem("header", attrs: (class: "masthead"), {
  html.elem("div", attrs: (class: "masthead__inner-wrap"), {
    html.elem("nav", attrs: (class: "greedy-nav", id: "site-nav"), {
      html.elem("ul", attrs: (class: "visible-links"), {
        for (href, label) in links {
          html.elem(
            "li",
            attrs: (class: "masthead__menu-item" + (if href == "/" { " masthead__menu-item--home" } else { "" })),
            { html.a(href: href, label) },
          )
        }
      })
      html.elem("ul", attrs: (class: "hidden-links"), {})
      html.elem("div", attrs: (class: "nav-actions"), {
        html.elem("button", attrs: (class: "theme-toggle", type: "button", aria-label: "切换深浅色"), {})
        html.elem("button", attrs: (class: "nav-toggle", type: "button", aria-label: "菜单"), {
          html.elem("span", attrs: (class: "navicon"), {})
        })
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
  layout: "doc",
  nav: (),
  sidebar: (),
  footer-elements: (),
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
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.title(title)
        html.link(rel: "icon", href: icon)
        html.meta(name: "theme-color", content: "#f7f2e6")

        for (href) in css {
          html.link(rel: "stylesheet", href: href)
        }
        for (src) in js-scripts {
          html.script(src: src)
        }
      })

      html.body({
        nav-bar(nav)

        html.elem("div", attrs: (id: "main"), {
          html.elem("aside", attrs: (class: "sidebar"), sidebar.join())
          html.elem("article", attrs: (class: "page"), {
            html.elem("div", attrs: (class: "page__inner-wrap"), {
              html.elem("section", attrs: (class: "page__content"), content)
            })
          })
        })

        html.elem("footer", attrs: (class: "page__footer"), {
          html.elem("footer", attrs: (:), {
            for (i, element) in footer-elements.enumerate() {
              if i > 0 {
                html.elem("span", attrs: (class: "footer-sep"), "·")
              }
              element
            }
          })
        })
      })
    },
  )
}
