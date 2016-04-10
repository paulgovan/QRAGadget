library(shiny)
library(miniUI)
library(rstudioapi)
library(shinyIncubator)
library(leaflet)
library(R.matlab)
library(raster)
library(scales)
library(htmlwidgets)

# Modify labelFormat function to make scientific = TRUE the default
labelFormat2 <- function (prefix = "", suffix = "", between = " &ndash; ", digits = 3,
                          big.mark = ",", transform = identity)
{
  formatNum = function(x) {
    format(round(transform(x), digits), trim = TRUE, scientific = TRUE,
           big.mark = big.mark)
  }
  function(type, ...) {
    switch(type, numeric = (function(cuts) {
      paste0(prefix, formatNum(cuts), suffix)
    })(...), bin = (function(cuts) {
      n = length(cuts)
      paste0(prefix, formatNum(cuts[-n]), between, formatNum(cuts[-1]),
             suffix)
    })(...), quantile = (function(cuts, p) {
      n = length(cuts)
      p = paste0(round(p * 100), "%")
      cuts = paste0(formatNum(cuts[-n]), between, formatNum(cuts[-1]))
      paste0("<span title=\"", cuts, "\">", prefix, p[-n],
             between, p[-1], suffix, "</span>")
    })(...), factor = (function(cuts) {
      paste0(prefix, as.character(transform(cuts)), suffix)
    })(...))
  }
}

# Set initial bins
initBins = c(1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 0.0001) %>%
  matrix(ncol = 1) %>%
  data.frame()

# QRA Gadget function
QRAGadget <- function() {

  ui <- miniPage(
    gadgetTitleBar("QRA Gadget"),
    miniTabstripPanel(
      miniTabPanel("Search", icon = icon("search"),
                   miniContentPanel(
                     fileInput('file', strong('File Input:'),
                               accept = c(
                                 'text/csv',
                                 'text/comma-separated-values',
                                 'text/tab-separated-values',
                                 'text/plain',
                                 '.csv',
                                 '.tsv'
                               )
                     )
                   )
      ),
      miniTabPanel("Raster", icon = icon("picture-o"),
                   miniContentPanel(
                     numericInput("xmn", "XMIN:", value = -122.2116,
                                  width = "100%"),
                     hr(),
                     numericInput("xmx", "XMAX:", value = -122.1979,
                                  width = "100%"),
                     hr(),
                     numericInput("ymn", "YMIN:", value = 49.0719,
                                  width = "100%"),
                     hr(),
                     numericInput("ymx", "YMAX:", value = 49.0809,
                                  width = "100%"),
                     hr(),
                     selectizeInput("projection", "Projection:",
                                    choices = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
                                    options = list(create = TRUE), width = "100%"),
                     hr(),
                     radioButtons("radio", "Bins:", choices = c("Number"=1, "Cuts"=2)),
                     conditionalPanel("input.radio == 1",
                                      numericInput("nbins", label = NULL, value = 10,
                                                   width = "100%")
                     ),
                     conditionalPanel("input.radio == 2",
                                      matrixInput('bins', label = NULL, initBins)
                     )
                   )
      ),
      miniTabPanel("Map", icon = icon("globe"),
                   miniContentPanel(leafletOutput("map", height = "100%")
                   ),
                   miniButtonBlock(
                     actionButton("resetMap", "Reset")
                   )
      ),
      miniTabPanel("Preferences", icon = icon("cog"),
                   miniContentPanel(
                     textInput("title", "Map Title:", value = "Risk Frequency",
                               width = "100%"),
                     hr(),
                     selectizeInput("pal", "Color Palette:",
                                    choice = c("Spectral", "RdYlGn", "RdYlBu",
                                               "RdGy", "RdBu", "PuOr", "PRGn",
                                               "PiYG", "BrBg"),
                                    options = list(create = TRUE), width = "100%"),
                     tags$a(href="http://colorbrewer2.org/", "colorbrewer2.org"),
                     hr(),
                     selectizeInput("tile", "Map Tile:",
                                    choices = c("OpenStreetMap.Mapnik",
                                                "OpenTopoMap",
                                                "MapQuestOpen.OSM",
                                                "MapQuestOpen.Aerial",
                                                "Esri.WorldStreetMap",
                                                "Esri.WorldTopoMap",
                                                "Esri.NatGeoWorldMap",
                                                "Esri.WorldImagery",
                                                "CartoDB.Positron",
                                                "CartoDB.DarkMatter"),
                                    options = list(create = TRUE), width = "100%"),
                     tags$a(href="http://leaflet-extras.github.io/leaflet-providers/preview/index.html", "leaflet-extras.github.io"),
                     hr(),
                     selectizeInput("control", "Control Position:",
                                    choices = c("bottomright", "topright",
                                                "bottomleft", "topleft"),
                                    width = "100%"),
                     hr(),
                     selectizeInput("legend", "Legend Position:",
                                    choices = c("topright", "bottomright",
                                                "topleft", "bottomleft"),
                                    width = "100%"),
                     br()
                   )
      )
    )
  )

  server <- function(input, output, session) {

    # Get file upload and clean data
    data <- reactive({
      req(input$file)
      inFile <- input$file
      data <- read.csv(inFile$datapath)
      data[data == 0] <- NA
      as.matrix(data)
    })

    # Get values
    vals <- reactive({
      vals <- matrix(data(), ncol = 1, dimnames = NULL)
    })

    # Create a raster image
    r <- reactive({
      req(input$xmn, input$xmx, input$ymn, input$ymx, input$projection)
      r <- raster(nrows = nrow(data()), ncols = ncol(data()),
                  xmn = input$xmn, xmx = input$xmx, ymn = input$ymn, ymx = input$ymx)
      crs(r) <- sp::CRS(input$projection)
      r <- setValues(r, vals()) %>%
        flip(direction = 'y')
    })

    # Create a map object
    map <- reactive({
      req(input$nbins, input$bins, input$pal, input$tile)
      if (is.null(data()))
        return(NULL)

      # Set bins
      if (input$radio == 1) {
        n <- input$nbins - 2
        bins <- n
      } else {
        n <- nrow(input$bins) - 2
        bins <- c(input$bins)
      }

      # Set color palette
      col <- brewer_pal(palette = input$pal, direction = -1)(n)
      pal <- colorBin(col, values(r()), bins = bins,
                      na.color = "transparent")

      force(input$resetMap)

      leaflet() %>%
        addProviderTiles(input$tile, group = input$tile) %>%

        addRasterImage(r(), colors = pal, opacity = 0.5, group = input$title) %>%

        addLayersControl(
          baseGroups = c(input$tile),
          overlayGroups = input$title,
          position = input$control) %>%

        addLegend(pal = pal, position = input$legend, values = values(r()),
                  labFormat = labelFormat2(digits = 15), title = input$title)
    })

    # Plot a map
    output$map <- renderLeaflet({
      map()
    })

    observeEvent(input$done, {
      stopApp(saveWidget(map(), "map.html"))
    })
  }

  runGadget(shinyApp(ui, server), viewer = dialogViewer("QRA Gadget", height = 800))

}
