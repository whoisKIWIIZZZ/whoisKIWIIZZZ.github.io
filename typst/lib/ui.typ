/*******************************************************************************
纸墨 (Paper & Ink) — 页面组件库

所有页面组件都在这里定义，content/ 下的页面只负责调用，不写样式类名。
样式定义在 assets/site.css，改外观只改 CSS，不改这里。

用法：

  #import "../config.typ": home, ui

  #ui.masthead("易守拙 - Shouzhuo Yi")[ ... ]
  #ui.section("Education")[
    #ui.entry("武汉大学", date: "2024 - 2028", logo: "./imgs/whu.png")[ ... ]
  ]

组件里的图片路径由 Typst 按字符串字面量所在的位置解析，
所以在 content/index.typ 里写 "./imgs/me.jpg" 与原来一致。
*******************************************************************************/


// ─────────────────────────────────────────────────────────────────────────────
// 基础零件
// ─────────────────────────────────────────────────────────────────────────────

/// 图片取值归一化。
///
/// Typst 在 `image()` 调用处解析相对路径，而不是在字符串字面量所在处。
/// 所以组件里不能直接把页面传来的字符串喂给 `image()`。
/// 两种写法都接受：
///   - 字符串：按项目根解析，必须以 "/" 开头，例如 "/content/imgs/me.jpg"
///   - content：页面自己写 `image("./imgs/me.jpg")`，路径相对页面文件解析
#let img(p, alt: "") = if type(p) == str { image(p, alt: alt) } else { p }

/// 带边框的图片（BLOG 正文里插图用这个）
#let figure(path, alt: "", cls: "") = html.elem(
  "figure",
  attrs: (class: "figure" + (if cls == "" { "" } else { " " + cls })),
  img(path, alt: alt),
)

/// 联系表：`entries` 为 (标签, 内容) 序列
#let contact-list(entries) = html.elem("dl", attrs: (class: "contact"), {
  for (label, value) in entries {
    html.elem("dt", attrs: (:), label)
    html.elem("dd", attrs: (:), value)
  }
})


// ─────────────────────────────────────────────────────────────────────────────
// 侧栏
// ─────────────────────────────────────────────────────────────────────────────

/// 身份块：照片、姓名、单位、题词
#let identity(
  photo,
  name,
  latin: none,
  affiliation: (),
  motto: none,
) = html.elem("div", attrs: (class: "identity"), {
  html.elem("div", attrs: (class: "identity-photo"), {
    img(photo, alt: name)
  })
  html.elem("h1", attrs: (class: "identity-name"), name)
  if latin != none {
    html.elem("p", attrs: (class: "identity-latin"), latin)
  }
  if affiliation.len() > 0 {
    html.elem("p", attrs: (class: "identity-affiliation"), {
      for (i, line) in affiliation.enumerate() {
        if i > 0 { html.br() }
        line
      }
    })
  }
  if motto != none {
    html.elem("p", attrs: (class: "identity-motto"), motto)
  }
})

/// 侧栏小节：`title` 为栏目标题
#let side-block(title, body) = html.elem("div", attrs: (class: "side-block"), {
  html.elem("h2", attrs: (class: "side-title"), title)
  html.elem("div", attrs: (class: "side-body"), body)
})


// ─────────────────────────────────────────────────────────────────────────────
// 正文区块
// ─────────────────────────────────────────────────────────────────────────────

/// 首页主栏开头的大标题区
#let masthead(name, tagline) = html.elem("header", attrs: (class: "masthead"), {
  html.elem("h1", attrs: (class: "masthead-name"), name)
  html.elem("p", attrs: (class: "masthead-tagline"), tagline)
  html.elem("div", attrs: (class: "masthead-rule"), {})
})

/// 章节：`title` 为栏目标题，`meta` 为右对齐补充说明
#let section(title, body, meta: none) = html.elem("section", attrs: (class: "sect"), {
  html.elem("h2", attrs: (class: "sect-title"), {
    html.elem("span", attrs: (class: "sect-label"), title)
    if meta != none {
      html.elem("span", attrs: (class: "sect-meta"), meta)
    }
  })
  html.elem("div", attrs: (class: "sect-body"), body)
})


// ─────────────────────────────────────────────────────────────────────────────
// 条目
// ─────────────────────────────────────────────────────────────────────────────

/// 教育 / 经历条目。`body` 为副标题（机构、职位、方向等）
#let entry(title, body, date: none, logo: none) = html.elem(
  "div",
  attrs: (class: "entry"),
  {
    if logo != none {
      html.elem(
        "div",
        attrs: (class: "entry-logo"),
        img(logo, alt: title),
      )
    }
    html.elem("div", attrs: (class: "entry-body"), {
      html.elem("div", attrs: (class: "entry-head"), {
        html.elem("h3", attrs: (class: "entry-title"), title)
        if date != none {
          html.elem("span", attrs: (class: "entry-date"), date)
        }
      })
      html.elem("p", attrs: (class: "entry-detail"), body)
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

/// 一排链接按钮
#let links(items) = html.elem("div", attrs: (class: "links"), {
  for (label, href) in items {
    html.elem("a", attrs: (href: href, class: "link-chip"), {
      html.elem("span", attrs: (:), label)
      html.elem("span", attrs: (class: "link-arrow"), "→")
    })
  }
})

/// 项目卡片
#let project(
  title,
  body,
  date: none,
  index: none,
  stack: none,
  role: none,
  outlinks: (),
) = html.elem("article", attrs: (class: "card"), {
  html.elem("header", attrs: (class: "card-head"), {
    if index != none {
      html.elem("span", attrs: (class: "card-index"), index)
    }
    html.elem("h3", attrs: (class: "card-title"), title)
    if date != none {
      html.elem("span", attrs: (class: "card-date"), date)
    }
  })
  html.elem("div", attrs: (class: "card-body"), body)
  if stack != none or role != none {
    html.elem("footer", attrs: (class: "card-foot"), {
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
  title,
  authors,
  venue: none,
  year: none,
  note: none,
  outlinks: (),
) = html.elem("article", attrs: (class: "paper"), {
  html.elem("h3", attrs: (class: "paper-title"), title)
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

/// 专辑：左侧曲目表，右侧封面
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
