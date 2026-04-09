#!/usr/bin/env python3
"""
build_all.py

总调度脚本，按顺序执行：
  1. python ./typst/build.py build
  2. 并行执行：python heatmap.py  +  python build_knowledge.py
     heatmap.py 内部完成：生成 heatmap.html + 注入两个 iframe 到主 HTML
  3. python ./typst/build.py preview

用法:
    python build_all.py
    python build_all.py --no-fetch          # heatmap 跳过网络
    python build_all.py --skip-build        # 跳过第 1 步（调试用）
    python build_all.py --skip-preview      # 跳过第 3 步
    python build_all.py --file index.html --heatmap heatmap.html
"""

import argparse
import subprocess
import sys
import threading

DEFAULT_HTML_FILE = "index.html"
DEFAULT_HEATMAP_FILE = "heatmap.html"
DEFAULT_KG_FILE = "knowledge_graph.html"


def run(cmd: list[str], step: str) -> None:
    """运行子进程，失败则退出整个脚本。"""
    print(f"\n{'=' * 60}")
    print(f"[STEP] {step}")
    print(f"[CMD]  {' '.join(cmd)}")
    print("=" * 60)
    result = subprocess.run(cmd, text=True)
    if result.returncode != 0:
        print(f"\n[✗] 步骤失败（exit {result.returncode}）: {step}")
        sys.exit(result.returncode)
    print(f"[✓] 完成: {step}")


def run_parallel(tasks: list[tuple[list[str], str]]) -> None:
    """并行运行多个子进程，任意一个失败则退出。"""
    print(f"\n{'=' * 60}")
    print(f"[STEP] 并行执行 {len(tasks)} 个任务")
    for _, label in tasks:
        print(f"       · {label}")
    print("=" * 60)

    errors: list[str] = []
    lock = threading.Lock()

    def worker(cmd: list[str], label: str) -> None:
        result = subprocess.run(cmd, text=True)
        if result.returncode != 0:
            with lock:
                errors.append(f"{label} (exit {result.returncode})")

    threads = [
        threading.Thread(target=worker, args=(cmd, label)) for cmd, label in tasks
    ]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    if errors:
        for e in errors:
            print(f"[✗] 失败: {e}")
        sys.exit(1)
    print("[✓] 并行任务全部完成")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="一键构建：typst build → heatmap/kg → preview"
    )
    parser.add_argument("--file", default=DEFAULT_HTML_FILE, help="主 HTML 路径")
    parser.add_argument(
        "--heatmap", default=DEFAULT_HEATMAP_FILE, help="热力图 HTML 路径"
    )
    parser.add_argument("--kg", default=DEFAULT_KG_FILE, help="知识图谱 HTML 路径")
    parser.add_argument("--no-fetch", action="store_true", help="heatmap 跳过网络请求")
    parser.add_argument("--skip-build", action="store_true", help="跳过 typst build")
    parser.add_argument(
        "--skip-preview", action="store_true", help="跳过 typst preview"
    )
    args = parser.parse_args()

    py = sys.executable

    # ── Step 1: typst build ───────────────────────────────────────────────────
    if not args.skip_build:
        run([py, "./typst/build.py", "build"], "typst build")
    else:
        print("[·] 跳过 typst build")

    # ── Step 2: 并行生成资源 + 注入 iframe ───────────────────────────────────
    heatmap_cmd = [
        py,
        "heatmap.py",
        "--file",
        args.file,
        "--heatmap",
        args.heatmap,
        "--kg",
        args.kg,
    ]
    if args.no_fetch:
        heatmap_cmd.append("--no-fetch")

    run_parallel(
        [
            (heatmap_cmd, "heatmap.py"),
            ([py, "build_knowledge.py"], "build_knowledge.py"),
        ]
    )

    # ── Step 3: typst preview ─────────────────────────────────────────────────
    if not args.skip_preview:
        run([py, "./typst/build.py", "preview"], "typst preview")
    else:
        print("[·] 跳过 typst preview")

    print(f"\n{'=' * 60}")
    print("[✓] 全部完成！")
    print("=" * 60)


if __name__ == "__main__":
    main()
