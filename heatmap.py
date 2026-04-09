#!/usr/bin/env python3
"""
heatmap.py

用法:
    python heatmap.py                        # 使用默认配置
    python heatmap.py --user xxx --file index.html
    python heatmap.py --manual data.json     # 额外叠加手动数据
    python heatmap.py --no-fetch             # 跳过网络，只用手动数据

效果:
    1. 生成 heatmap.html（独立热力图页面，通过 postMessage 响应主题切换）
    2. 在主 HTML 里，结构如下时：

         <h3>Commit</h3>
         <hr />
         ...文字内容...
         [← 在这里插入 heatmap iframe]
         <h3>Knowledge Graph</h3>    ← 下一个 <h3> 即为边界
         <hr />
         ...文字内容...
         [← 在这里插入 kg iframe]
         <h3>下一节</h3>             ← 或文件末尾

       重复运行时，识别注释标记自动更新，不会重复插入。
"""

import argparse
import json
import re
from datetime import date, timedelta
from pathlib import Path
from urllib import error, request

# ─── 配置 ─────────────────────────────────────────────────────────────────────
DEFAULT_GITHUB_USER = "shouzhuoyi"
DEFAULT_HTML_FILE = "index.html"
DEFAULT_HEATMAP_FILE = "heatmap.html"
API_URL = "https://github-contributions-api.jogruber.de/v4/{user}"

INLINE_MANUAL_DATA = [
    # {"date": "2026-02-14", "count": 3},
]

HEATMAP_START = "<!-- HEATMAP_IFRAME_START (auto-generated, do not edit manually) -->"
HEATMAP_END = "<!-- HEATMAP_IFRAME_END -->"
KG_START = "<!-- KG_IFRAME_START (auto-generated, do not edit manually) -->"
KG_END = "<!-- KG_IFRAME_END -->"
# ──────────────────────────────────────────────────────────────────────────────


# ═══════════════════════════════════════════════════════════════════════════════
#  数据获取与合并
# ═══════════════════════════════════════════════════════════════════════════════


def fetch_github_data(username: str) -> list[dict]:
    url = API_URL.format(user=username)
    print(f"[*] 获取 GitHub 数据: {url}")
    try:
        with request.urlopen(url, timeout=15) as resp:
            raw = json.loads(resp.read().decode())
        data = [
            {"date": d["date"], "count": d["count"]}
            for d in raw.get("contributions", [])
        ]
        print(f"[✓] 成功，共 {len(data)} 条")
        return data
    except error.URLError as e:
        print(f"[!] 网络失败: {e}，仅使用手动数据")
        return []


def load_manual_data(path: str | None) -> list[dict]:
    if path:
        p = Path(path)
        if not p.exists():
            print(f"[!] 文件不存在: {path}")
            return []
        with open(p, encoding="utf-8") as f:
            data = json.load(f)
        print(f"[✓] 手动数据 {len(data)} 条")
        return data
    return INLINE_MANUAL_DATA


def merge_data(github: list[dict], manual: list[dict]) -> dict[str, int]:
    merged: dict[str, int] = {}
    for item in github + manual:
        d, c = item["date"], item["count"]
        merged[d] = merged.get(d, 0) + c
    return merged


# ═══════════════════════════════════════════════════════════════════════════════
#  生成独立的 heatmap.html
# ═══════════════════════════════════════════════════════════════════════════════


def build_heatmap_page(merged: dict[str, int]) -> str:
    years = sorted({int(d[:4]) for d in merged}) or [date.today().year]
    data_json = json.dumps(merged, ensure_ascii=False)
    years_json = json.dumps(years)
    today_str = date.today().isoformat()
    since_str = (date.today() - timedelta(days=364)).isoformat()

    return f"""<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Heatmap</title>
<style>
:root,
html[data-theme="light"] {{
    --hm-subtext:    #57606a;
    --hm-btn-bg:     rgba(0,0,0,0.06);
    --hm-btn-hover:  rgba(0,0,0,0.10);
    --hm-active-bg:  #0969da;
    --hm-active-fg:  #ffffff;
    --hm-cell-empty: #ebedf0;
    --hm-tip-bg:     #ffffff;
    --hm-tip-border: #d0d7de;
    --hm-tip-fg:     #24292f;
    --hm-l1: #9be9a8; --hm-l2: #40c463;
    --hm-l3: #30a14e; --hm-l4: #216e39;
}}
html[data-theme="dark"] {{
    --hm-subtext:    #7d8590;
    --hm-btn-bg:     rgba(255,255,255,0.08);
    --hm-btn-hover:  rgba(255,255,255,0.14);
    --hm-active-bg:  #1f6feb;
    --hm-active-fg:  #ffffff;
    --hm-cell-empty: #21262d;
    --hm-tip-bg:     #1c2128;
    --hm-tip-border: #30363d;
    --hm-tip-fg:     #c9d1d9;
    --hm-l1: #0e4429; --hm-l2: #006d32;
    --hm-l3: #26a641; --hm-l4: #39d353;
}}
* {{ box-sizing: border-box; margin: 0; padding: 0; }}
body {{
    background: transparent;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    padding: 8px 0;
}}
#hm-wrap {{ display: inline-block; min-width: 100%; }}
.hm-year-sel {{
    display: flex; gap: 4px; padding: 4px;
    border-radius: 6px; background: var(--hm-btn-bg);
    margin-bottom: 14px; width: fit-content;
}}
.hm-ybtn {{
    background: transparent; border: none; color: var(--hm-subtext);
    padding: 4px 12px; border-radius: 4px;
    cursor: pointer; font-size: 12px; font-weight: 500;
    transition: all 0.15s;
}}
.hm-ybtn:hover  {{ background: var(--hm-btn-hover); color: inherit; }}
.hm-ybtn.active {{ background: var(--hm-active-bg); color: var(--hm-active-fg); }}
.hm-months {{ position: relative; height: 16px; margin-bottom: 4px; margin-left: 28px; }}
.hm-mlbl   {{ position: absolute; font-size: 11px; color: var(--hm-subtext); }}
.hm-grid  {{ display: flex; gap: 4px; }}
.hm-wdays {{ display: flex; flex-direction: column; gap: 3px; flex-shrink: 0; }}
.hm-wday  {{
    font-size: 10px; color: var(--hm-subtext);
    height: 12px; line-height: 12px;
    width: 24px; text-align: right; padding-right: 4px;
}}
.hm-weeks {{ display: flex; gap: 3px; }}
.hm-week  {{ display: flex; flex-direction: column; gap: 3px; }}
.hm-day {{
    width: 12px; height: 12px; border-radius: 2px;
    cursor: pointer; flex-shrink: 0; transition: transform 0.1s;
}}
.hm-day:hover {{ transform: scale(1.3); outline: 1px solid var(--hm-subtext); }}
.hm-day[data-l="0"] {{ background: var(--hm-cell-empty); }}
.hm-day[data-l="1"] {{ background: var(--hm-l1); }}
.hm-day[data-l="2"] {{ background: var(--hm-l2); }}
.hm-day[data-l="3"] {{ background: var(--hm-l3); }}
.hm-day[data-l="4"] {{ background: var(--hm-l4); }}
#hm-tip {{
    position: fixed;
    background: var(--hm-tip-bg); border: 1px solid var(--hm-tip-border);
    color: var(--hm-tip-fg); border-radius: 6px; padding: 6px 10px;
    font-size: 12px; pointer-events: none; z-index: 9999; display: none;
    box-shadow: 0 4px 16px rgba(0,0,0,.15); white-space: nowrap;
}}
#hm-tip.show {{ display: block; }}
</style>
</head>
<body>
<div id="hm-wrap">
    <div class="hm-year-sel" id="hm-ybtnbox"></div>
    <div style="overflow-x:auto"><div id="hm-root"></div></div>
</div>
<div id="hm-tip"></div>
<script>
// ── 主题同步 ──────────────────────────────────────────────────────────────────
window.addEventListener("message", (e) => {{
    if (e.data?.type === "set-theme")
        document.documentElement.setAttribute("data-theme", e.data.theme);
}});
window.addEventListener("load", () => {{
    window.parent.postMessage({{ type: "request-theme" }}, "*");
}});
setTimeout(() => {{
    window.parent.postMessage({{ type: "request-theme" }}, "*");
}}, 100);

// ── 热力图逻辑 ────────────────────────────────────────────────────────────────
(function () {{
    const DATA  = {data_json};
    const YEARS = {years_json};
    const TODAY = "{today_str}";
    const SINCE = "{since_str}";
    const MN    = ["Jan","Feb","Mar","Apr","May","Jun",
                   "Jul","Aug","Sep","Oct","Nov","Dec"];
    let mode = "recent";

    const pad = n => String(n).padStart(2, "0");
    const fmt = d => `${{d.getFullYear()}}-${{pad(d.getMonth()+1)}}-${{pad(d.getDate())}}`;

    function getRange(m) {{
        if (m === "recent") {{
            const s = new Date(SINCE);
            while (s.getDay() !== 0) s.setDate(s.getDate() - 1);
            const e = new Date(TODAY);
            while (e.getDay() !== 6) e.setDate(e.getDate() + 1);
            return [s, e];
        }}
        const yr = parseInt(m);
        const s = new Date(yr, 0, 1); while (s.getDay() !== 0) s.setDate(s.getDate()-1);
        const e = new Date(yr,11,31); while (e.getDay() !== 6) e.setDate(e.getDate()+1);
        return [s, e];
    }}

    function lvl(c, mx) {{
        if (!c) return 0;
        const r = c / mx;
        return r <= .25 ? 1 : r <= .5 ? 2 : r <= .75 ? 3 : 4;
    }}

    function buildButtons() {{
        const box = document.getElementById("hm-ybtnbox");
        box.innerHTML = "";
        [["最近一年","recent"], ...YEARS.map(y => [String(y), String(y)])].forEach(([label, m]) => {{
            const btn = document.createElement("button");
            btn.className = "hm-ybtn" + (mode === m ? " active" : "");
            btn.textContent = label;
            btn.onclick = () => {{ mode = m; buildButtons(); render(); }};
            box.appendChild(btn);
        }});
    }}

    function render() {{
        const [start, end] = getRange(mode);
        const weeks = [];
        const cur = new Date(start);
        while (cur <= end) {{
            const w = [];
            for (let i = 0; i < 7; i++) {{ w.push(new Date(cur)); cur.setDate(cur.getDate()+1); }}
            weeks.push(w);
        }}
        const s = fmt(start), e = fmt(end), map = {{}};
        for (const [d, c] of Object.entries(DATA)) if (d >= s && d <= e) map[d] = c;
        const mx = Math.max(...Object.values(map), 1);

        const root = document.getElementById("hm-root");
        root.innerHTML = "";

        const CELL = 15;
        const mRow = document.createElement("div"); mRow.className = "hm-months";
        let lastM = -1;
        weeks.forEach((w, wi) => {{
            const m = w[0].getMonth();
            if (m !== lastM) {{
                lastM = m;
                const lbl = document.createElement("div");
                lbl.className = "hm-mlbl";
                lbl.textContent = MN[m];
                lbl.style.left = (wi * CELL) + "px";
                mRow.appendChild(lbl);
            }}
        }});
        root.appendChild(mRow);

        const grid = document.createElement("div"); grid.className = "hm-grid";
        const wd = document.createElement("div"); wd.className = "hm-wdays";
        ["日","一","二","三","四","五","六"].forEach(t => {{
            const el = document.createElement("div"); el.className = "hm-wday"; el.textContent = t; wd.appendChild(el);
        }});
        grid.appendChild(wd);

        const ws = document.createElement("div"); ws.className = "hm-weeks";
        weeks.forEach(week => {{
            const col = document.createElement("div"); col.className = "hm-week";
            week.forEach(dt => {{
                const ds = fmt(dt), cnt = map[ds] || 0;
                const cell = document.createElement("div");
                cell.className = "hm-day";
                cell.dataset.l = lvl(cnt, mx);
                cell.dataset.date = ds;
                cell.dataset.count = cnt;
                cell.addEventListener("mouseenter", onEnter);
                cell.addEventListener("mouseleave", onLeave);
                col.appendChild(cell);
            }});
            ws.appendChild(col);
        }});
        grid.appendChild(ws);
        root.appendChild(grid);
    }}

    const tip = document.getElementById("hm-tip");
    function onEnter(e) {{
        tip.textContent = `${{e.target.dataset.date}}：${{e.target.dataset.count}} 次贡献`;
        tip.classList.add("show");
    }}
    function onLeave() {{ tip.classList.remove("show"); }}
    document.addEventListener("mousemove", e => {{
        if (tip.classList.contains("show")) {{
            tip.style.left = (e.clientX + 12) + "px";
            tip.style.top  = (e.clientY - 34) + "px";
        }}
    }});

    buildButtons();
    render();
}})();
</script>
</body>
</html>
"""


# ═══════════════════════════════════════════════════════════════════════════════
#  iframe 片段构造
# ═══════════════════════════════════════════════════════════════════════════════


def make_iframe_snippet(src: str, marker_start: str, marker_end: str) -> str:
    return (
        f"{marker_start}\n"
        f'<iframe src="{src}"'
        f' style="width:55%;border:none;overflow:hidden;"'
        f' scrolling="yes"'
        f" onload=\"this.style.height=this.contentDocument.body.scrollHeight+40+'px'\">"
        f"</iframe>\n"
        f"{marker_end}"
    )


def make_iframe_snippet_large(src: str, marker_start: str, marker_end: str) -> str:
    return (
        f"{marker_start}\n"
        f'<iframe src="{src}"'
        f' style="width:55%;border:none;overflow:hidden;"'
        f' scrolling="yes"'
        f" onload=\"this.style.height=this.contentDocument.body.scrollHeight+500+'px'\">"
        f"</iframe>\n"
        f"{marker_end}"
    )


# ═══════════════════════════════════════════════════════════════════════════════
#  注入逻辑
#
#  目标结构：
#    <h3>Commit</h3>
#    <hr />
#    ...任意内容...
#    [← 插这里，紧接在下一个 <h3> 之前]
#    <h3>Knowledge Graph</h3>
#    <hr />
#    ...任意内容...
#    [← 插这里，紧接在下一个 <h3>（或文件末尾）之前]
# ═══════════════════════════════════════════════════════════════════════════════


def inject_iframe(
    content: str,
    h3_title: str,
    snippet: str,
    marker_start: str,
    marker_end: str,
) -> tuple[str, bool]:
    """
    已有标记 → 原地替换。
    没有标记 → 在 <h3>{h3_title}</h3> 所在块的末尾插入，
               块的末尾定义为：下一个 <h3 标签出现之前（或字符串结尾）。
    """

    # ── 情况 A：已有标记，直接替换 ───────────────────────────────────────────
    if marker_start in content:
        new_content = re.sub(
            re.escape(marker_start) + r".*?" + re.escape(marker_end),
            snippet,
            content,
            flags=re.DOTALL,
        )
        print(f"[✓] 更新 '{h3_title}' iframe 块")
        return new_content, True

    # ── 情况 B：首次插入 ──────────────────────────────────────────────────────
    # 匹配从 <h3>Title</h3> 开始，到下一个 <h3（不含）或字符串末尾之间的全部内容
    pattern = re.compile(
        r"(<h3[^>]*>\s*" + re.escape(h3_title) + r"\s*</h3>"  # 标题本身
        r".*?)"  # 块内所有内容（非贪婪）
        r"(?=<h3|\Z)",  # 前瞻：下一个 <h3 或末尾
        re.DOTALL | re.IGNORECASE,
    )
    m = pattern.search(content)
    if m:
        # 把 snippet 插在这段内容的末尾
        insert_pos = m.end(1)
        new_content = content[:insert_pos] + "\n" + snippet + content[insert_pos:]
        print(f"[✓] 插入 '{h3_title}' iframe（位于下一个 <h3> 之前）")
        return new_content, True
    else:
        print(f"[!] 未找到 <h3>{h3_title}</h3> 块，跳过")
        return content, False


def inject_into_html(html_path: str, heatmap_src: str, kg_src: str) -> None:
    p = Path(html_path)
    if not p.exists():
        print(f"[✗] 找不到 HTML 文件: {html_path}")
        return

    content = p.read_text(encoding="utf-8")
    changed = False

    heatmap_snippet = make_iframe_snippet(heatmap_src, HEATMAP_START, HEATMAP_END)
    kg_snippet = make_iframe_snippet_large(kg_src, KG_START, KG_END)

    content, c = inject_iframe(
        content, "Commit", heatmap_snippet, HEATMAP_START, HEATMAP_END
    )
    changed = changed or c
    content, c = inject_iframe(content, "Knowledge Graph", kg_snippet, KG_START, KG_END)
    changed = changed or c

    if changed:
        p.write_text(content, encoding="utf-8")
        print(f"[✓] 写入: {html_path}")
    else:
        print(f"[·] 无变化，跳过写入")


# ═══════════════════════════════════════════════════════════════════════════════
#  主入口
# ═══════════════════════════════════════════════════════════════════════════════


def main():
    parser = argparse.ArgumentParser(description="生成热力图并注入主 HTML")
    parser.add_argument("--user", default=DEFAULT_GITHUB_USER, help="GitHub 用户名")
    parser.add_argument("--file", default=DEFAULT_HTML_FILE, help="主 HTML 文件路径")
    parser.add_argument(
        "--heatmap", default=DEFAULT_HEATMAP_FILE, help="输出的热力图 HTML 路径"
    )
    parser.add_argument(
        "--kg",
        default="knowledge_graph.html",
        help="知识图谱 HTML 路径（仅用于 iframe src）",
    )
    parser.add_argument("--manual", default=None, help="手动数据 JSON 文件路径")
    parser.add_argument("--no-fetch", action="store_true", help="跳过 GitHub 网络请求")
    args = parser.parse_args()

    # 1. 拉取并合并数据
    github_data = [] if args.no_fetch else fetch_github_data(args.user)
    manual_data = load_manual_data(args.manual)
    merged = merge_data(github_data, manual_data)
    print(f"[*] 合并后 {len(merged)} 天有数据")

    # 2. 写出独立的 heatmap.html
    Path(args.heatmap).write_text(build_heatmap_page(merged), encoding="utf-8")
    print(f"[✓] 热力图页面写入: {args.heatmap}")

    # 3. 注入两个 iframe 到主 HTML
    inject_into_html(args.file, args.heatmap, args.kg)

    print("[✓] 完成！")


if __name__ == "__main__":
    main()
