# QRAGadget
A Shiny Gadget for Interactive QRA Visualizations

# Features
* Easily create Quantitative Risk Analysis (QRA) visualizations
* Choose from numerous color palettes, basemaps, and different configurations

# Overview
QRAGadget is a [Shiny Gadget](http://shiny.rstudio.com/articles/gadgets.html) for creating interactive QRA visualizations. QRAGadget is powered by the excellent [leaflet](http://leafletjs.com/) and [raster](https://cran.r-project.org/web/packages/raster/vignettes/Raster.pdf) packages. While this gadget was initially intended for those interested in creating QRA visualizations, it may also be more generally applicable to anyone interested in visualizing raster data in an interactive map. 

# Getting Started
To install QRAGadget in [R](https://www.r-project.org):

```
devtools::install_github('paulgovan/QRAGadget')
```

After installation, and if using [RStudio](https://www.rstudio.com/products/rstudio/) (v0.99.878 or later), the gadget will appear in the *Addins* dropdown menu. Otherwise, to launch the gadget, simply type:

```
QRAGadget()
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
QRAGadget()
```

Launching the app brings up the *Input/Output* page. To find the dummy data, click *R Object* under **Data Type**, and then select *sample* from the dropdown menu.

Choose a name for the output html file. After customizing the map, click *Done* to create a standalone html file in the working directory. Click *Cancel* any time to start over. 

![Search Page](https://github.com/paulgovan/QRAGadget/blob/master/images/Search%20Page.png?raw=true)

## Raster

To format the raster image, click the *Raster* icon. Here are a number of options for specifying the extents of the raster image (XMIN, XMAX, YMIN, and YMAX) as well as the [projection](https://rstudio.github.io/leaflet/raster.html) of the raster layer. It is very important that the raster layer is tagged with the correct project coordinate reference system. Finally, specify the number of bins for the color palette, and/or the cut values for each bin.

For this example, use the default values for XMIN, XMAX, YMIN, and YMAX as well as the given projection:

![Raster Page](https://github.com/paulgovan/QRAGadget/blob/master/images/raster.PNG?raw=true)

## Map

To view your interactive map, click the *Map* icon. If at any time you want to reset the extents of your map, simply click the *Reset* button.

![Map Page](https://github.com/paulgovan/QRAGadget/blob/master/images/map2.PNG?raw=true)

## Preferences

The *Preferences* tab has a number of options for customizing your map:

* The title of the map
* The color palette (see [colorbrewer2.org](colorbrewer2.org))
* The basemap (see [http://leaflet-extras.github.io](http://leaflet-extras.github.io/leaflet-providers/preview/index.html))
* The control position
* The legend position

![Preferences Page](https://github.com/paulgovan/QRAGadget/blob/master/images/preferences.PNG?raw=true)

# Source Code
QRAGadget is an [open source](http://opensource.org) project, and the source code is available at [https://github.com/paulgovan/QRAGadget](https://github.com/paulgovan/QRAGadget)

# Issues
This project is in its *very* early stages. Please let us know if there are things you would like to see (or things you don't like!) by opening up an issue using the GitHub issue tracker at [https://github.com/paulgovan/QRAGadget/issues](https://github.com/paulgovan/QRAGadget/issues)

# Contributions
Contributions are welcome by sending a [pull request](https://github.com/paulgovan/QRAGadget/pulls)

# License
QRAGadget is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2016)
