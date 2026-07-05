# Changelog

## QRAGadget 0.4

### Major Changes

- Replace deprecated `raster` and `sp` packages with `terra` for spatial
  operations.
- Replace `matrixInput()` / tableinput widget with `rhandsontable` for
  interactive matrix editing.
- Drop `magrittr` dependency; use the native R pipe (`|>`). Minimum R
  version is now 4.1.0.

### New Features

- Added a vignette demonstrating package usage.

### Minor Improvements and Bug Fixes

- Added a `testthat` test suite covering `labelFormat2()` and utility
  functions.
- Added `CODE_OF_CONDUCT.md` and `CONTRIBUTING.md` for ropensci
  compliance.
- Updated CI workflows: R-CMD-check (multi-platform), pkgcheck, and
  pkgdown.
- Updated CITATION and package documentation.

## QRAGadget 0.3.2

### Minor Improvements and Bug Fixes

- Update contact info
- Update citation

## QRAGadget 0.2.0

### Minor Improvements and Bug Fixes

- UI now uses current dependency to fontawesome.
