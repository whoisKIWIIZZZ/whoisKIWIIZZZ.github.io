#import "../config.typ": template, tufted
#show: template
#let hr() = html.elem("hr")
#let profile-entry(title, date, detail, logo: none) = {
  html.elem("div", attrs: (class: "profile-entry"), {
    if logo != none {
      html.elem(
        "div",
        attrs: (class: "profile-entry-logo"),
        image(logo, width: 42pt, alt: title),
      )
    }
    html.elem("div", attrs: (class: "profile-entry-body"), {
      html.elem("div", attrs: (class: "profile-entry-main"), {
        html.elem("strong", attrs: (class: "profile-entry-title"), title)
        html.elem("span", attrs: (class: "profile-entry-date"), date)
      })
      html.elem("div", attrs: (class: "profile-entry-detail"), detail)
    })
  })
}
// 侧边栏：放置头像和一句话简介
#tufted.margin-note({
  // 请确保路径下有你的照片，或者修改为 assets/me.jpg
  image("./imgs/me.jpg", width: 20em)
})

#tufted.margin-note[
  *易守拙 (Shouzhuo Yi)* \
  WHU \
  _花儿育种而凋 / 我们学会淡忘_\
  _Flowers bloom only to wither/ We learn to let them fade_
]

= 易守拙 - Shouzhuo Yi
#hr()
Undergraduate student at *Hongyi Honor College*, School of Computer Science, *Wuhan University* .
#html.elem("section", attrs: (class: "profile-section profile-section--education"), [
  == Education
  #profile-entry(
    "武汉大学",
    "2024 - 2028",
    "计算机科学与技术 (计算机弘毅班)",
    logo: "./imgs/whu.png",
  )
])

#html.elem("section", attrs: (class: "profile-section profile-section--experience"), [
  == Experience
  #profile-entry(
    "SIGMA lab,WHU",
    "2025.1 - 2025.7",
    "Research Assistant",
    logo: "./imgs/whu.png",
  )
  #profile-entry(
    "LAMP,UCAS",
    "2026.9 - ",
    "Intern",
    logo: "./imgs/whu.png",
  )
])

== 🔍 Research Interests
#hr()
- Source-Free Domain Adaptation
- Neural Cellular Automata
- World Model
== 💻 Projects
#hr()
=== 1.故事成片 Story-to-video
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Kotlin,Python
  ]
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    _Teamwork. I've implemented the local LLM integration and optimized inter-service communication._
  ]
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    2025.11 - 2025.12
  ]
]
实现了“自然文本输入到视频产出”的全链路自动化,实现可视化分镜管理、单镜头编辑,并整合了图像生成、动态视频渲染及 AI 配音技术.

Achieved full-link automation from text-to-video production, incorporating visual storyboard management and per-shot editing capabilities. It seamlessly orchestrates image generation, dynamic video rendering, and AI-powered narration into a unified workflow.

#link("https://github.com/menglongyan49-jpg/ai-story-video/tree/main")[View Project →]

#line(length: 100%, stroke: 0.5pt + gray)

=== 2.Rust-Minimeter
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Rust
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    _Work all by myself._
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    2026.1
  ]
]
一个基于 *egui* 和 *cpal* 开发的高性能实时音频可视化工具,实时查看声场、波形、频谱、LUFS/响度,用于拟合 MiniMeter的功能.

A high-performance, real-time audio visualization tool built with *egui* and *cpal*. It provides live monitoring of sound fields, waveforms, spectrums, and LUFS/loudness, designed to match the functionality of MiniMeter.

#link("https://whoiskiwiizzz.github.io/Projects/01-minimeter/")[View Project →]

#line(length: 100%, stroke: 0.5pt + gray)
=== 3.RISCV-PIPELINE-CPU
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Verilog,C
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    _Teamwork._
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    2026.5-2026.8
  ]
]
本项目系武汉大学计算机学院“计算机系统综合设计A”课程设计作业,实现了五级流水线CPU并实现了MIDI键盘功能.

#link("https://whoiskiwiizzz.github.io/Projects/02-SCPU/")[View Project →]
#link("https://github.com/whoisKIWIIZZZ/SCPU-RISCV")[View Code →]

=== 4.OSOSOS
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Rust
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    _Teamwork._
  ]\
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    2026.5-2026.8
  ]
]
支持RISC-V和LoongArch双架构的单核宏内核操作系统设计,为2026全国大学生系统能力大赛操作系统内核赛作品.获得国家二等奖.

#link("https://gitlab.eduxiji.net/T2026104869910278/oskernel2026-ososos")[View Code →]

== Music I've made
#tufted.margin-note[
  1.*BACK 2 U* _VIP,SINGLE_ \
  Macrame Music & 未界名 \
  2022.9.21
\ \ \ \
  2.*虹* _ VOL\.2 EP_ \
  Artists: kiwiizzz,NeonNeko,北洄,DJ Zeng,\ $quad quad quad$L?NX,L350iR,L1ghtF4ll,crash909☆\
  Macrame Music & 未界名\
  2023.3.15
\ \ \ \ \ \ \ \ \ \
  3.*栩栩 Lifelike* _kiwiizzz remix_ \
  Artists: kiwiizzz,BYDGALAXY\
  SELF RELEASE\
  2024.1.1
\ \ \ \
  4.*溯江寻兰赋* _in_ *Words Des Flowers* _LP_\
  Artists: kiwiizzz,北洄\
  Glimmer Music\
  2024.2.4
]
#table(
  columns: (1fr, 1fr),
  // 两列等宽
  stroke: none,
  gutter: 0em,
  // 间距
  image("./imgs/album4.jpg", width: 100%), image("./imgs/album1.jpg", width: 100%),
  image("./imgs/album2.jpg", width: 100%), image("./imgs/album3.jpg", width: 100%),
)

== 📬 Contact
#hr()
- *Email:* #link("mailto:yishouzhuo@whu.edu.cn")[yishouzhuo\@whu.edu.cn]
- *GitHub:* #link("https://github.com/whoisKIWIIZZZ")[whoisKIWIIZZZ]
- *WeChat:* yisz0519
- *NetEase Music* kiwiizzz
- *Bilibili:* #link("https://space.bilibili.com/454587686")[kiwiizzz]
- *Address:* E514, School of Computer Science, Wuhan University
-  *CV*:#link("https://whoiskiwiizzz.github.io/CV/")[CV]
