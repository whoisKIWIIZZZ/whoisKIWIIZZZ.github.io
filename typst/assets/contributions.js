(async function () {
  try {
    const response = await fetch("/all-commits.json");
    const data = await response.json();
    const commitMap = {};
    data.forEach((item) => {
      commitMap[item.date] = item.count;
    });

    const heatmap = document.getElementById("heatmap");
    if (!heatmap) return; // 如果页面没有 heatmap 元素就跳过

    const today = new Date();
    const oneYearAgo = new Date(today);
    oneYearAgo.setDate(today.getDate() - 365);

    for (let d = new Date(oneYearAgo); d <= today; d.setDate(d.getDate() + 1)) {
      const dateStr = d.toISOString().split("T")[0];
      const count = commitMap[dateStr] || 0;
      let level = 0;
      if (count > 0) level = 1;
      if (count > 3) level = 2;
      if (count > 6) level = 3;
      if (count > 10) level = 4;

      const day = document.createElement("div");
      day.className = "heatmap-day";
      day.setAttribute("data-level", level);
      day.setAttribute("data-date", dateStr);
      day.setAttribute("data-count", count);
      heatmap.appendChild(day);
    }
  } catch (e) {
    console.error("Failed to load contributions:", e);
  }
})();
