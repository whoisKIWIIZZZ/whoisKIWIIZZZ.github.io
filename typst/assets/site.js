/*******************************************************************************
站点脚本

两件事：
  1. 深浅色切换，记住用户选择
  2. 顶栏导航：宽度不够时把放不下的项收进汉堡菜单里的下拉
*******************************************************************************/

(function () {
  "use strict";

  var THEME_KEY = "theme-preference";
  var root = document.documentElement;

  // ── 主题 ────────────────────────────────────────────────────────────────

  var MOON = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>';
  var SUN = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><circle cx="12" cy="12" r="4.2"/><path d="M12 2.6v2.2M12 19.2v2.2M2.6 12h2.2M19.2 12h2.2M5.3 5.3l1.6 1.6M17.1 17.1l1.6 1.6M18.7 5.3l-1.6 1.6M6.9 17.1l-1.6 1.6"/></svg>';

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
    if (meta) meta.setAttribute("content", theme === "dark" ? "#15130e" : "#f7f2e6");
    if (button) button.innerHTML = theme === "dark" ? SUN : MOON;
  }

  var button = null;

  function initTheme() {
    button = document.querySelector(".theme-toggle");
    if (!button) return;
    apply(current());

    button.addEventListener("click", function () {
      var next = current() === "dark" ? "light" : "dark";
      try {
        localStorage.setItem(THEME_KEY, next);
      } catch (e) {
        /* 无痕模式下忽略 */
      }
      apply(next);
    });

    window
      .matchMedia("(prefers-color-scheme: dark)")
      .addEventListener("change", function (e) {
        if (!stored()) apply(e.matches ? "dark" : "light");
      });
  }

  // ── 顶栏导航 ────────────────────────────────────────────────────────────

  function initNav() {
    var nav = document.getElementById("site-nav");
    if (!nav) return;

    var toggle = nav.querySelector(".nav-toggle");
    var visible = nav.querySelector(".visible-links");
    var hidden = nav.querySelector(".hidden-links");
    var actions = nav.querySelector(".nav-actions");
    if (!toggle || !visible || !hidden || !actions) return;

    // 当前页高亮
    var here = location.pathname.replace(/\/index\.html$/, "/");
    nav.querySelectorAll("a").forEach(function (a) {
      if (a.getAttribute("href") === here) a.setAttribute("aria-current", "page");
    });

    var overflowed = [];

    function layout() {
      // 全部放回可见列表，重新量一次
      overflowed.forEach(function (li) {
        visible.appendChild(li);
      });
      overflowed = [];
      hidden.innerHTML = "";
      hidden.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");

      var items = Array.prototype.slice.call(visible.children);
      var gap = parseFloat(getComputedStyle(visible).columnGap) || 0;
      // 右侧按钮区是固定占位，剩下的才是导航项能用的宽度
      var room = nav.clientWidth - actions.offsetWidth - 4;

      var used = 0;
      var keep = [];
      var push = [];

      items.forEach(function (li) {
        used += li.offsetWidth + gap;
        if (used <= room) {
          keep.push(li);
        } else {
          push.push(li);
        }
      });

      // 一个都放不下就至少留一个
      if (keep.length === 0 && items.length) {
        keep.push(items[0]);
        push = items.slice(1);
      }

      push.forEach(function (li) {
        hidden.appendChild(li);
      });
      overflowed = push;

      var needToggle = push.length > 0;
      toggle.style.display = needToggle ? "block" : "none";
      nav.classList.toggle("greedy-nav--short", needToggle);
    }

    toggle.addEventListener("click", function () {
      var open = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", open ? "false" : "true");
      hidden.classList.toggle("is-open", !open);
    });

    document.addEventListener("click", function (e) {
      if (!nav.contains(e.target)) {
        hidden.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });

    layout();
    if (document.fonts && document.fonts.ready) {
      document.fonts.ready.then(layout);
    }
    window.addEventListener("resize", layout);
  }

  // ── 启动 ────────────────────────────────────────────────────────────────

  // 脚本在 head 里同步执行，此刻 body 还没建好：
  // 先把主题落到 <html> 上避免闪白，按钮和导航等 DOM 就绪后再装。
  apply(current());

  function boot() {
    initTheme();
    initNav();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
