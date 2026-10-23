# Generates _academia/japant20.html: a scroll-through of Bloom et al., BMJ 2019;365:l2107,
# in seven chapters that alternate layouts (panel right, full-width figure, panel left).
# Original figures are reproduced under the article's CC BY-NC 4.0 licence.
out_path = ARGV[0]
FIG = "/assets/img/academia/t20"
CREDIT = "Bloom et al., BMJ 2019. CC BY-NC 4.0."

PILLARS = <<~H
  <div class="scrolly-pillars">
    <span data-pillar="1">1 Equity</span>
    <span data-pillar="2">2 Money</span>
    <span data-pillar="3">3 Tech</span>
    <span data-pillar="4">4 Aid</span>
  </div>
H

def figure(file, alt, caption)
  <<~H
    <figure class="viz-figure">
      <img src="#{FIG}/#{file}" alt="#{alt}" loading="lazy">
      <figcaption>#{caption} #{CREDIT}</figcaption>
    </figure>
  H
end

# layout: "" (panel right), "scrolly--left", or "scrolly--wide" (+ "scrolly--cards-right")
# each step: [viz_key, section_label, pillar_or_nil, kicker, heading, [paragraphs]]
def chapter(layout, first_label, vizzes, steps)
  wide = layout.include?("scrolly--wide")
  viz_html = vizzes.map { |key, inner| %(<div class="viz" data-viz="#{key}">\n#{inner.strip.gsub(/^/, "  ")}\n</div>) }.join("\n\n")
  step_html = steps.map do |key, section, pillar, kicker, heading, paras, stage|
    body = %(<div class="scrolly-kicker">#{kicker}</div>\n<h3>#{heading}</h3>\n) + paras.map { |p| "<p>#{p}</p>" }.join("\n")
    body = %(<div class="scrolly-card">\n#{body.gsub(/^/, "  ")}\n</div>) if wide
    attrs = %(data-viz="#{key}" data-section="#{section}") + (pillar ? %( data-pillar="#{pillar}") : "") + (stage ? %( data-stage="#{stage}") : "")
    %(<div class="scrolly-step" #{attrs}>\n#{body.gsub(/^/, "  ")}\n</div>)
  end.join("\n\n")
  <<~H
    <section class="scrolly #{layout}".strip>
      <div class="scrolly-graphic" aria-hidden="true">
        <div class="scrolly-frame">
          <div class="scrolly-section-label">#{first_label}</div>
    #{viz_html.gsub(/^/, "      ")}
    #{PILLARS.gsub(/^/, "      ")}
        </div>
      </div>
      <div class="scrolly-steps">
    #{step_html.gsub(/^/, "    ")}
      </div>
    </section>
  H
end

require_relative "t20_figures"
require_relative "t20_new_chapters"

chapters = []

# 1. The goal (panel right)
chapters << chapter("", "The goal", [
  ["goal", <<~H],
    <div class="viz-big">SDG 3.8</div>
    <div class="viz-label">The sustainable development goal target for universal health coverage</div>
    <div class="viz-big">2030</div>
    <div class="viz-label">The year the target is meant to be met</div>
  H
  ["timeline", <<~H],
    <div class="viz-title">From Tokyo to the G20</div>
    <div class="viz-timeline">
      <div><b>DEC 2018</b>T20 inception conference, Tokyo</div>
      <div><b>FEB 2019</b>Working group meets in Tokyo</div>
      <div class="is-key"><b>MAY 2019</b>Policy brief at the Think 20 summit; BMJ analysis published</div>
      <div><b>JUN 2019</b>G20 leaders meet in Osaka</div>
      <div><b>SEP 2019</b>UN high-level meeting on UHC</div>
    </div>
  H
  ["ageing", <<~H],
    <div class="viz-title">Where the world's older people live</div>
    <svg viewBox="0 0 300 110" role="img" aria-label="Two in every three older people live in low and middle income regions">
      <circle cx="60" cy="50" r="34" style="fill:#e6cf95"/>
      <circle cx="150" cy="50" r="34" style="fill:#e6cf95"/>
      <circle cx="240" cy="50" r="34" class="node"/>
      <text x="105" y="104" text-anchor="middle" class="gold">low and middle income regions</text>
    </svg>
    <div class="viz-label" style="margin-top:1rem">Two in every three older people. Many primary care systems were built around infectious disease and reproductive health, not the long-term care that older people need.</div>
  H
], [
  ["goal", "The goal", nil, "The goal", "Health coverage for everyone by 2030",
   ["Universal health coverage is a priority for the G20, the World Health Organization and the UN. On current trajectories, four areas are unlikely to progress fast enough to meet the target."]],
  ["timeline", "The goal", nil, "The goal", "Written for the G20",
   ["The brief was prepared by a working group convened by Japan, as host of the 2019 Think 20 summit, and published in The BMJ ahead of the G20 leaders' meeting in Osaka."]],
  ["ageing", "Leaving no one behind", 1, "1 · Leaving no one behind", "Primary care for ageing populations",
   ["Strong primary care reduces inequity. As populations age, it needs to shift towards the sustained care that non-communicable diseases require."]],
])

# 2. Migration (full width, redrawn Figs 1-2)
chapters << CH2.call

# 3. Financing (panel left)
chapters << chapter("scrolly--left", "Financing", [
  ["pressures", <<~H],
    <div class="viz-title">Rising demand, tighter budgets</div>
    <div class="viz-cards">
      <div class="viz-card"><b>Demand rises</b>Ageing populations, non-communicable diseases, new medical technology and higher expectations of care.</div>
      <div class="viz-card"><b>Money tightens</b>Fiscal stagnation linked to ageing and a growing informal economy, plus shocks such as pandemics and climate change.</div>
    </div>
  H
  ["japan", <<~H],
    <div class="viz-title">One model for paying for it: Japan</div>
    <svg viewBox="0 0 320 170" role="img" aria-label="Japan's ministries of health and finance review social insurance fee schedules together">
      <defs><marker id="arrow-gold-t20" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10 z" fill="#c9a961"/></marker></defs>
      <circle class="node" cx="62" cy="80" r="52"/><circle class="node" cx="258" cy="80" r="52"/>
      <text x="62" y="76" text-anchor="middle" class="gold">Ministry</text><text x="62" y="91" text-anchor="middle" class="gold">of Health</text>
      <text x="258" y="76" text-anchor="middle" class="gold">Ministry</text><text x="258" y="91" text-anchor="middle" class="gold">of Finance</text>
      <path class="line" d="M120 64 Q160 44 198 64" marker-end="url(#arrow-gold-t20)"/>
      <path class="line" d="M200 96 Q160 116 122 96" marker-end="url(#arrow-gold-t20)"/>
      <text x="160" y="38" text-anchor="middle">periodic fee</text>
      <text x="160" y="140" text-anchor="middle">schedule review</text>
    </svg>
    <div class="viz-label">Controls overall spending while meeting the needs of a rapidly ageing population.</div>
  H
], [
  ["pressures", "Financing", 2, "2 · Financing", "Demand is outpacing the money",
   ["Health systems face rising demand at a time when many countries are experiencing fiscal stagnation. Mobilising domestic resources is crucial, and so is fiscal discipline."]],
  ["japan", "Financing", 2, "2 · Financing", "Finance and health, working together",
   ["Reliable financing needs finance and health ministries in deliberate dialogue. Japan offers one model."]],
])

# 4. Using resources well (full width, redrawn Fig 3)
chapters << CH4.call

# 5. Innovation and monitoring (panel right)
chapters << chapter("", "Innovation", [
  ["digital", <<~H],
    <div class="viz-title">Five questions regulators must answer</div>
    <div class="viz-card" style="margin-bottom:.5rem"><b>01</b>How can health platforms put the public before commercial interests?</div>
    <div class="viz-card" style="margin-bottom:.5rem"><b>02</b>Should online medical advice be regulated, and algorithms be public goods?</div>
    <div class="viz-card" style="margin-bottom:.5rem"><b>03</b>Who owns users' data, and who updates treatment algorithms?</div>
    <div class="viz-card" style="margin-bottom:.5rem"><b>04</b>How can personal privacy be protected?</div>
    <div class="viz-card"><b>05</b>What does this mean for regulating health professionals?</div>
  H
  ["monitoring", <<~H],
    <div class="viz-title">Measure it the same way everywhere</div>
    <div class="viz-cards">
      <div class="viz-card"><b>Indicator 1</b>Coverage of essential health services</div>
      <div class="viz-card"><b>Indicator 2</b>Financial protection</div>
    </div>
    <div class="viz-label" style="margin-top:1.2rem">The two SDG indicators for UHC only allow comparison if every country collects them the same way. The brief calls for a shared protocol and technical support.</div>
  H
], [
  ["digital", "Innovation", 3, "3 · Innovation", "Harness digital health, but regulate it",
   ["Digital health could transform access to care. Governments need rules in place before it reaches a tipping point, and we proposed a G20 working group to set them."]],
  ["monitoring", "Cooperation", 4, "4 · Cooperation", "Monitor and learn together",
   ["Common monitoring and shared learning platforms let countries compare progress and learn what works, how and why."]],
])

# 6. Aid (full width, redrawn Fig 4)
chapters << CH6.call

# 7. How it was written (panel left)
chapters << chapter("scrolly--left", "How it was written", [
  ["process", <<~H],
    <div class="viz-title">How the brief was written</div>
    <div class="viz-cards">
      <div class="viz-card"><b>21</b>working group members</div>
      <div class="viz-card"><b>15</b>expert contributors</div>
    </div>
    <div class="viz-note">Two Tokyo meetings · Several rounds of drafts · Modified Delphi process</div>
  H
], [
  ["process", "How it was written", nil, "How it was written", "A global working group",
   ["A working group of researchers and policymakers from across Asia, Africa, Europe and North America, with input from civil society, refined the brief through a modified Delphi process.",
    "I compiled and edited the overall draft with Gabriel Leung and created the graphics."]],
])

html = <<~HTML
---
layout: project
scrolly: true
title: 'T20 Japanese Task Force'
caption: Next steps towards universal health coverage call for global leadership
description: >
  What the G20 can do to speed up progress towards universal health coverage. Written for the T20 Japan working group on UHC and published as an analysis in The BMJ (2019).
date: 24 May 2019
image: /assets/img/academia/japant20.jpg
links:
  - title: JOURNAL
    url: https://www.bmj.com/content/365/bmj.l2107/rapid-responses
sitemap: false
---

#{chapters.join("\n")}
<p class="scrolly-citation">Bloom, G., Katsuma, Y., Rao, K.D., Makimoto, S., Yin, J.D.C. and Leung, G.M. (2019). Next steps towards universal health coverage call for global leadership. <a href="https://www.bmj.com/content/365/bmj.l2107/rapid-responses"><i>BMJ</i></a> 365:l2107. Charts redrawn from the article's data.</p>
HTML

html = html.gsub('class="scrolly ".strip>', 'class="scrolly">').gsub(/class="scrolly ([^"]+)".strip>/, 'class="scrolly \1">')
File.write(out_path, html, encoding: "utf-8")
puts "wrote #{out_path}: #{chapters.size} chapters, #{html.scan('class="scrolly-step"').size} steps"
