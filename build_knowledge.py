#!/usr/bin/env python3
"""
知识图库生成器
用法: python build.py
会读取同目录的 graph.yaml，生成 knowledge-graph.html
"""

import json
import sys
from pathlib import Path

import yaml


def build():
    src = Path(__file__).parent / "graph.yaml"
    out = Path(__file__).parent / "knowledge_graph.html"

    if not src.exists():
        print(f"❌ 找不到 {src}")
        sys.exit(1)

    with open(src, encoding="utf-8") as f:
        data = yaml.safe_load(f)

    # 转成前端需要的格式
    graph = {
        "nodes": [
            {
                "id": n["id"],
                "group": n["group"],
                "size": n.get("size", 14),
                "desc": n.get("desc", ""),
            }
            for n in data["nodes"]
        ],
        "links": [
            {
                "source": l["source"],
                "target": l["target"],
                "strength": 2 if l.get("strong") else 1,
            }
            for l in data["links"]
        ],
    }

    color_map = {g["id"]: g["color"] for g in data["groups"]}
    group_name = {g["id"]: g["name"] for g in data["groups"]}
    legend_items = data["groups"]

    graph_json = json.dumps(graph, ensure_ascii=False)
    color_map_json = json.dumps(color_map, ensure_ascii=False)
    group_name_json = json.dumps(group_name, ensure_ascii=False)

    legend_html = "\n".join(
        f'<div class="legend-item">'
        f'<div class="legend-dot" style="background:{g["color"]}"></div>'
        f"{g['name']}</div>"
        for g in legend_items
    )

    html = f"""<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>知识图库</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/7.8.5/d3.min.js"></script>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=JetBrains+Mono:wght@300;400&display=swap');

  /* ── 主题变量：与父页面 html[data-theme] 完全对应 ── */
  :root,
  html[data-theme="light"] {{
    --kg-tip-bg:     #ffffff;
    --kg-tip-border: #d0d7de;
    --kg-tip-fg:     #24292f;
    --kg-subtext:    #57606a;
    --kg-glow-op:    0.15;
  }}
  html[data-theme="dark"] {{
    --kg-tip-bg:     #1c2128;
    --kg-tip-border: #30363d;
    --kg-tip-fg:     #c9d1d9;
    --kg-subtext:    #7d8590;
    --kg-glow-op:    0.4;
  }}

  * {{ margin: 0; padding: 0; box-sizing: border-box; }}

  html, body {{
    width: 100%; height: 100%;
    background: transparent;
    color: var(--kg-tip-fg);
    font-family: 'Noto Serif SC', serif;
    overflow: hidden;
  }}

  /* 图例（右上角悬浮） */
  #legend {{
    position: absolute; top: 12px; right: 16px;
    display: flex; gap: 12px; align-items: center;
    z-index: 10; pointer-events: none;
    background: var(--kg-tip-bg);
    border: 1px solid var(--kg-tip-border);
    border-radius: 8px;
    padding: 6px 12px;
    opacity: 0.92;
  }}

  .legend-item {{
    display: flex; align-items: center; gap: 5px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 10px; color: var(--kg-subtext);
  }}

  .legend-dot {{ width: 7px; height: 7px; border-radius: 50%; }}

  #graph-container {{ position: relative; width: 100%; height: 100%; }}
  svg {{ width: 100%; height: 100%; }}

  /* tooltip */
  #tooltip {{
    position: fixed;
    background: var(--kg-tip-bg);
    border: 1px solid var(--kg-tip-border);
    border-radius: 8px;
    padding: 12px 16px;
    pointer-events: none;
    opacity: 0;
    transition: opacity 0.2s;
    max-width: 220px;
    z-index: 100;
    box-shadow: 0 4px 24px rgba(0,0,0,0.12);
  }}

  #tooltip .tip-title {{ font-weight: 600; font-size: 14px; color: var(--kg-tip-fg); margin-bottom: 5px; }}
  #tooltip .tip-tag   {{ font-family: 'JetBrains Mono', monospace; font-size: 10px; padding: 2px 7px; border-radius: 3px; display: inline-block; margin-bottom: 7px; }}
  #tooltip .tip-desc  {{ font-size: 12px; color: var(--kg-subtext); line-height: 1.7; }}

  .hint {{
    position: absolute; bottom: 14px; left: 50%; transform: translateX(-50%);
    font-family: 'JetBrains Mono', monospace; font-size: 10px;
    color: var(--kg-subtext); letter-spacing: 0.08em;
    z-index: 10; pointer-events: none;
  }}
</style>
</head>
<body>

<div id="graph-container">
  <div id="legend">
    {legend_html}
  </div>
  <svg id="graph"></svg>
</div>

<div id="tooltip">
  <div class="tip-title"></div>
  <div class="tip-tag"></div>
  <div class="tip-desc"></div>
</div>

<script>
// 由 build.py 从 graph.yaml 自动生成，请勿手动修改此文件
const graphData  = {graph_json};
const colorMap   = {color_map_json};
const groupName  = {group_name_json};

const container = document.getElementById("graph-container");
const svg       = d3.select("#graph");
const tooltip   = document.getElementById("tooltip");
let width = container.clientWidth, height = container.clientHeight;

const g = svg.append("g");
svg.call(d3.zoom().scaleExtent([0.3, 3]).on("zoom", e => g.attr("transform", e.transform)));

// 辉光滤镜（暗色用，亮色下 opacity 较低自然淡化）
const defs = svg.append("defs");
const fil  = defs.append("filter").attr("id","glow");
fil.append("feGaussianBlur").attr("stdDeviation","3.5").attr("result","coloredBlur");
const fm = fil.append("feMerge");
fm.append("feMergeNode").attr("in","coloredBlur");
fm.append("feMergeNode").attr("in","SourceGraphic");

const isDark = () => window.matchMedia("(prefers-color-scheme: dark)").matches;

const simulation = d3.forceSimulation(graphData.nodes)
  .force("link", d3.forceLink(graphData.links).id(d=>d.id)
    .distance(d => d.strength===2 ? 140 : 95).strength(0.5))
  .force("charge", d3.forceManyBody().strength(-320))
  .force("center",  d3.forceCenter(width/2, height/2))
  .force("collision", d3.forceCollide().radius(d => d.size+20));

const link = g.append("g").selectAll("line")
  .data(graphData.links).enter().append("line")
  .attr("stroke", d => {{
    const s = graphData.nodes.find(n => n.id===(d.source.id||d.source));
    return (s ? colorMap[s.group] : "#888") + "55";
  }})
  .attr("stroke-width", d => d.strength===2 ? 2 : 1)
  .attr("stroke-dasharray", d => d.strength===2 ? "none" : "4,3");

const nodeGroup = g.append("g").selectAll("g")
  .data(graphData.nodes).enter().append("g")
  .call(d3.drag()
    .on("start",(e,d)=>{{ if(!e.active) simulation.alphaTarget(0.3).restart(); d.fx=d.x; d.fy=d.y; }})
    .on("drag", (e,d)=>{{ d.fx=e.x; d.fy=e.y; }})
    .on("end",  (e,d)=>{{ if(!e.active) simulation.alphaTarget(0); d.fx=null; d.fy=null; }})
  );

// 外光晕
nodeGroup.append("circle")
  .attr("r", d=>d.size+7).attr("fill","none")
  .attr("stroke", d=>colorMap[d.group]).attr("stroke-width",0.5)
  .attr("opacity",0.3).attr("filter","url(#glow)");

// 主圆
nodeGroup.append("circle")
  .attr("r", d=>d.size)
  .attr("fill", d=>colorMap[d.group]+"22")
  .attr("stroke", d=>colorMap[d.group])
  .attr("stroke-width", d=>d.group==="core"?2.5:1.5)
  .attr("filter","url(#glow)").style("cursor","pointer");

// 中心点
nodeGroup.append("circle")
  .attr("r", d=>d.size*0.22).attr("fill",d=>colorMap[d.group]).attr("opacity",0.9);

// 文字
nodeGroup.append("text")
  .attr("dy", d=>d.size+15).attr("text-anchor","middle")
  .attr("font-size", d=>d.group==="core"?13:d.size>14?11:10)
  .attr("font-family","'Noto Serif SC', serif")
  .attr("fill", d=>d.group==="core"?colorMap["core"]:"currentColor")
  .attr("opacity", d=>d.group==="core"?1:0.75)
  .attr("font-weight", d=>d.group==="core"?"700":"400")
  .attr("pointer-events","none").attr("user-select","none")
  .text(d=>d.id);

// 交互
nodeGroup
  .on("mouseover",(event,d) => {{
    const color = colorMap[d.group];
    tooltip.style.opacity = "1";
    tooltip.querySelector(".tip-title").textContent = d.id;
    tooltip.querySelector(".tip-tag").textContent   = groupName[d.group];
    tooltip.querySelector(".tip-tag").style.cssText = `background:${{color}}22;color:${{color}};border:1px solid ${{color}}66`;
    tooltip.querySelector(".tip-desc").textContent  = d.desc;
    const connected = new Set([d.id]);
    graphData.links.forEach(l => {{
      if(l.source.id===d.id) connected.add(l.target.id);
      if(l.target.id===d.id) connected.add(l.source.id);
    }});
    nodeGroup.selectAll("circle:nth-child(2)").attr("opacity",n=>connected.has(n.id)?1:0.12);
    link.attr("opacity",l=>l.source.id===d.id||l.target.id===d.id?1:0.06);
  }})
  .on("mousemove",event => {{
    tooltip.style.left=(event.clientX+16)+"px";
    tooltip.style.top =(event.clientY-10)+"px";
  }})
  .on("mouseout",() => {{
    tooltip.style.opacity="0";
    nodeGroup.selectAll("circle:nth-child(2)").attr("opacity",1);
    link.attr("opacity",1);
  }});

simulation.on("tick",() => {{
  link.attr("x1",d=>d.source.x).attr("y1",d=>d.source.y)
      .attr("x2",d=>d.target.x).attr("y2",d=>d.target.y);
  nodeGroup.attr("transform",d=>`translate(${{d.x}},${{d.y}})`);
}});

window.addEventListener("resize",() => {{
  width=container.clientWidth; height=container.clientHeight;
  simulation.force("center",d3.forceCenter(width/2,height/2)).restart();
}});

// ── 主题同步：接收父页面 postMessage，更新自身 data-theme ──
function applyTheme(theme) {{
  document.documentElement.setAttribute("data-theme", theme);
}}

window.addEventListener("message", e => {{
  if (e.data && e.data.type === "set-theme") {{
    applyTheme(e.data.theme);
  }}
}});

// 页面加载时主动向父页面请求一次当前主题
window.parent.postMessage({{ type: "request-theme" }}, "*");
</script>
</body>
</html>"""

    with open(out, "w", encoding="utf-8") as f:
        f.write(html)

    node_count = len(graph["nodes"])
    link_count = len(graph["links"])
    print(f"✅ 生成完成：{out}")
    print(f"   节点数：{node_count}  连线数：{link_count}")


if __name__ == "__main__":
    build()
