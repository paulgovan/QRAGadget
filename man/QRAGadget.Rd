\name{QRAGadget}
\alias{QRAGadget}
\title{QRA Gadget}
\usage{
QRAGadget()
}
\description{
Upload raster data and easily create interactive QRA visualizations. Select from numerous color palettes, basemaps, and different configurations.
}
\value{
A standalone html file
}
\examples{
sample <- matrix(runif(36*36), ncol = 36, nrow = 36) %>%
  data.frame()
QRAGadget()
}
