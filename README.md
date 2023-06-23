![](http://www.r-pkg.org/badges/version/QRAGadget)
![](http://cranlogs.r-pkg.org/badges/grand-total/QRAGadget)
![](http://cranlogs.r-pkg.org/badges/QRAGadget)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1145431.svg)](https://doi.org/10.5281/zenodo.1145431)

# QRAGadget
* Easily create Quantitative Risk Analysis (QRA) visualizations
* Choose from numerous color palettes, basemaps, and different configurations

# Overview
QRAGadget is a [Shiny Gadget](https://shiny.rstudio.com/articles/gadgets.html) for creating interactive QRA visualizations. QRAGadget is powered by the excellent [leaflet](https://leafletjs.com/) and [raster](https://cran.r-project.org/package=raster) packages. While this gadget was initially intended for those interested in creating QRA visualizations, it may also be more generally applicable to anyone interested in visualizing raster data in an interactive map. 

# Getting Started
To install QRAGadget in [R](https://www.r-project.org):

```
install.packages("QRAGadget")
```

Or to install the latest developmental version:

```
devtools::install_github('paulgovan/QRAGadget')
```

After installation, and if using [RStudio](https://posit.co/products/open-source/rstudio/) (v0.99.878 or later), the gadget will appear in the `Addins` dropdown menu. Otherwise, to launch the gadget, simply type:

```
QRAGadget::QRAGadget()
```

# Example

## Input/Output

QRAGadget currently accepts two primary types of raster data: (1) a file upload (in csv format) or (2) an R `data.frame` object. In order to explore the gadget, create some dummy data:

```
sample <- matrix(runif(36*36), ncol = 36, nrow = 36) %>%
  data.frame()
```

Then launch the app:

```
QRAGadget::QRAGadget()
```

Launching the app brings up the *Input/Output* page. To find the dummy data, click *R Object* under **Data Type**, and then select *sample* from the dropdown menu.

Choose a name for the output html file. After customizing the map, clicking *Done* will create a standalone html file in the current working directory (Be sure not to save over a previously created map file!). Click *Cancel* any time to start over. 

To bookmark the app at any time, click the *Bookmark* button, which will create a unique url for the current state of the app.

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/InputOutput.PNG?raw=true)

## Raster

To format the raster image, click the *Raster* icon. Here are a number of options for specifying the extents of the raster image (XMIN, XMAX, YMIN, and YMAX) as well as the [projection](https://rstudio.github.io/leaflet/raster.html) of the raster layer. It is very important that the raster layer be tagged with the correct project coordinate reference system. 

To specify the bins for the color palette, click *Number* to select the total number of bins or *Cuts* to select both the number and the actual cut values for each bin.

Finally, there is an option to disaggregate the raster layer and create a new one with a higher resolution (smaller cells) while also locally interpolating between the new cell values (smoothed cells). To disaggregate the raster layer, enter the number of cells to disaggregate.

For this example, use the default values for XMIN, XMAX, YMIN, and YMAX as well as the given projection, but enter 5 as the number of cells to disaggregate:

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/raster.PNG?raw=true)

## Map

To view the interactive map, click the *Map* icon. Click the *Reset* button at any time in order to reset the extents of the map.

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/map.PNG?raw=true)

## Preferences

The *Preferences* tab has a number of options for customizing the map:

* The title of the map
* The color palette (see [colorbrewer2.org](https://colorbrewer2.org))
* The basemap (see [http://leaflet-extras.github.io](https://leaflet-extras.github.io/leaflet-providers/preview/index.html))
* The control position
* The legend position

To try out some of these options, select the *PuOr* **Color Palette**, the *Esri.WorldImagery* **Map Tile**, and move the **Control Position** over to the *bottomleft*:

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/preferences.PNG?raw=true)

This should result in the following interactive map:

![](https://github.com/paulgovan/QRAGadget/blob/master/inst/images/Map2.PNG?raw=true)

