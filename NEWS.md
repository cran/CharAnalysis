# *CharAnalysis* 2.0.2

Patch release addressing the third round of CRAN reviewer feedback,
plus a related rendering fix discovered during local testing. No
changes to analytical behaviour.

- `Title` field shortened to "Peak Detection and Fire History from
  Sediment-Charcoal Records" (62 characters) to satisfy the CRAN
  convention of titles under 65 characters.
- `char_write_results()` and `char_plot_all()` no longer default
  `out_dir` to the working directory. `out_dir` is now required for
  `char_write_results()` and required when `save = TRUE` for
  `char_plot_all()`. This brings the package into compliance with the
  CRAN policy against writing to the user's home filespace by default.
  Users should pass an explicit path; `tempdir()` is acceptable for a
  transient location.
- Vignette updated to write its example output to `tempdir()` instead of
  a `Results/` directory in the user's working directory, with a note
  that real users would substitute their own path.
- Fixed axis-label rendering in `char_plot_peaks()`,
  `char_plot_fire_history()` (peak-magnitude panel), and
  `char_plot_zones()` (CDF and box-plot panels). These labels were
  still using `expression(paste(...))` (plotmath) syntax and rendered
  as raw text under the `ggtext::element_markdown()` axis-title theme
  introduced in 2.0.1. They now use the same conditional HTML-tag /
  plain-text pattern as the FRI and fire-frequency labels, so super-
  and subscripts render correctly when `ggtext` is available.

# *CharAnalysis* 2.0.1

Patch release addressing CRAN reviewer feedback on the initial submission.
No changes to analytical behaviour.

- DESCRIPTION: condensed to a single paragraph and removed the paragraph
  separators that were rendering as double periods in CRAN metadata.
- `char_parameters()` is now exported. Its help page previously contained
  an example for an unexported function.
- Replaced `\dontrun{}` wrappers in all examples with `\donttest{}` (or
  unwrapped entirely, where the example runs in under 5 seconds). All
  examples now use the bundled validation dataset via `system.file()` and
  write any output to `tempdir()`.

# *CharAnalysis* 2.0.0

First R implementation of *CharAnalysis*, a direct translation of
*CharAnalysis* v2.0 (MATLAB). Analytical outputs are validated against
four benchmark datasets; user testing is ongoing. The package is in the
[experimental](https://lifecycle.r-lib.org/articles/stages.html#experimental)
lifecycle stage: the API may change as user feedback is incorporated.

Please report issues at <https://github.com/phiguera/CharAnalysis/issues>.

## New features relative to MATLAB v2.0

- Full R package with `devtools::install_github()` installation.
- `CharAnalysis()` returns a named list with S3 class `"CharAnalysis"`;
  `print()`, `summary()`, and `plot()` methods are provided.
- Eight publication-quality ggplot2 figures (`char_plot_peaks()`,
  `char_plot_fire_history()`, `char_plot_cumulative()`, `char_plot_fri()`,
  `char_plot_zones()`, `char_plot_raw()`, `char_plot_thresh_diag()`,
  `char_plot_sni()`); save all to PDF with `char_plot_all()`.
- `char_write_results()` writes the 33-column output matrix to CSV with
  column headers and numeric format matching the MATLAB output exactly.

## Known differences from MATLAB v2.0

**Robust lowess background (smoothing method 2).** MATLAB's Curve Fitting
Toolbox `smooth(..., 'rlowess')` and the R `char_lowess()` port handle
NaN gaps differently inside the bisquare robustness iteration, producing
slightly different C_background series for records with missing values.
For gap-free records the difference is negligible (< 0.001); for records
with NaN gaps the maximum absolute difference across validated datasets
is 0.267 (Chickaree Lake). Smoothing method 1 (plain lowess) is
unaffected and agrees to within floating-point noise.

**GMM peak counts.** The Gaussian mixture model EM algorithm accumulates
floating-point arithmetic differently in R and MATLAB, causing slightly
different threshold values in some local windows. Peak counts differ by
10–20% across validated datasets, with the direction varying by dataset.

**Figures 9 and 10.** The threshold-sensitivity detail plot (Fig. 9) and
multi-site comparison plot (Fig. 10) from the MATLAB interface are not
implemented in this R package.

**Smoothed FRI column (col 23).** The R package computes smoothed
fire-return intervals in this column; MATLAB v2.0 stores NaN.

## Validation summary

| Dataset | Site | charBkg max\|diff\| | Peaks R | Peaks MATLAB |
|---------|------|-------------------|---------|-------------|
| CO | Code Lake, AK | ~5 × 10^-6^ | 39 | 48 |
| CH10 | Chickaree Lake, CO | 0.267 | 59 | 50 |
| SI17 | Silver Lake, CO | 0.130 | 25 | 31 |
| RA07 | Raven Lake, AK | < 0.001 | 15 | 17 |

Full validation details are in `inst/z_Validation_report_R_vs_MATLAB_V_2.0.md`.

## Citation

If you use *CharAnalysis* in published research, please cite:

> Higuera, P.E., L.B. Brubaker, P.M. Anderson, F.S. Hu, and T.A. Brown.
> 2009. Vegetation mediated the impacts of postglacial climate change on
> fire regimes in the south-central Brooks Range, Alaska. *Ecological
> Monographs* 79:201–219. <https://doi.org/10.1890/07-2019.1>

If you used Version 2.0 specifically, please also cite the software:

> Higuera, P.E. 2026. *CharAnalysis*: Diagnostic and analytical tools for
> peak analysis in sediment-charcoal records (Version 2.0). Zenodo.
> <https://doi.org/10.5281/zenodo.19304064>
