
<!-- README.md is generated from README.Rmd. Please edit that file -->

# QRAGadget

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/QRAGadget)](https://CRAN.R-project.org/package=QRAGadget)
[![R-CMD-check](https://github.com/paulgovan/QRAGadget/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paulgovan/QRAGadget/actions/workflows/R-CMD-check.yaml)
[![](http://cranlogs.r-pkg.org/badges/grand-total/QRAGadget)](https://cran.r-project.org/package=QRAGadget)
[![](http://cranlogs.r-pkg.org/badges/last-month/QRAGadget)](https://cran.r-project.org/package=QRAGadget)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1145431.svg)](https://doi.org/10.5281/zenodo.1145431)

<!-- badges: end -->

# Features

- Easily create Quantitative Risk Analysis (QRA) visualizations
- Choose from numerous color palettes, basemaps, and different
  configurations

# Overview

QRAGadget is a [Shiny
Gadget](https://shiny.rstudio.com/articles/gadgets.html) for creating
interactive QRA visualizations. QRAGadget is powered by the excellent
[leaflet](https://leafletjs.com/) and
[raster](https://cran.r-project.org/package=raster) packages. While this
gadget was initially intended for those interested in creating QRA
visualizations, it may also be more generally applicable to anyone
interested in visualizing raster data in an interactive map.

# Installation

To install QRAGadget in [R](https://www.r-project.org):

``` r
install.packages("QRAGadget")
```

Or to install the latest development version:

``` r
devtools::install_github('paulgovan/QRAGadget')
```

After installation, and if using
[RStudio](https://posit.co/products/open-source/rstudio/) (v0.99.878 or
later), the gadget will appear in the Addins dropdown menu. Otherwise,
to launch the gadget, simply type:

``` r
QRAGadget::QRAGadget()
```

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/map.PNG?raw=true)

## Code of Conduct

Please note that the QRAGadget project is released with a [Contributor
Code of
Conduct](http://paulgovan.github.io/QRAGadget/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
