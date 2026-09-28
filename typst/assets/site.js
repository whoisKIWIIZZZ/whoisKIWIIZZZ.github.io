/*******************************************************************************
站点脚本

三件事：
  1. 深浅色切换，记住用户选择
  2. greedy-nav：宽度不够时把放不下的导航项收进右侧下拉
  3. 侧栏的「More Info & Contact」按钮与列表切换
*******************************************************************************/

(function () {
  "use strict";

  // ── 深浅色 ───────────────────────────────────────────────────────────────

  var THEME_KEY = "theme-preference";
  var root = document.documentElement;
  var button = null;

  var MOON = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12.3 4.9c.4-.2.1-.9-.4-.8-3.9.7-6.7 4.2-6.7 8.3 0 4.7 3.8 8.5 8.5 8.5 2 0 3.9-.7 5.3-1.9.4-.3.1-.9-.3-.9-1.2 0-2.6-.5-3.5-1.6a4.3 4.3 0 0 1-1.1-4.3c0-1.7.8-3.2 2.1-4.2.4-.3.4-.7.1-1.1-1.4-1.1-3-1.5-4-1z"/></svg>';
  var SUN = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 17a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-13a1 1 0 0 1 1 1v1a1 1 0 1 1-2 0V5a1 1 0 0 1 1-1zm0 15a1 1 0 0 1 1 1v1a1 1 0 1 1-2 0v-1a1 1 0 0 1 1-1zM4 11h1a1 1 0 1 1 0 2H4a1 1 0 1 1 0-2zm15 0h1a1 1 0 1 1 0 2h-1a1 1 0 1 1 0-2zM6.3 6.3a1 1 0 0 1 1.4 0l.7.7A1 1 0 0 1 7 8.4l-.7-.7a1 1 0 0 1 0-1.4zm9.3 9.3a1 1 0 0 1 1.4 0l.7.7a1 1 0 0 1-1.4 1.4l-.7-.7a1 1 0 0 1 0-1.4zm2.4-9.3a1 1 0 0 1 0 1.4l-.7.7A1 1 0 1 1 16 7l.7-.7a1 1 0 0 1 1.3 0zM7 16a1 1 0 0 1 0 1.4l-.7.7a1 1 0 0 1-1.4-1.4l.7-.7A1 1 0 0 1 7 16z"/></svg>';

  function stored() {
    try {
      return localStorage.getItem(THEME_KEY);
    } catch (e) {
      return null;
    }
  }

  function current() {
    var saved = stored();
    if (saved === "light" || saved === "dark") return saved;
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function apply(theme) {
    root.setAttribute("data-theme", theme);
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) meta.setAttribute("content", theme === "dark" ? "#171a1d" : "#ffffff");
    if (button) button.innerHTML = theme === "dark" ? SUN : MOON;
  }

  function initTheme() {
    // 按钮做成导航里的普通一项，外观与其它导航项一致。
    // 必须包在 li 里：visible-links 是 display:table，裸 button 会排歪。
    var host = document.querySelector(".greedy-nav .visible-links");
    if (!host) return;

    var item = document.createElement("li");
    item.className = "masthead__menu-item theme-toggle-item";
    button = document.createElement("button");
    button.className = "theme-toggle";
    button.type = "button";
    button.setAttribute("aria-label", "切换深浅色");
    button.addEventListener("click", function () {
      var next = current() === "dark" ? "light" : "dark";
      try {
        localStorage.setItem(THEME_KEY, next);
      } catch (e) {
        /* 无痕模式下忽略 */
      }
      apply(next);
    });
    item.appendChild(button);
    host.appendChild(item);
    apply(current());

    window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", function (e) {
      if (!stored()) apply(e.matches ? "dark" : "light");
    });
  }

  // ── greedy-nav ──────────────────────────────────────────────────────────

  function initNav() {
    var nav = document.getElementById("site-nav");
    if (!nav) return;

    var toggle = nav.querySelector("button");
    var visible = nav.querySelector(".visible-links");
    var hidden = nav.querySelector(".hidden-links");
    if (!toggle || !visible || !hidden) return;

    var here = location.pathname.replace(/index\.html$/, "");
    nav.querySelectorAll("a").forEach(function (a) {
      if (a.getAttribute("href") === here) a.setAttribute("aria-current", "page");
    });

    var pushed = [];

    function layout() {
      // 全部放回可见列表，重新量一次
      pushed.forEach(function (li) {
        visible.appendChild(li);
      });
      pushed = [];
      hidden.innerHTML = "";
      hidden.classList.remove("hidden");
      toggle.classList.remove("close");

      var items = Array.prototype.slice.call(visible.children);
      // 主题按钮不参与分配
      items = items.filter(function (li) {
        return !li.classList.contains("theme-toggle-item");
      });

      var gap = parseFloat(getComputedStyle(visible).columnGap) || 0;
      // 汉堡按钮是绝对定位在右侧的，预留它 + 主题按钮的宽度
      var reserve = 40 + (button ? button.offsetWidth + 32 : 0);
      var room = nav.clientWidth - reserve;

      var used = 0;
      var keep = [];
      var drop = [];

      items.forEach(function (li) {
        used += li.offsetWidth + gap;
        if (used <= room) {
          keep.push(li);
        } else {
          drop.push(li);
        }
      });

      // 一个都放不下就至少留一个
      if (keep.length === 0 && items.length) {
        keep.push(items[0]);
        drop = items.slice(1);
      }

      drop.forEach(function (li) {
        hidden.appendChild(li);
      });
      pushed = drop;

      toggle.style.display = drop.length > 0 ? "block" : "none";
      nav.classList.toggle("greedy-nav--short", drop.length > 0);
    }

    toggle.addEventListener("click", function () {
      var open = toggle.classList.contains("close");
      toggle.classList.toggle("close", !open);
      hidden.classList.toggle("hidden", open);
    });

    document.addEventListener("click", function (e) {
      if (!nav.contains(e.target)) {
        toggle.classList.remove("close");
        hidden.classList.add("hidden");
      }
    });

    layout();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(layout);
    window.addEventListener("resize", layout);
  }

  // ── 侧栏联系入口 ────────────────────────────────────────────────────────

  function initProfile() {
    // 参考站是点整个图标区展开列表的
    document.querySelectorAll(".author__urls-wrapper").forEach(function (wrap) {
      var sm = wrap.querySelector(".author__urls_sm");
      var toggle = wrap.querySelector(".author__urls-toggle");
      if (!sm && !toggle) return;

      function toggleOpen(e) {
        if (e.target.closest(".author__urls")) return;
        e.stopPropagation();
        wrap.classList.toggle("author__urls_wrapper-open");
      }

      if (sm) sm.addEventListener("click", toggleOpen);
      if (toggle) toggle.addEventListener("click", toggleOpen);
    });

    document.addEventListener("click", function () {
      document.querySelectorAll(".author__urls_wrapper-open").forEach(function (el) {
        el.classList.remove("author__urls_wrapper-open");
      });
    });
  }

  // ── 启动 ────────────────────────────────────────────────────────────────

  // 脚本在 head 里同步执行，此刻 body 还没建好：
  // 先把主题落到 <html> 上避免闪白，其余等 DOM 就绪。
  apply(current());

  function boot() {
    initTheme();
    initNav();
    initProfile();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
