# Origin -> destination flows behind the Sankey diagrams in Bloom et al.,
# BMJ 2019;365:l2107 (Figs 1 and 2).
#
# The paper prints only each region's totals. The corridor sizes below were
# measured from the paper's own figures: at each destination bar the incoming
# bands are stacked and coloured by origin, so the pixel height of each colour
# (read column by column from the figure image) gives that corridor's share of
# the destination total. The table was then balanced (iterative proportional
# fitting) so every row and column matches the printed totals exactly.
# Cross-check for Fig 1 against UN DESA 2017: Asia->Asia ~63m, Europe->Europe
# ~41m, Latin America->Northern America ~26m, Asia->Europe ~20m.
# Re-derive with the measuring scripts if the figures change; don't hand-edit.

MIGRANT_FLOWS = { # millions, 2017 (Fig 1)
  "Africa"           => { "Africa" => 18.94, "Asia" => 4.60, "Europe" => 8.57, "Latin America" => 0.59, "Northern America" => 2.72, "Oceania" => 0.79 },
  "Asia"             => { "Africa" => 1.40, "Asia" => 63.17, "Europe" => 19.93, "Latin America" => 0.13, "Northern America" => 17.63, "Oceania" => 3.39 },
  "Europe"           => { "Africa" => 0.65, "Asia" => 6.81, "Europe" => 42.15, "Latin America" => 0.68, "Northern America" => 8.06, "Oceania" => 2.87 },
  "Latin America"    => { "Africa" => 0.39, "Asia" => 0.72, "Europe" => 4.26, "Latin America" => 5.89, "Northern America" => 25.83, "Oceania" => 0.72 },
  "Northern America" => { "Africa" => 0.18, "Asia" => 0.25, "Europe" => 1.47, "Latin America" => 1.51, "Northern America" => 0.99, "Oceania" => 0.00 },
  "Oceania"          => { "Africa" => 0.13, "Asia" => 0.36, "Europe" => 0.42, "Latin America" => 0.39, "Northern America" => 0.07, "Oceania" => 0.53 }
}

DOCTOR_FLOWS = { # thousands, OECD destinations, 2012-16 (Fig 2)
  "Africa"           => { "Asia" => 7.30, "Europe" => 111.86, "Latin America" => 1.84, "Northern America" => 114.08, "Oceania" => 10.92 },
  "Asia"             => { "Asia" => 0.00, "Europe" => 259.16, "Latin America" => 0.00, "Northern America" => 726.94, "Oceania" => 34.90 },
  "Europe"           => { "Asia" => 88.34, "Europe" => 562.67, "Latin America" => 0.00, "Northern America" => 291.12, "Oceania" => 35.87 },
  "Latin America"    => { "Asia" => 8.38, "Europe" => 18.89, "Latin America" => 3.53, "Northern America" => 71.83, "Oceania" => 8.36 },
  "Northern America" => { "Asia" => 0.00, "Europe" => 12.43, "Latin America" => 3.69, "Northern America" => 352.88, "Oceania" => 0.00 },
  "Oceania"          => { "Asia" => 5.98, "Europe" => 5.99, "Latin America" => 3.93, "Northern America" => 6.15, "Oceania" => 11.94 }
}

NURSE_FLOWS = { # thousands, OECD destinations, 2012-16 (Fig 2)
  "Africa"           => { "Asia" => 2.71, "Europe" => 43.71, "Latin America" => 0.00, "Northern America" => 10.21, "Oceania" => 16.01 },
  "Asia"             => { "Asia" => 0.60, "Europe" => 184.12, "Latin America" => 0.43, "Northern America" => 105.86, "Oceania" => 78.18 },
  "Europe"           => { "Asia" => 25.14, "Europe" => 566.57, "Latin America" => 0.73, "Northern America" => 48.97, "Oceania" => 79.05 },
  "Latin America"    => { "Asia" => 6.72, "Europe" => 25.44, "Latin America" => 0.54, "Northern America" => 4.26, "Oceania" => 0.85 },
  "Northern America" => { "Asia" => 3.19, "Europe" => 10.85, "Latin America" => 0.00, "Northern America" => 18.17, "Oceania" => 3.62 },
  "Oceania"          => { "Asia" => 4.64, "Europe" => 6.31, "Latin America" => 0.00, "Northern America" => 3.53, "Oceania" => 32.29 }
}

# Totals exactly as printed in the paper (used for the bar labels).
MIGRANT_SOURCE_TOTALS = { "Africa" => 36.2, "Asia" => 105.6, "Europe" => 61.2, "Latin America" => 37.8, "Northern America" => 4.4, "Oceania" => 1.9 }
MIGRANT_DEST_TOTALS   = { "Africa" => 21.7, "Asia" => 75.9, "Europe" => 76.8, "Latin America" => 9.2, "Northern America" => 55.3, "Oceania" => 8.3 }
DOCTOR_SOURCE_TOTALS  = { "Africa" => 246, "Asia" => 1021, "Europe" => 978, "Latin America" => 111, "Northern America" => 369, "Oceania" => 34 }
DOCTOR_DEST_TOTALS    = { "Asia" => 110, "Europe" => 971, "Latin America" => 13, "Northern America" => 1563, "Oceania" => 102 }
NURSE_SOURCE_TOTALS   = { "Africa" => 73, "Asia" => 371, "Europe" => 724, "Latin America" => 38, "Northern America" => 36, "Oceania" => 47 }
NURSE_DEST_TOTALS     = { "Asia" => 43, "Europe" => 837, "Latin America" => 1.7, "Northern America" => 191, "Oceania" => 210 }
