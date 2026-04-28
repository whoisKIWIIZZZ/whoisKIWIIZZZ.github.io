#import "../../../config.typ": html-grid, template, tufted
#show: template.with(title: "Project: Rust-Minimeter")

#let hr() = html.elem("hr")

// --- 侧边栏：放置项目标签与元数据 ---
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Verilog, C
  ] \
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Version:* why we need this?
  ] \
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Release:* 2026.5
  ]
]

= SCPU