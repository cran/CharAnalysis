## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse  = TRUE,
  comment   = "#>",
  fig.align = "center",
  warning   = FALSE,
  message   = FALSE
)

## ----install, eval = FALSE----------------------------------------------------
# # Install from GitHub (requires devtools)
# devtools::install_github("phiguera/CharAnalysis",
#                          subdir = "CharAnalysis_2_0_R")
# 
# # Suggested packages for figures
# install.packages(c("ggplot2", "patchwork", "ggtext"))

## ----paths, eval = FALSE------------------------------------------------------
# params_file <- system.file("extdata", "CO_charParams.csv",
#                            package = "CharAnalysis")

## ----set-paths, eval = FALSE--------------------------------------------------
# params_file <- "path/to/CO_charParams.csv"   # adjust to your local path

## ----run, eval = FALSE--------------------------------------------------------
# library(CharAnalysis)
# 
# out <- CharAnalysis(params_file)

## ----output-structure, eval = FALSE-------------------------------------------
# names(out)
# #> [1] "charcoal"      "pretreatment"  "smoothing"     "peak_analysis"
# #> [5] "results"       "site"          "gap_in"        "char_thresh"
# #> [9] "post"          "char_results"

## ----charcoal, eval = FALSE---------------------------------------------------
# # Inspect the first few rows of key time series
# head(data.frame(
#   age_BP    = out$charcoal$ybpI,          # interpolated age (yr BP)
#   CHAR      = out$charcoal$accI,          # C_interpolated  (pieces cm-2 yr-1)
#   C_bkg     = out$charcoal$accIS,         # C_background
#   C_peak    = out$charcoal$peak,          # C_peak (residuals)
#   peaks     = out$charcoal$charPeaks[, 4] # final-threshold peak flags (0/1)
# ))

## ----thresh, eval = FALSE-----------------------------------------------------
# # Threshold at the final percentile (column 4 = threshValues[4])
# range(out$char_thresh$pos[, 4], na.rm = TRUE)
# 
# # Signal-to-noise index (SNI): values > 3 indicate a strong signal
# summary(out$char_thresh$SNI)

## ----post, eval = FALSE-------------------------------------------------------
# # Fire-return intervals (FRIs) and mean FRI
# cat("Number of FRIs:", length(out$post$FRI), "\n")
# cat("Mean FRI:", round(mean(out$post$FRI), 1), "yr\n")
# 
# # Per-zone Weibull statistics (zone 1)
# fri_z1 <- out$post$FRI_params_zone[1, ]
# cat(sprintf(
#   "Zone 1 — nFRI: %d  mFRI: %.1f yr  WBLb: %.1f  WBLc: %.2f\n",
#   fri_z1[1], fri_z1[2], fri_z1[5], fri_z1[8]
# ))

## ----char-results, eval = FALSE-----------------------------------------------
# dim(out$char_results)
# #> [1] 500  33
# 
# # Total number of fire events identified
# sum(out$charcoal$charPeaks[, 4], na.rm = TRUE)
# #> [1] 39

## ----fig3, eval = FALSE-------------------------------------------------------
# char_plot_peaks(out)

## ----fig5, eval = FALSE-------------------------------------------------------
# char_plot_cumulative(out)

## ----fig6, eval = FALSE-------------------------------------------------------
# char_plot_fri(out)

## ----fig7, eval = FALSE-------------------------------------------------------
# char_plot_fire_history(out)

## ----fig8, eval = FALSE-------------------------------------------------------
# char_plot_zones(out)

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

