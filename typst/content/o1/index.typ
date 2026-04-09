#import "../../config.typ": template, tufted
#show: template

// 侧边栏：放置头像和一句话简介



= kiwiizzz
_青いバラノイア 向かい合うだけだ_
- Typst & Rust
- Music & Art
- Photography

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
  image("../imgs/album4.jpg", width: 100%), image("../imgs/album1.jpg", width: 100%),
  image("../imgs/album2.jpg", width: 100%), image("../imgs/album3.jpg", width: 100%),
)

== 网站维护历史
- 2025.9.14 建立个人主页的雏形,仅使用html构建
- 2025.11.23 使用Tufted Typst模版重构
- 2026.2.14 把服务器搬到个人服务器上,使用了yisz.top这个域名
- 2026.2.17 添加了GitHub风格的贡献图谱

== 📬 Contact

- *NetEase Music* kiwiizzz
- *Bilibili:* #link("https://space.bilibili.com/454587686")[kiwiizzz]
