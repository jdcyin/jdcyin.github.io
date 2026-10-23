# Replacement chapters 2, 4 and 6 for make_t20c.rb (redrawn, staged figures).
# Step tuples: [viz, section, pillar, kicker, heading, paragraphs, stage]
SRC_NOTE = %(<div class="viz-note">Redrawn from data in Bloom et al., BMJ 2019 (Fig %s).</div>)

CH2 = lambda do
  chapter("scrolly--wide", "Leaving no one behind", [
    ["migrants", flow_chart(id: "mig", unit: "m",
      left: { "Africa" => 36.2, "Asia" => 105.6, "Europe" => 61.2, "Latin America" => 37.8, "Northern America" => 4.4, "Oceania" => 1.9 },
      right: { "Africa" => 21.7, "Asia" => 75.9, "Europe" => 76.8, "Latin America" => 9.2, "Northern America" => 55.3, "Oceania" => 8.3 },
      left_title: "Where migrants come from", right_title: "Where they live now",
      highlight: "Northern America",
      callouts: [[2, "Northern America: 4.4m migrants from it, 55.3m living there"]]) + "\n" + SRC_NOTE % "1"],
    ["labour", <<~H],
      <div class="viz-title">Where labour migrants go (2017)</div>
      <div class="viz-bar is-minority"><span>N, S &amp; W Europe</span><span class="track"><span class="fill" style="--w: 100%"></span></span><span class="val">39.2m</span></div>
      <div class="viz-bar is-minority"><span>Northern America</span><span class="track"><span class="fill" style="--w: 96.2%"></span></span><span class="val">37.7m</span></div>
      <div class="viz-bar is-minority"><span>Arab states</span><span class="track"><span class="fill" style="--w: 57.9%"></span></span><span class="val">22.7m</span></div>
      <div class="viz-bar is-minority"><span>Eastern Europe</span><span class="track"><span class="fill" style="--w: 33.7%"></span></span><span class="val">13.2m</span></div>
      <div class="viz-bar is-minority"><span>Sub-Saharan Africa</span><span class="track"><span class="fill" style="--w: 30.4%"></span></span><span class="val">11.9m</span></div>
      <div class="viz-bar is-minority"><span>SE Asia &amp; Pacific</span><span class="track"><span class="fill" style="--w: 29.6%"></span></span><span class="val">11.6m</span></div>
      <div class="viz-bar"><span>Other regions</span><span class="track"><span class="fill" style="--w: 70.2%"></span></span><span class="val">27.5m</span></div>
      <div class="viz-note">163.8 million labour migrants in total: 86.5% aged 25-64, 41.6% women. Redrawn from data in Bloom et al., BMJ 2019 (Fig 1).</div>
    H
    ["doctors", flow_chart(id: "doc", unit: "k",
      left: { "Africa" => 246, "Asia" => 1021, "Europe" => 978, "Latin America" => 111, "Northern America" => 369, "Oceania" => 34 },
      right: { "Asia" => 110, "Europe" => 971, "Latin America" => 13, "Northern America" => 1563, "Oceania" => 102 },
      left_title: "Where doctors trained", right_title: "Where they work (OECD)",
      highlight: "Northern America",
      callouts: [[2, "Northern America employs 1.56 million foreign-trained doctors"]]) + "\n" + SRC_NOTE % "2, 2012-16"],
    ["nurses", flow_chart(id: "nur", unit: "k",
      left: { "Africa" => 73, "Asia" => 371, "Europe" => 724, "Latin America" => 38, "Northern America" => 36, "Oceania" => 47 },
      right: { "Asia" => 43, "Europe" => 837, "Latin America" => 1.7, "Northern America" => 191, "Oceania" => 210 },
      left_title: "Where nurses trained", right_title: "Where they work (OECD)",
      highlight: "Europe",
      callouts: [[1, "Europe employs 837,000 foreign-trained nurses"]], delay_right: 0.4, s_right: 1) + "\n" + SRC_NOTE % "2, 2012-16"],
  ], [
    ["migrants", "Leaving no one behind", 1, "1 · Leaving no one behind", "258 million people on the move",
     ["In 2017 there were 258 million international migrants, 3.4% of the world's population. Start with where they come from: Asia, then Europe."], 1],
    ["migrants", "Leaving no one behind", 1, "1 · Leaving no one behind", "And where they end up",
     ["Northern America sends few migrants but hosts 55 million. Migrant health is a unique and so far neglected challenge for universal health coverage."], 2],
    ["labour", "Leaving no one behind", 1, "1 · Leaving no one behind", "Most of them move for work",
     ["Work drives 64% of migration: 164 million migrant workers. Many G20 members are major destinations, so they are well placed to lead on migrant health and shared migration data."], 1],
    ["doctors", "Leaving no one behind", 1, "1 · Leaving no one behind", "Health systems run on migrants too",
     ["Many countries rely on foreign-trained doctors. Asia and Europe train the most, and Northern America employs the most."], 1],
    ["doctors", "Leaving no one behind", 1, "1 · Leaving no one behind", "Health systems run on migrants too",
     ["When health workers move from poorer to richer countries, the countries that trained them lose that investment."], 2],
    ["nurses", "Leaving no one behind", 1, "1 · Leaving no one behind", "And on foreign-trained nurses",
     ["The same pattern holds for nurses. The G20 should systematically measure the mobility of the health workforce."], 1],
  ])
end

CH4 = lambda do
  chapter("scrolly--wide scrolly--cards-right", "Financing", [
    ["amr", amr_chart + "\n" + SRC_NOTE % "3"],
  ], [
    ["amr", "Financing", 2, "2 · Financing", "Making every resource count",
     ["Affordable, good-quality medicines matter, especially antimicrobials, where misuse drives resistance. Start with what universal health coverage asks of a health system."], 1],
    ["amr", "Financing", 2, "2 · Financing", "Six shared policies",
     ["Those goals point to six concrete policies, from hygiene standards to ending incentives that encourage overuse."], 2],
    ["amr", "Financing", 2, "2 · Financing", "That also fight resistance",
     ["The same six policies serve the WHO's goals against antimicrobial resistance, so governments can pursue both at once."], 3],
  ])
end

CH6 = lambda do
  net, counts = aid_network
  chapter("scrolly--wide", "Cooperation", [
    ["aid", net + "\n" + %(<div class="viz-note">Illustrative network for a typical recipient country, redrawn after Fig 4 in Bloom et al., BMJ 2019.</div>)],
  ], [
    ["aid", "Cooperation", 4, "4 · Cooperation", "One country, many priorities",
     ["Start with a recipient country's own ministries, juggling five areas: universal health coverage, AIDS, TB and malaria, health security, maternal and child health, and nutrition."], 1],
    ["aid", "Cooperation", 4, "4 · Cooperation", "Add the international agencies",
     ["UN agencies, the World Bank and global funds each work across several of those areas."], 2],
    ["aid", "Cooperation", 4, "4 · Cooperation", "Then the donor countries",
     ["Bilateral agencies such as USAID, JICA and KOICA bring programmes of their own."], 3],
    ["aid", "Cooperation", 4, "4 · Cooperation", "Congestion and gaps",
     ["Add NGOs, philanthropy and industry, and the demands overlap and compete. As the largest providers of aid, G20 members should harmonise it, avoiding duplication and filling gaps."], 4],
  ])
end
