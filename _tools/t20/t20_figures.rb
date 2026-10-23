# Redrawn, animated versions of the four figures in Bloom et al., BMJ 2019;365:l2107.
# Values are the regional totals printed in the paper's figures.
# Stages: elements with class sN appear when the scroll step reaches data-stage N.

REGION_COLOURS = {
  "Africa" => "#6f8fd6", "Asia" => "#6cc08b", "Europe" => "#9a86d8",
  "Latin America" => "#e06b9a", "Northern America" => "#f0a35a", "Oceania" => "#4fc1c6"
}

def esc(s) = s.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")

# Spread label centres so they are at least `gap` apart, keeping order.
def spread(centres, gap, lo, hi)
  ys = centres.dup
  (1...ys.size).each { |i| ys[i] = [ys[i], ys[i - 1] + gap].max }
  over = ys.last - hi
  if over > 0
    ys[-1] -= over
    (ys.size - 2).downto(0) { |i| ys[i] = [ys[i], ys[i + 1] - gap].min }
  end
  ys.map { |y| [y, lo].max }
end

# Two stacked columns (where from -> where to) joined by one flow band.
# Stage `s_left` grows the left column; stage `s_right` sweeps the band right and
# fills the right column. callouts: [[stage, text], ...] shown under the chart.
def flow_chart(id:, left:, right:, unit:, left_title:, right_title:, s_left: 1, s_right: 2, callouts: [], highlight: nil, delay_right: 0)
  w, top, avail, gap = 640, 46, 300, 7
  xl, xr, bw = 214, 412, 16
  total = [left.values.sum, right.values.sum].max
  k = (avail - gap * ([left.size, right.size].max - 1)) / total.to_f

  stack = lambda do |data, x|
    y = top
    data.map do |name, v|
      h = [v * k, 2].max
      seg = [name, v, y, h]
      y += h + gap
      seg
    end
  end
  ls = stack.call(left, xl)
  rs = stack.call(right, xr)
  fmt = ->(v) { v >= 100 ? v.round.to_s.reverse.scan(/\d{1,3}/).join(",").reverse : v.to_s }

  out = []
  out << %(<svg class="redraw" viewBox="70 0 520 430" role="img" aria-label="#{esc(left_title)} and #{esc(right_title)}">)
  out << %(<defs><linearGradient id="#{id}-band" x1="0" x2="1" y1="0" y2="0"><stop offset="0" stop-color="#c9a961" stop-opacity=".55"/><stop offset="1" stop-color="#c9a961" stop-opacity=".18"/></linearGradient></defs>)
  out << %(<text x="#{xl + bw / 2}" y="24" text-anchor="middle" class="gold s#{s_left}" style="font-size:13px">#{esc(left_title)}</text>)
  out << %(<text x="#{xr + bw / 2}" y="24" text-anchor="middle" class="gold s#{s_right}" style="font-size:13px;transition-delay:1s">#{esc(right_title)}</text>)

  # flow band from the full left column to the full right column
  l0, l1 = ls.first[2], ls.last[2] + ls.last[3]
  r0, r1 = rs.first[2], rs.last[2] + rs.last[3]
  mx = (xl + bw + xr) / 2.0
  out << %(<path class="grow grow-x s#{s_right}" d="M#{xl + bw} #{l0} C#{mx} #{l0} #{mx} #{r0} #{xr} #{r0} L#{xr} #{r1} C#{mx} #{r1} #{mx} #{l1} #{xl + bw} #{l1} Z" fill="url(##{id}-band)"/>)

  left_labels = spread(ls.map { |_, _, y, h| y + h / 2 }, 30, top + 6, top + avail + 40)
  ls.each_with_index do |(name, v, y, h), i|
    hl = highlight == name ? ";stroke:#e6cf95;stroke-width:1.5" : ""
    out << %(<rect class="grow grow-y s#{s_left}" x="#{xl}" y="#{y.round(1)}" width="#{bw}" height="#{h.round(1)}" style="fill:#{REGION_COLOURS[name]};transition-delay:#{(i * 0.08).round(2)}s#{hl}"/>)
    ly = left_labels[i]
    out << %(<text class="s#{s_left}" x="#{xl - 10}" y="#{(ly - 2).round(1)}" text-anchor="end" style="transition-delay:#{(i * 0.08).round(2)}s">#{esc(name)}</text>)
    out << %(<text class="s#{s_left}" x="#{xl - 10}" y="#{(ly + 13).round(1)}" text-anchor="end" style="fill:#{REGION_COLOURS[name]};font-size:12px;transition-delay:#{(i * 0.08).round(2)}s">#{fmt.call(v)}#{unit}</text>)
  end
  right_labels = spread(rs.map { |_, _, y, h| y + h / 2 }, 30, top + 6, top + avail + 40)
  rs.each_with_index do |(name, v, y, h), i|
    d = (0.9 + delay_right + i * 0.08).round(2)
    hl = highlight == name ? ";stroke:#e6cf95;stroke-width:1.5" : ""
    out << %(<rect class="grow grow-y s#{s_right}" x="#{xr}" y="#{y.round(1)}" width="#{bw}" height="#{h.round(1)}" style="fill:#{REGION_COLOURS[name]};transition-delay:#{d}s#{hl}"/>)
    ly = right_labels[i]
    out << %(<text class="s#{s_right}" x="#{xr + bw + 10}" y="#{(ly - 2).round(1)}" style="transition-delay:#{d}s">#{esc(name)}</text>)
    out << %(<text class="s#{s_right}" x="#{xr + bw + 10}" y="#{(ly + 13).round(1)}" style="fill:#{REGION_COLOURS[name]};font-size:12px;transition-delay:#{d}s">#{fmt.call(v)}#{unit}</text>)
  end
  callouts.each_with_index do |(stage, text), i|
    out << %(<text class="callout s#{stage}" x="#{w / 2}" y="#{top + avail + 58 + i * 20}" text-anchor="middle" style="transition-delay:#{(1.6 + i * 0.3).round(1)}s">#{esc(text)}</text>)
  end
  out << "</svg>"
  out.join("\n")
end

# Fig 3: UHC attributes -> six shared policies -> AMR objectives.
def amr_chart
  left = [
    ["Quality", "Health regulations"], ["Quality", "Engaging service users"],
    ["Efficiency", "Aligning incentives"],
    ["Equity", "Access and protection for vulnerable groups"],
    ["Accountability", "Political vision"], ["Accountability", "Engaging across sectors"],
    ["Sustainability", "Participatory governance"]
  ]
  policies = [
    ["#5b8ee0", "Hygiene standards instead", "of antibiotic use"],
    ["#4fb27a", "Regulate antibiotics for", "quality and affordability"],
    ["#8a74d6", "Balance treatment failure", "against overuse"],
    ["#d9528c", "End perverse incentives", "to overuse antibiotics"],
    ["#e8913f", "Senior leadership on", "ethical antibiotic use"],
    ["#38b9b5", "Public-private partnerships", "for new antimicrobials"]
  ]
  right = ["Awareness and education", "Infection prevention", "Optimal use of medicines", "Surveillance and research", "Economic investment"]
  l2p = { 0 => [0, 2, 3], 1 => [4], 2 => [3], 3 => [1, 2], 4 => [4], 5 => [4, 5], 6 => [4] }
  p2r = { 0 => [0, 1, 2], 1 => [2], 2 => [2, 3], 3 => [2], 4 => [0, 3], 5 => [4] }

  w, h = 900, 440
  lx, px, pw, rx = 196, 330, 240, 704
  ly = ->(i) { 52 + i * 52 }
  py = ->(i) { 44 + i * 64 }
  ry = ->(i) { 70 + i * 72 }
  out = [%(<svg class="redraw" viewBox="0 0 #{w + 40} #{h}" role="img" aria-label="Seven UHC attributes and five antimicrobial resistance objectives converge on six shared policies">)]
  out << %(<text x="#{lx}" y="22" text-anchor="end" class="gold s1" style="font-size:12px;letter-spacing:.12em">UHC ATTRIBUTES</text>)
  out << %(<text x="#{px + pw / 2}" y="22" text-anchor="middle" class="gold s2" style="font-size:12px;letter-spacing:.12em">SIX SHARED POLICIES</text>)
  out << %(<text x="#{rx}" y="22" class="gold s3" style="font-size:12px;letter-spacing:.12em">AMR OBJECTIVES</text>)

  # links first so they sit underneath the boxes
  l2p.each do |li, ps|
    ps.each_with_index do |pi, j|
      y1 = ly.call(li); y2 = py.call(pi) + 24
      out << %(<path class="draw s2" pathLength="1" d="M#{lx + 8} #{y1} C#{lx + 70} #{y1} #{px - 70} #{y2} #{px} #{y2}" style="fill:none;stroke:#{policies[pi][0]};stroke-width:2;opacity:.85;transition-delay:#{(0.15 * pi).round(2)}s"/>)
    end
  end
  p2r.each do |pi, rs|
    rs.each do |ri|
      y1 = py.call(pi) + 24; y2 = ry.call(ri)
      out << %(<path class="draw s3" pathLength="1" d="M#{px + pw} #{y1} C#{px + pw + 70} #{y1} #{rx - 70} #{y2} #{rx - 8} #{y2}" style="fill:none;stroke:#{policies[pi][0]};stroke-width:2;opacity:.85;transition-delay:#{(0.15 * pi).round(2)}s"/>)
    end
  end

  left.each_with_index do |(group, item), i|
    y = ly.call(i)
    out << %(<circle class="s1" cx="#{lx + 6}" cy="#{y}" r="4" style="fill:#0b2a33;stroke:#c9a961;transition-delay:#{(i * 0.07).round(2)}s"/>)
    out << %(<text class="s1" x="#{lx - 6}" y="#{y - 4}" text-anchor="end" style="fill:#c9a961;font-size:11px;transition-delay:#{(i * 0.07).round(2)}s">#{esc(group.upcase)}</text>)
    words = item.split
    lines = item.size > 24 ? [words[0...(words.size / 2.0).ceil].join(" "), words[(words.size / 2.0).ceil..].join(" ")] : [item]
    lines.each_with_index do |ln, k|
      out << %(<text class="s1" x="#{lx - 6}" y="#{y + 11 + k * 14}" text-anchor="end" style="transition-delay:#{(i * 0.07).round(2)}s">#{esc(ln)}</text>)
    end
  end
  policies.each_with_index do |(col, a, b), i|
    y = py.call(i)
    out << %(<g class="s2" style="transition-delay:#{(0.4 + i * 0.15).round(2)}s"><rect x="#{px}" y="#{y}" width="#{pw}" height="48" rx="6" style="fill:#{col}"/><text x="#{px + pw / 2}" y="#{y + 21}" text-anchor="middle" style="fill:#fff;font-size:12.5px">#{esc(a)}</text><text x="#{px + pw / 2}" y="#{y + 37}" text-anchor="middle" style="fill:#fff;font-size:12.5px">#{esc(b)}</text></g>)
  end
  right.each_with_index do |t, i|
    y = ry.call(i)
    d = (1.2 + i * 0.1).round(2)
    out << %(<circle class="s3" cx="#{rx - 4}" cy="#{y}" r="4" style="fill:#0b2a33;stroke:#c9a961;transition-delay:#{d}s"/>)
    out << %(<text class="s3" x="#{rx + 6}" y="#{y + 5}" style="transition-delay:#{d}s">#{esc(t)}</text>)
  end
  out << "</svg>"
  out.join("\n")
end

# Fig 4: congestion in development aid, built up in four stages.
def aid_network
  w, h = 900, 520
  cx, cy = 450, 262
  hubs = {
    "UHC" => ["Universal health coverage", 450, 92],
    "A" => ["AIDS, TB and malaria", 196, 186],
    "HS" => ["Health security", 282, 372],
    "MAT" => ["Maternal and child health", 704, 186],
    "N" => ["Nutrition", 618, 372]
  }
  hub_col = { "UHC" => "#5b8ee0", "A" => "#4fb27a", "HS" => "#8a74d6", "MAT" => "#e8913f", "N" => "#d9528c" }
  ministries = [["MoH", 0], ["MoF", 0], ["MoFA", 1], ["MoHA", 1], ["MoLSW", 1], ["MAF", 1], ["MoES", 1], ["MoD", 1], ["MPWT", 1]]
  # [name, stage, hubs]
  outer = [
    ["WHO", 2, %w[UHC A HS MAT N]], ["World Bank", 2, %w[UHC A HS MAT N]], ["Unicef", 2, %w[MAT N UHC]],
    ["Gavi", 2, %w[MAT UHC]], ["Global Fund", 2, %w[A UHC]], ["UNAIDS", 2, %w[A]], ["UNFPA", 2, %w[MAT]],
    ["ILO", 2, %w[UHC]], ["FAO", 2, %w[N HS]], ["WFP", 2, %w[N]], ["ADB", 2, %w[HS UHC]], ["OIE", 2, %w[HS]],
    ["SUN", 2, %w[N]], ["UNOPS", 2, %w[A]],
    ["USAID", 3, %w[A HS N]], ["JICA", 3, %w[UHC MAT HS]], ["KOICA", 3, %w[HS UHC]], ["KOFIH", 3, %w[MAT]],
    ["AFD", 3, %w[A HS]], ["Australia DFAT", 3, %w[A HS]], ["EU", 3, %w[N UHC]], ["LuxDev", 3, %w[A MAT N UHC]],
    ["SDC", 3, %w[N]], ["US CDC", 3, %w[HS]],
    ["Civil society", 4, %w[A HS MAT N]], ["Int'l NGOs", 4, %w[MAT N]], ["Philanthropy", 4, %w[MAT HS]],
    ["Private industry", 4, %w[N UHC]], ["Patient groups", 4, %w[A]], ["Academia", 4, %w[N UHC]],
    ["Int'l alliances", 4, %w[HS]], ["Red Cross", 4, %w[MAT UHC]]
  ]
  pos = {}
  ministries.each_with_index do |(m, ring), i|
    if ring == 0
      pos[m] = [cx + (i == 0 ? -34 : 34), cy]
    else
      a = 2 * Math::PI * (i - 2) / 7 - Math::PI / 2
      pos[m] = [(cx + 112 * Math.cos(a)).round(1), (cy + 72 * Math.sin(a)).round(1)]
    end
  end
  outer.each_with_index do |(n, _, _), i|
    a = 2 * Math::PI * i / outer.size - Math::PI / 2 + 0.05
    pos[n] = [(cx + 360 * Math.cos(a)).round(1), (cy + 228 * Math.sin(a)).round(1)]
  end
  hubs.each { |k, (_, x, y)| pos[k] = [x, y] }

  links = []  # [stage, a, b, colour]
  ministry_hubs = { "MoH" => hubs.keys, "MoF" => %w[UHC], "MoFA" => %w[A HS], "MoHA" => %w[A HS], "MoLSW" => %w[UHC],
                    "MAF" => %w[HS N], "MoES" => %w[HS N], "MoD" => %w[HS], "MPWT" => %w[HS] }
  ministry_hubs.each { |m, hs| hs.each { |hb| links << [1, m, hb, hub_col[hb]] } }
  outer.each do |n, st, hs|
    hs.each { |hb| links << [st, n, hb, hub_col[hb]] }
    links << [st, n, "MoH", "#c9a961"]
    links << [st, n, "MoF", "#c9a961"] if st == 2 && %w[World\ Bank ADB].include?(n)
  end
  # stage 4 also adds partner-to-partner overlaps
  [["Civil society", "UNAIDS"], ["Int'l NGOs", "Unicef"], ["Philanthropy", "Gavi"], ["Private industry", "WHO"],
   ["Patient groups", "Global Fund"], ["Academia", "WHO"], ["Red Cross", "Unicef"], ["Int'l alliances", "US CDC"],
   ["USAID", "Global Fund"], ["JICA", "WHO"], ["EU", "World Bank"], ["LuxDev", "Unicef"]].each { |a, b| links << [4, a, b, "#c9a961"] }

  counts = (1..4).map { |s| links.count { |l| l[0] <= s } }
  out = [%(<svg class="redraw" viewBox="-40 0 #{w + 80} #{h}" role="img" aria-label="A recipient country's ministries connected to more and more agencies, donors and partners">)]
  links.each_with_index do |(st, a, b, col), i|
    x1, y1 = pos[a]; x2, y2 = pos[b]
    out << %(<path class="draw s#{st}" pathLength="1" d="M#{x1} #{y1} L#{x2} #{y2}" style="fill:none;stroke:#{col};stroke-width:1.1;opacity:.55;transition-delay:#{((i % 25) * 0.04).round(2)}s"/>)
  end
  hubs.each do |k, (label, x, y)|
    out << %(<g class="s1"><circle cx="#{x}" cy="#{y}" r="22" style="fill:#0b2a33;stroke:#{hub_col[k]};stroke-width:2.5"/><text x="#{x}" y="#{y + 5}" text-anchor="middle" style="fill:#{hub_col[k]};font-weight:700;font-size:13px">#{k}</text><text x="#{x}" y="#{y + 40}" text-anchor="middle" style="font-size:11.5px;fill:#{hub_col[k]}">#{esc(label)}</text></g>)
  end
  ministries.each do |m, ring|
    x, y = pos[m]
    if ring == 0
      out << %(<g class="s1"><circle cx="#{x}" cy="#{y}" r="21" style="fill:#e6cf95"/><text x="#{x}" y="#{y + 4}" text-anchor="middle" style="fill:#0b2a33;stroke:none;font-weight:700;font-size:11.5px">#{m}</text></g>)
    else
      out << %(<g class="s1"><circle cx="#{x}" cy="#{y}" r="5" style="fill:#e6cf95"/><text x="#{x}" y="#{y - 9}" text-anchor="middle" style="font-size:10px">#{m}</text></g>)
    end
  end
  outer.each_with_index do |(n, st, _), i|
    x, y = pos[n]
    anchor = x > cx + 30 ? "start" : (x < cx - 30 ? "end" : "middle")
    dx = anchor == "start" ? 9 : (anchor == "end" ? -9 : 0)
    dy = anchor == "middle" ? (y < cy ? -10 : 18) : 4
    out << %(<g class="s#{st}" style="transition-delay:#{((i % 14) * 0.05).round(2)}s"><circle cx="#{x}" cy="#{y}" r="5" style="fill:#0b2a33;stroke:#e6cf95;stroke-width:1.5"/><text x="#{x + dx}" y="#{y + dy}" text-anchor="#{anchor}" style="font-size:11.5px">#{esc(n)}</text></g>)
  end
  counts.each_with_index do |c, i|
    out << %(<text class="only-#{i + 1}" x="#{w - 6}" y="#{h - 8}" text-anchor="end" style="fill:#e6cf95;font-size:14px;font-weight:700">#{c} connections</text>)
  end
  out << "</svg>"
  [out.join("\n"), counts]
end
