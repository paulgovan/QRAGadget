# QRAGadget
A Shiny Gadget for Interactive QRA Visualizations

![QRAGadget](https://github.com/paulgovan/QRAGadget/blob/master/images/map2.PNG?raw=true)

# Features
* Easily create Quantitative Risk Analysis (QRA) visualizations
* Choose from numerous color palettes, basemaps, and different configurations

# Overview
QRAGadget is a Shiny Gadget for creating interactive QRA visualizations. QRAGadget is powered by the excellent [leaflet](http://leafletjs.com/) and [raster](https://cran.r-project.org/web/packages/raster/vignettes/Raster.pdf) packages. While this gadget was initially intended for those interested in creating QRA visualizations, it may also be of use to anyone interested in visualizing raster data in a leaflet map. 

This project is in its *very* early stages. Please let us know if there are things you would like to see (or things you don't like!) by opening up an issue.

# Getting Started
You can install QRAGadget in [R](https://www.r-project.org) with:

```
devtools::install_github('paulgovan/QRAGadget')
```

After installation is complete, and if you are using [RStudio](https://www.rstudio.com/products/rstudio/) (v0.99.878 or later), QRAGadget will appear in the Addins dropdown menu. Otherwise, to launch the gadget, simply type:

```
QRAGadget()
```

# Example

## Data

QRAGadget currently accepts two primary types of raster data: (1) a file upload (in csv format) or (2) an R `data.frame` object. In order to explore the gadget, let's create some dummy data:

```
sample <- matrix(runif(36*36), ncol = 36, nrow = 36) %>%
  data.frame()
```

Then launch the app:

```
QRAGadget()
```

At this point, you should see the *Search* page. To find your dummy data, click *R Object* under **Data Type**, and then select *sample* from the dropdown menu.

![Search Page](https://github.com/paulgovan/QRAGadget/blob/master/images/Search.PNG?raw=true)

## Raster

To format your raster image, click the *Raster* icon. Here you will see options for specifying the extents of your raster image (XMIN, XMAX, YMIN, and YMAX) as well as the [projection](https://rstudio.github.io/leaflet/raster.html) of your raster layer. It is very important that your raster layer is tagged with the correct project coordinate reference system. Finally, you can specify the number of bins for your color palette.

![Raster Page](https://github.com/paulgovan/QRAGadget/blob/master/images/raster.PNG?raw=true)

## Map

To view your interactive QRA map, click the *Map* icon. If at any time you want to reset the extents of your map, simply click the *Reset* button.

![Map Page](https://github.com/paulgovan/QRAGadget/blob/master/images/map2.PNG?raw=true)

## Preferences

The *Preferences* tab has a number of options for customizing your map. 
