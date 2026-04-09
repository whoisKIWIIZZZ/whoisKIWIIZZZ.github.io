#import "../../config.typ": html-grid, template, tufted
#show: template.with(title: "Project: Rust-Minimeter")

#let hr() = html.elem("hr")

// --- 侧边栏：放置项目标签与元数据 ---
#tufted.margin-note[
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Tech Stack:* Rust
  ] \
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Libraries:* egui, cpal, rustFFT
  ] \
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Version:* 1.0.0
  ] \
  #box(fill: silver.lighten(50%), inset: 5pt, radius: 3pt)[
    *Release:* 2026.1
  ]
]

= Rust-Minimeter
#hr()
This page is mainly written by gemini 3 flash.

*高性能实时音频分析与可视化工具*

这是一个基于 Rust 开发的专业音频监测工具，旨在提供极低延迟的视觉反馈。它能够实时捕捉系统音频，并提供从时域到频域的多维度分析。
#image("../imgs/rust-minimeter.png")
#line(length: 100%, stroke: 0.5pt + gray)

== 🔍 核心特性

- *实时频谱分析 (FFT)*：支持高分辨率频谱显示，采用 Hann 窗函数处理。结合平滑算法，精准捕捉从 $20$Hz 到 $20$kHz 的音频细节。
- *专业 LUFS 测量*：内置 ITU-R BS.1770 标准的 K-Weighting 滤波器，实时计算感知响度与峰值电平。
- *立体声相位 (Goniometer)*：提供向量示波器功能，可视化音频的空间分布和相位一致性。

== 💻 技术实现

=== 后端：音频原力
- *CPAL*: 跨平台音频捕捉，支持虚拟回环设备。
- *MPSC*: 零延迟、非阻塞的音频数据传递，确保 UI 线程与处理线程完美解耦。

=== 前端：极致响应
- *Egui*: 纯 Rust 编写的即时模式 GUI，极低 CPU 占用。
- *Custom Rendering*: 使用 `Painter` 逐像素定制波形和瀑布图，确保 $60+$ FPS 的流畅度。

== 🦀 核心逻辑演示
```rust
// K-Weighting 滤波器实现片段
fn process(&mut self, x: f32) -> f32 {
    let v = self.b0 * x + self.z1;
    self.z1 = self.b1 * x - self.a1 * v + self.z2;
    self.z2 = self.b2 * x - self.a2 * v;
    // ... 级联双二阶滤波 ...
    y
}
```
== 代码
#link("https://github.com/shouzhuoyi/rust-minimeter")[View Code →]

#link("https://www.bilibili.com/video/BV1g1zWB7E68/")[Demo Video →]
