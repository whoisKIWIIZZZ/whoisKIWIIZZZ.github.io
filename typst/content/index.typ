#import "../config.typ": home, ui
#show: home.with(
  sidebar: (
    ui.identity(
      image("./imgs/me.jpg", alt: "易守拙"),
      "易守拙",
      latin: "Shouzhuo Yi",
      affiliation: ("WHU", "School of Computer Science, Wuhan University"),
      motto: [
        _花儿育种而凋 / 我们学会淡忘_ \
        _Flowers bloom only to wither/ We learn to let them fade_
      ],
    ),
    ui.side-block("联系", ui.contact-list((
      ("Email", link("mailto:yishouzhuo@whu.edu.cn")[yishouzhuo\@whu.edu.cn]),
      ("GitHub", link("https://github.com/whoisKIWIIZZZ")[whoisKIWIIZZZ]),
      ("WeChat", "yisz0519"),
      ("网易云", "kiwiizzz"),
      ("Bilibili", link("https://space.bilibili.com/454587686")[kiwiizzz]),
      ("CV", link("https://whoiskiwiizzz.github.io/CV/")[CV]),
      ("地址", [E514, School of Computer Science, Wuhan University]),
    ))),
  ),
)

#ui.masthead(
  "易守拙 - Shouzhuo Yi",
  [Undergraduate student at *Hongyi Honor College*, School of Computer Science, *Wuhan University* .],
)

#ui.section("Education")[
  #ui.entry(
    "武汉大学",
    date: "2024 - 2028",
    logo: image("./imgs/whu.png", alt: "武汉大学"),
  )[计算机科学与技术 (计算机弘毅班)]
]

#ui.section("Experience")[
  #ui.entry(
    "SIGMA lab,WHU",
    date: "2025.1 - 2025.7",
    logo: image("./imgs/whu.png", alt: "武汉大学"),
  )[Research Assistant]
  #ui.entry(
    "LAMP,UCAS",
    date: "2026.9 - ",
    logo: image("./imgs/whu.png", alt: "武汉大学"),
  )[Intern]
]

#ui.section("Research Interests")[
  #ui.interests((
    "Source-Free Domain Adaptation",
    "Neural Cellular Automata",
    "World Model",
  ))
]

#ui.section("Projects")[
  #ui.project(
    "故事成片 Story-to-video",
    index: "01",
    date: "2025.11 - 2025.12",
    stack: "Kotlin, Python",
    role: [_Teamwork. I've implemented the local LLM integration and optimized inter-service communication._],
    outlinks: (
      ("View Project", "https://github.com/menglongyan49-jpg/ai-story-video/tree/main"),
    ),
  )[
    实现了“自然文本输入到视频产出”的全链路自动化,实现可视化分镜管理、单镜头编辑,并整合了图像生成、动态视频渲染及 AI 配音技术.

    Achieved full-link automation from text-to-video production, incorporating visual storyboard management and per-shot editing capabilities. It seamlessly orchestrates image generation, dynamic video rendering, and AI-powered narration into a unified workflow.
  ]

  #ui.project(
    "Rust-Minimeter",
    index: "02",
    date: "2026.1",
    stack: "Rust",
    role: [_Work all by myself._],
    outlinks: (
      ("View Project", "https://whoiskiwiizzz.github.io/Projects/01-minimeter/"),
    ),
  )[
    一个基于 *egui* 和 *cpal* 开发的高性能实时音频可视化工具,实时查看声场、波形、频谱、LUFS/响度,用于拟合 MiniMeter的功能.

    A high-performance, real-time audio visualization tool built with *egui* and *cpal*. It provides live monitoring of sound fields, waveforms, spectrums, and LUFS/loudness, designed to match the functionality of MiniMeter.
  ]

  #ui.project(
    "RISCV-PIPELINE-CPU",
    index: "03",
    date: "2026.5 - 2026.8",
    stack: "Verilog, C",
    role: [_Teamwork._],
    outlinks: (
      ("View Project", "https://whoiskiwiizzz.github.io/Projects/02-SCPU/"),
      ("View Code", "https://github.com/whoisKIWIIZZZ/SCPU-RISCV"),
    ),
  )[
    本项目系武汉大学计算机学院“计算机系统综合设计A”课程设计作业,实现了五级流水线CPU并实现了MIDI键盘功能.
  ]

  #ui.project(
    "OSOSOS",
    index: "04",
    date: "2026.5 - 2026.8",
    stack: "Rust",
    role: [_Teamwork._],
    outlinks: (("View Code", "https://gitlab.eduxiji.net/T2026104869910278/oskernel2026-ososos"),),
  )[
    支持RISC-V和LoongArch双架构的单核宏内核操作系统设计,为2026全国大学生系统能力大赛操作系统内核赛作品.获得国家二等奖.
  ]
]

// 有论文后把下面整段取消注释，并按 ui.paper 的参数逐条填写。
// #ui.section("Publication"){
//   #ui.paper(
//     "Paper Title",
//     [Shouzhuo Yi, Coauthor One, Coauthor Two],
//     venue: "Conference Name",
//     year: "2026",
//     note: [Oral],
//     outlinks: (("Paper", "https://..."), ("Code", "https://...")),
//   )
// }

#ui.section("Music I've made")[
  #ui.release(
    (
      (
        title: [*BACK 2 U* _VIP,SINGLE_],
        album: [Macrame Music & 未界名],
        date: "2022.9.21",
      ),
      (
        title: [*虹* _ VOL\.2 EP_],
        artists: [Artists: kiwiizzz,NeonNeko,北洄,DJ Zeng, $quad quad quad$L?NX,L350iR,L1ghtF4ll,crash909☆],
        album: [Macrame Music & 未界名],
        date: "2023.3.15",
      ),
      (
        title: [*栩栩 Lifelike* _kiwiizzz remix_],
        artists: [Artists: kiwiizzz,BYDGALAXY],
        album: [SELF RELEASE],
        date: "2024.1.1",
      ),
      (
        title: [*溯江寻兰赋* _in_ *Words Des Flowers* _LP_],
        artists: [Artists: kiwiizzz,北洄],
        album: [Glimmer Music],
        date: "2024.2.4",
      ),
    ),
    (
      (path: image("./imgs/album1.jpg", alt: "BACK 2 U"),),
      (path: image("./imgs/album2.jpg", alt: "虹"),),
      (path: image("./imgs/album3.jpg", alt: "栩栩 Lifelike"),),
      (path: image("./imgs/album4.jpg", alt: "溯江寻兰赋"),),
    ),
  )
]
