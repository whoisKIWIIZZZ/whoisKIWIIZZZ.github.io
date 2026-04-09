#import "../config.typ": template, tufted
#show: template
#let hr() = html.elem("hr")
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
I am an undergraduate student at the *School of Computer Science, Wuhan University (2024 - Now)*.

I am dedicated to developing CLIP-based multimodal Source-Free Domain Adaptation (SFDA) and Weakly Supervised Learning methods.
#line(length: 100%, stroke: 0.5pt + gray)
== 🔍 Research Interests
#hr()
- *CLIP-based Multimodal SFDA*
- *Medical Image Segmentation*
- *Computability Theory*

== 💻 Projects
#hr()
=== 故事成片 Story-to-video
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

#metadata((
  tag: "div",
  attributes: (class: "contribution-graph"),
  children: (
    (tag: "h3", children: ("📊 Contribution Activity",)),
    (tag: "div", attributes: (id: "heatmap", class: "heatmap"), children: ())
  )
)) <contribution-graph>

// 加载 JS 脚本
#metadata((
  tag: "script",
  attributes: (src: "/assets/contributions.js"),
  children: ()
)) <contribution-script>
=== Rust-Minimeter
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

#link("https://yisz.top/Projects")[View Project →]

#line(length: 100%, stroke: 0.5pt + gray)

== 📄 CV & More
#hr()
- #link("https://yisz.top/CV")[CV]
== Commit
#hr()

#v(2em)
#line(length: 100%, stroke: 0.5pt + gray)
// #set text(size: 0.8em, fill: gray)
== Knowledge Graph
#hr()
thx Claude Sonnet 4.6.
#line(length: 100%, stroke: 0.5pt + gray)
== 📬 Contact
#hr()
- *Email:* #link("mailto:yishouzhuo@whu.edu.cn")[yishouzhuo\@whu.edu.cn]
- *GitHub:* #link("https://github.com/shouzhuoyi")[shouzhuoyi]
- *WeChat:* yisz0519
- *Address:* E514, School of Computer Science, Wuhan University
