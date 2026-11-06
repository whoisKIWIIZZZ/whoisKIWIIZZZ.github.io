#import "../../config.typ": template, ui
#show: template.with(title: "Awards - Shouzhuo Yi")

#ui.title("Awards & Honors")

#ui.section("竞赛")[
  #ui.awards[
    #ui.award(
      "第十六届蓝桥杯省赛 C/C++ 大学 A 组 二等奖",
      issuer: "工业和信息化部人才交流中心",
      year: "2025",
    )
    #ui.award(
      "全国大学生数学竞赛 非数学类 A 组 二等奖",
      issuer: "中国数学会",
      year: "2026",
    )
    #ui.award(
      "第二届 CCF 算法能力大赛 二等奖",
      body: [入围决赛.],
      issuer: "中国计算机学会",
      year: "2026",
    )
     #ui.award(
      "中国高校计算机大赛-团体程序设计天梯赛 国家三等奖",
      issuer: "中国计算机学会",
      year: "2026",
    )
    #ui.award(
      "全国大学生计算机系统能力大赛-操作系统设计赛(全国)-OS内核实现赛道 全国二等奖",
      //“中国高校计算机大赛-团体程序设计天梯赛
      issuer: "全国高等学校计算机教育研究会",
      year: "2026",
    )
  ]
]

#ui.section("奖学金与荣誉")[
  #ui.awards[
    #ui.award("优秀学生", year: "2025,2026")
    #ui.award("丙等奖学金", year: "2025")
    #ui.award("乙等奖学金", year: "2025")
    #ui.award("雷军计算机本科生奖学金", year: "2026")
  ]
]

/*
加新条目只要复制一行 #ui.award(...)：

  #ui.award("名称")
  #ui.award("名称", year: "2026")
  #ui.award("名称", body: [补充说明.], year: "2026")
  #ui.award("名称", issuer: "颁发单位", year: "2026")
  #ui.award("名称", year: "2026", link: ("证书链接", "https://..."))
  #ui.award("名称", year: "2026", badge: [特等奖])

参数：名称、说明、颁发单位、年份、链接、标签.
后五个不写就不出对应的元素.

想换成时间线样式（左边时间、右边内容）就把 #ui.awards[...] 换成
#ui.timeline[ #ui.timeline-entry("2026", "标题", body: [说明.]) ].
*/
