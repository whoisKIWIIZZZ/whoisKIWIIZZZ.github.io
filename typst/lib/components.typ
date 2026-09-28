/*******************************************************************************
页面组件

版式来自 guanchengwan.github.io（Minimal Mistakes 主题），
类名与那套 CSS 一一对应；这里只负责生成标记。

页面里这样用：

  #import "../../config.typ": template, ui

  #ui.title("易守拙 (Yi Shouzhuo)")
  #ui.section("Education")[
    #ui.entry("武汉大学", date: "2024 - 2028", logo: image("./imgs/whu.png"))[计算机弘毅班]
  ]

图片路径由 Typst 在 `image()` 调用处解析，所以页面里写
`image("./imgs/whu.png")` 与原来一致；直接写字符串则按项目根解析。
*******************************************************************************/


// ─────────────────────────────────────────────────────────────────────────────
// 基础零件
// ─────────────────────────────────────────────────────────────────────────────

/// 图片取值归一化
#let img(p, alt: "") = if type(p) == str { image(p, alt: alt) } else { p }

/// Font Awesome 图标。`name` 写完整类名，如 "fas fa-envelope"
#let icon(name, fw: true) = html.elem(
  "i",
  attrs: (class: name + (if fw { " fa-fw" } else { "" }), aria-hidden: "true"),
  {},
)

/// 引用块。Typst 的 `>` 语法在 HTML 里会变成带「>」前缀的普通段落，
/// 要拿到真正的 <blockquote> 得自己发这个标签
#let quote(body) = html.elem("blockquote", attrs: (:), body)

/// 带细边框的图片
#let figure(path, alt: "") = html.elem(
  "figure",
  attrs: (class: "figure"),
  img(path, alt: alt),
)

/// 一排链接
#let links(items) = html.elem("div", attrs: (class: "entry-links"), {
  for (label, href) in items {
    html.a(href: href, label)
  }
})

/// 说明框，复用参考站 .notice 的样式
#let notice(body) = html.elem(
  "div",
  attrs: (class: "notice"),
  html.elem("p", attrs: (:), body),
)

/// 页面顶部的元信息（技术栈、版本之类）
#let meta(body) = html.elem("div", attrs: (class: "meta"), body)


// ─────────────────────────────────────────────────────────────────────────────
// 侧栏人物块
// ─────────────────────────────────────────────────────────────────────────────

/// 侧栏人物块
//
// `links` 为 (图标类名, 文字, 链接) 序列。
// 桌面端渲染成「图标 + 文字」列表；窄屏只留图标，点一下展开完整列表。
// 参考站就是点 `.author__urls-wrapper` 展开的，它页面上那个
// "More Info & Contact" 按钮被注释掉了，所以这里默认不出，label 传值才出。
#let profile(
  photo,
  name,
  bio: none,
  links: (),
  label: none,
) = html.elem("div", attrs: (class: "profile_box"), {
  html.elem("div", attrs: (class: "author__avatar"), {
    img(photo, alt: name)
  })
  html.elem("div", attrs: (class: "author__content"), {
    html.elem("h3", attrs: (class: "author__name"), name)
    if bio != none {
      html.elem("p", attrs: (class: "author__bio"), bio)
    }
  })
  html.elem("div", attrs: (class: "author__urls-wrapper"), {
    if label != none {
      html.elem("button", attrs: (type: "button", class: "btn author__urls-toggle"), label)
    }
    html.elem("ul", attrs: (class: "author__urls social-icons"), {
      for (ic, text, href) in links {
        html.elem("li", attrs: (:), {
          html.a(href: href, {
            icon(ic)
            text
          })
        })
      }
    })
    html.elem("div", attrs: (class: "author__urls_sm"), {
      for (ic, text, href) in links {
        html.elem(
          "a",
          attrs: (href: href, aria-label: text, title: text),
          { icon(ic, fw: false) },
        )
      }
    })
  })
})


// ─────────────────────────────────────────────────────────────────────────────
// 正文区块
// ─────────────────────────────────────────────────────────────────────────────

/// 页面标题。Typst 的 HTML 导出把标题下移一级，
/// 所以页面里写 `= 标题` 得到的是 `<h2>`；这里直接给 `<h1>`，
/// 正好命中参考站 `.page__content h1` 的那条下边框
#let title(text) = html.elem("h1", attrs: (class: "page__title"), text)

/// 章节
#let section(heading, body) = html.elem("section", attrs: (class: "sect"), {
  html.elem("h2", attrs: (class: "sect-title"), heading)
  body
})


// ─────────────────────────────────────────────────────────────────────────────
// 条目
// ─────────────────────────────────────────────────────────────────────────────

/// 教育 / 经历条目。`body` 为副标题（职位、方向等）
#let entry(heading, body, date: none, logo: none) = html.elem(
  "div",
  attrs: (class: "entry"),
  {
    if logo != none {
      html.elem(
        "div",
        attrs: (class: "entry-logo"),
        img(logo, alt: heading),
      )
    }
    html.elem("div", attrs: (class: "entry-body"), {
      html.elem("div", attrs: (class: "entry-head"), {
        html.elem("h3", attrs: (class: "entry-title"), heading)
        if date != none {
          html.elem("span", attrs: (class: "entry-date"), date)
        }
      })
      if body != none {
        html.elem("p", attrs: (class: "entry-detail"), body)
      }
    })
  },
)

/// 研究兴趣：带序号的短列表
#let interests(items) = html.elem("ul", attrs: (class: "interests"), {
  for (i, item) in items.enumerate() {
    html.elem("li", attrs: (class: "interest"), {
      html.elem("span", attrs: (class: "interest-index"), numbering("01", i + 1))
      html.elem("span", attrs: (class: "interest-text"), item)
    })
  }
})


// ─────────────────────────────────────────────────────────────────────────────
// 卡片
// ─────────────────────────────────────────────────────────────────────────────

/// 项目卡片
#let project(
  heading,
  body,
  date: none,
  index: none,
  stack: none,
  role: none,
  outlinks: (),
) = html.elem("article", attrs: (class: "card"), {
  html.elem("div", attrs: (class: "card-head"), {
    if index != none {
      html.elem("span", attrs: (class: "card-index"), index)
    }
    html.elem("h3", attrs: (class: "card-title"), heading)
    if date != none {
      html.elem("span", attrs: (class: "card-date"), date)
    }
  })
  html.elem("div", attrs: (class: "card-body"), body)
  if stack != none or role != none {
    html.elem("div", attrs: (class: "card-foot"), {
      if stack != none {
        html.elem("p", attrs: (class: "card-meta"), {
          html.elem("span", attrs: (class: "card-meta-key"), "Tech Stack")
          html.elem("span", attrs: (class: "card-meta-val"), stack)
        })
      }
      if role != none {
        html.elem("p", attrs: (class: "card-note"), role)
      }
    })
  }
  if outlinks.len() > 0 {
    links(outlinks)
  }
})

/// 论文条目
#let paper(
  heading,
  authors,
  venue: none,
  year: none,
  note: none,
  outlinks: (),
) = html.elem("article", attrs: (class: "paper"), {
  html.elem("h3", attrs: (class: "paper-title"), heading)
  html.elem("p", attrs: (class: "paper-authors"), authors)
  if venue != none or year != none {
    html.elem("p", attrs: (class: "paper-venue"), {
      if venue != none { venue }
      if venue != none and year != none { ", " }
      if year != none { year }
    })
  }
  if note != none {
    html.elem("p", attrs: (class: "paper-note"), note)
  }
  if outlinks.len() > 0 {
    links(outlinks)
  }
})

// ─────────────────────────────────────────────────────────────────────────────
// 列表页
//
// Awards / Honors 这类页面用。一条一行，年份靠右；
// 传 `link` 会出链接，传 `badge` 会在名字后面挂一个小标签。
//
//   #ui.awards[
//     #ui.award("名称", issuer: "单位", year: "2026")
//     #ui.award("名称", body: [说明。], year: "2026", badge: [特等奖])
//   ]
//
// 传内容块而不是数组，是因为 Typst 的具名参数在数组字面量里不认，
// 写成数组的话只能按位置排，可读性差很多。
// ─────────────────────────────────────────────────────────────────────────────

/// 奖项 / 荣誉条目
#let award(
  name,
  body: none,
  issuer: none,
  year: none,
  link: none,
  badge: none,
) = html.elem("li", attrs: (class: "award"), {
  html.elem("div", attrs: (class: "award-main"), {
    html.elem("span", attrs: (class: "award-name"), name)
    if badge != none {
      html.elem("span", attrs: (class: "award-badge"), badge)
    }
    if issuer != none {
      html.elem("span", attrs: (class: "award-issuer"), issuer)
    }
  })
  if year != none {
    html.elem("span", attrs: (class: "award-year"), year)
  }
  if body != none {
    html.elem("p", attrs: (class: "award-detail"), body)
  }
  if link != none {
    html.elem("p", attrs: (class: "entry-links"), links((link,)))
  }
})

/// 奖项 / 荣誉列表
#let awards(body) = html.elem("ul", attrs: (class: "awards"), body)

/// 时间线上的一条：获奖、经历、论文都能套这个壳
#let timeline-entry(when, what, body: none, link: none) = html.elem(
  "li",
  attrs: (class: "tl-item"),
  {
    html.elem("span", attrs: (class: "tl-when"), when)
    html.elem("div", attrs: (class: "tl-body"), {
      html.elem("h3", attrs: (class: "tl-what"), what)
      if body != none {
        html.elem("p", attrs: (class: "tl-detail"), body)
      }
      if link != none {
        html.elem("p", attrs: (class: "entry-links"), links((link,)))
      }
    })
  },
)

/// 时间线
#let timeline(body) = html.elem("ul", attrs: (class: "timeline"), body)


// ─────────────────────────────────────────────────────────────────────────────
// 专辑
// ─────────────────────────────────────────────────────────────────────────────

/// 专辑：曲目表 + 封面
#let release(items, covers) = html.elem("div", attrs: (class: "release"), {
  html.elem("ol", attrs: (class: "tracks"), {
    for (i, track) in items.enumerate() {
      html.elem("li", attrs: (class: "track"), {
        html.elem("span", attrs: (class: "track-no"), str(i + 1) + ".")
        html.elem("div", attrs: (class: "track-body"), {
          html.elem("p", attrs: (class: "track-title"), track.title)
          if track.at("album", default: none) != none {
            html.elem("p", attrs: (class: "track-album"), track.album)
          }
          if track.at("artists", default: none) != none {
            html.elem("p", attrs: (class: "track-artists"), track.artists)
          }
        })
        if track.at("date", default: none) != none {
          html.elem("span", attrs: (class: "track-date"), track.date)
        }
      })
    }
  })
  html.elem("div", attrs: (class: "covers"), {
    for cover in covers {
      html.elem("figure", attrs: (class: "cover"), img(cover.path))
    }
  })
})
