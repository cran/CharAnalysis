## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse  = TRUE,
  comment   = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5,
  warning   = FALSE,
  message   = FALSE
)

# Suggests-package gate: figure chunks live-render only when ggplot2,
# patchwork, and ggtext are all installed. If any is missing, those
# chunks skip cleanly and the rest of the vignette still builds.
PLOT_OK <- requireNamespace("ggplot2",   quietly = TRUE) &&
           requireNamespace("patchwork", quietly = TRUE) &&
           requireNamespace("ggtext",    quietly = TRUE)

## ----install, eval = FALSE----------------------------------------------------
# # Install from GitHub (requires devtools)
# devtools::install_github("phiguera/CharAnalysis",
#                          subdir = "CharAnalysis_2_0_R")
# 
# # Suggested packages for figures
# install.packages(c("ggplot2", "patchwork", "ggtext"))

## ----paths--------------------------------------------------------------------
params_file <- system.file("validation", "CO_compensated_charParams.csv",
                           package = "CharAnalysis")
params_file

## ----run, message = TRUE------------------------------------------------------
library(CharAnalysis)
out <- CharAnalysis(params_file)

## ----output-structure---------------------------------------------------------
names(out)

## ----charcoal-----------------------------------------------------------------
# Inspect the first few rows of key time series
head(data.frame(
  age_BP    = out$charcoal$ybpI,          # interpolated age (yr BP)
  CHAR      = out$charcoal$accI,          # C_interpolated  (pieces cm-2 yr-1)
  C_bkg     = out$charcoal$accIS,         # C_background
  C_peak    = out$charcoal$peak,          # C_peak (residuals)
  peaks     = out$charcoal$charPeaks[, 4] # final-threshold peak flags (0/1)
))

## ----thresh-------------------------------------------------------------------
# Threshold at the final percentile (column 4 = threshValues[4])
range(out$char_thresh$pos[, 4], na.rm = TRUE)

# Signal-to-noise index (SNI): values > 3 indicate a strong signal
summary(out$char_thresh$SNI)

## ----post---------------------------------------------------------------------
# Fire-return intervals (FRIs) and mean FRI
cat("Number of FRIs:", length(out$post$FRI), "\n")
cat("Mean FRI:", round(mean(out$post$FRI), 1), "yr\n")

# Per-zone Weibull statistics (zone 1)
fri_z1 <- out$post$FRI_params_zone[1, ]
cat(sprintf(
  "Zone 1 — nFRI: %d  mFRI: %.1f yr  WBLb: %.1f  WBLc: %.2f\n",
  fri_z1[1], fri_z1[2], fri_z1[5], fri_z1[8]
))

## ----char-results-------------------------------------------------------------
dim(out$char_results)

# Total number of fire events identified
sum(out$charcoal$charPeaks[, 4], na.rm = TRUE)

## ----fig1, eval = PLOT_OK, fig.width = 7, fig.height = 5----------------------
char_plot_raw(out)

## ----fig2, eval = PLOT_OK, fig.width = 8, fig.height = 8----------------------
char_plot_thresh_diag(out)

## ----fig3, eval = PLOT_OK, fig.width = 7, fig.height = 6----------------------
char_plot_peaks(out)

## ----fig5, eval = PLOT_OK, fig.width = 7, fig.height = 4----------------------
char_plot_cumulative(out)

## ----fig6, eval = PLOT_OK, fig.width = 7, fig.height = 5----------------------
char_plot_fri(out)

## ----fig7, eval = PLOT_OK, fig.width = 7, fig.height = 8----------------------
char_plot_fire_history(out)

## ----fig8, eval = PLOT_OK, fig.width = 8, fig.height = 4----------------------
char_plot_zones(out)

## ----save-figs, eval = FALSE--------------------------------------------------
# char_plot_all(out, save = TRUE, out_dir = tempdir())
# # Saves to tempdir():
# #   CO_03_CHAR_analysis.pdf
# #   CO_05_cumulative_peaks.pdf
# #   CO_06_FRI_distributions.pdf
# #   CO_07_continuous_fire_hx.pdf
# #   CO_08_zone_comparisons.pdf

## ----write, eval = FALSE------------------------------------------------------
# char_write_results(out$char_results,
#                  site    = out$site,
#                  out_dir = tempdir())
# # Writes: <tempdir>/CO_charResults.csv

