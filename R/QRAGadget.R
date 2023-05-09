# Modify labelFormat function to make scientific = TRUE the default
labelFormat2 <-
  function (prefix = "",
            suffix = "",
            between = " &ndash; ",
            digits = 3,
            big.mark = ",",
            transform = identity)
  {
    formatNum = function(x) {
      format(
        round(transform(x), digits),
        trim = TRUE,
        scientific = TRUE,
        big.mark = big.mark
      )
    }
    function(type, ...) {
      switch(
        type,
        numeric = (function(cuts) {
          paste0(prefix, formatNum(cuts), suffix)
        })(...),
        bin = (function(cuts) {
          n = length(cuts)
          paste0(prefix,
                 formatNum(cuts[-n]),
                 between,
                 formatNum(cuts[-1]),
                 suffix)
        })(...),
        quantile = (function(cuts, p) {
          n = length(cuts)
          p = paste0(round(p * 100), "%")
          cuts = paste0(formatNum(cuts[-n]), between, formatNum(cuts[-1]))
          paste0("<span title=\"",
                 cuts,
                 "\">",
                 prefix,
                 p[-n],
                 between,
                 p[-1],
                 suffix,
                 "</span>")
        })(...),
        factor = (function(cuts) {
          paste0(prefix, as.character(transform(cuts)), suffix)
        })(...)
      )
    }
  }

# Create some sample data
sample <- matrix(runif(36 * 36), ncol = 36, nrow = 36) %>%
  data.frame()

# Set initial bins
initBins = c(1e-16,
             1e-15,
             1e-14,
             1e-13,
             1e-12,
             1e-11,
             1e-10,
             1e-9,
             1e-8,
             1e-7,
             1e-6,
             1e-5,
             0.0001) %>%
  matrix(ncol = 1) %>%
  data.frame()

#' A 'Shiny' Gadget for Interactive QRA Visualizations.
#'
#' Upload raster data and easily create interactive QRA visualizations. Select
#' from numerous color palettes, basemaps, and different configurations.
#' @importFrom htmlwidgets saveWidget
#' @importFrom leaflet leaflet leafletOutput renderLeaflet colorBin addLegend addLayersControl addRasterImage addProviderTiles "%>%"
#' @importFrom magrittr "%>%"
#' @import miniUI
#' @importFrom raster raster crs setValues flip disaggregate values
#' @importFrom scales brewer_pal
#' @import shiny
#' @importFrom shinyWidgets radioGroupButtons
#' @importFrom sp CRS
#' @return A standalone html file
#' @export
#' @examples
#' if (interactive()) {
#'   QRAGadget()
#' }
#'
QRAGadget <- function() {
  # Get all of the objects in the global environment
  objects <- ls(pos = 1)

  if (length(objects) == 0)
    stop("No objects found. Please create a data.frame to continue",
         call. = FALSE)
  # determine which are data frames
  dataChoices <-
    objects[sapply(objects, function(x)
      is.data.frame(get(x)))]

  ui <- miniPage(
    gadgetTitleBar("QRA Gadget"),
    miniTabstripPanel(
      miniTabPanel(
        "Input/Output",
        icon = icon("search"),
        miniContentPanel(
          shinyWidgets::radioGroupButtons(
            "radioData",
            "Input Type:",
            choices = c("File Upload" = 1, "Data Frame" = 2),
            selected = 2
          ),
          hr(),
          conditionalPanel("input.radioData == 1",
                           fileInput(
                             'file',
                             strong('File Upload:'),
                             accept = c(
                               'text/csv',
                               'text/comma-separated-values',
                               'text/tab-separated-values',
                               'text/plain',
                               '.csv',
                               '.tsv'
                             )
                           )),
          conditionalPanel(
            "input.radioData == 2",
            selectInput("data", "Data Frame:",
                        choices = dataChoices)
          ),
          hr(),
          helpText(
            "A standalone html file will be saved in your working directory with the file name below."
          ),
          textInput("fileName", "File Name:", value = "myMap"),
          hr(),
          bookmarkButton()
        )
      ),
      miniTabPanel(
        "Raster",
        icon = icon("image"),
        miniContentPanel(
          numericInput("xmn", "XMIN:", value = -122.2116),
          hr(),
          numericInput("xmx", "XMAX:", value = -122.1979),
          hr(),
          numericInput("ymn", "YMIN:", value = 49.0719),
          hr(),
          numericInput("ymx", "YMAX:", value = 49.0809),
          hr(),
          selectizeInput(
            "projection",
            "Projection:",
            choices = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
            options = list(create = TRUE)
          ),
          hr(),
          shinyWidgets::radioGroupButtons("radio", "Bins:",
                                          choices = c("Number" = 1, "Cuts" = 2),
                                          selected = 1
          ),
          br(),
          conditionalPanel(
            "input.radio == 1",
            numericInput("nbins", label = NULL, value = 10)
          ),
          conditionalPanel("input.radio == 2",
                           matrixInput('bins', label = NULL, initBins)),
          hr(),
          numericInput("dis", "Number of cells to disaggregate (Smooth):",
                       1, min = 1),
          br()
        )
      ),
      miniTabPanel(
        "Map",
        icon = icon("globe"),
        miniContentPanel(leaflet::leafletOutput("map")),
        miniButtonBlock(actionButton("resetMap", "Reset"))
      ),
      miniTabPanel(
        "Preferences",
        icon = icon("cog"),
        miniContentPanel(
          textInput("title", "Map Title:", value = "Risk Frequency"),
          hr(),
          selectizeInput(
            "pal",
            "Color Palette:",
            choice = c(
              "Spectral",
              "RdYlGn",
              "RdYlBu",
              "RdGy",
              "RdBu",
              "PuOr",
              "PRGn",
              "PiYG",
              "BrBg"
            ),
            options = list(create = TRUE)
          ),
          tags$a(href = "http://colorbrewer2.org/", "colorbrewer2.org"),
          hr(),
          selectizeInput(
            "tile",
            "Map Tile:",
            choices = c(
              "OpenStreetMap.Mapnik",
              "OpenTopoMap",
              "MapQuestOpen.OSM",
              "MapQuestOpen.Aerial",
              "Esri.WorldStreetMap",
              "Esri.WorldTopoMap",
              "Esri.NatGeoWorldMap",
              "Esri.WorldImagery",
              "CartoDB.Positron",
              "CartoDB.DarkMatter"
            ),
            options = list(create = TRUE)
          ),
          tags$a(href = "http://leaflet-extras.github.io/leaflet-providers/preview/index.html", "leaflet-extras.github.io"),
          hr(),
          selectizeInput(
            "control",
            "Control Position:",
            choices = c("bottomright", "topright",
                        "bottomleft", "topleft")
          ),
          hr(),
          selectizeInput(
            "legend",
            "Legend Position:",
            choices = c("topright", "bottomright",
                        "topleft", "bottomleft")
          ),
          br()
        )
      )
    )
  )

  server <- function(input, output, session) {
    # Get file upload and clean data
    data <- reactive({
      if (input$radioData == 1) {
        req(input$file)
        inFile <- input$file
        data <- utils::read.csv(inFile$datapath)
      } else {
        req(input$radioData)
        data <- get(input$data)
      }
      data[data == 0] <- NA
      as.matrix(data)
    })

    # Get values
    vals <- reactive({
      vals <- matrix(data(), ncol = 1, dimnames = NULL)
    })

    # Create a raster image
    r <- reactive({
      req(input$xmn,
          input$xmx,
          input$ymn,
          input$ymx,
          input$projection)
      r <- raster::raster(
          nrows = nrow(data()),
          ncols = ncol(data()),
          xmn = input$xmn,
          xmx = input$xmx,
          ymn = input$ymn,
          ymx = input$ymx
        )
      raster::crs(r) <- sp::CRS(input$projection)
      r <- raster::setValues(r, vals()) %>%
        raster::flip(direction = 'y') %>%
        raster::disaggregate(input$dis, "bilinear")
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
      col <- scales::brewer_pal(palette = input$pal, direction = -1)(n)
      pal <- leaflet::colorBin(col,
                          raster::values(r()),
                          bins = bins,
                          na.color = "transparent")

      force(input$resetMap)

      leaflet::leaflet() %>%
        leaflet::addProviderTiles(input$tile, group = input$tile) %>%

        leaflet::addRasterImage(
          r(),
          colors = pal,
          opacity = 0.5,
          group = input$title
        ) %>%

        leaflet::addLayersControl(
          baseGroups = c(input$tile),
          overlayGroups = input$title,
          position = input$control
        ) %>%

        leaflet::addLegend(
          pal = pal,
          position = input$legend,
          values = raster::values(r()),
          labFormat = labelFormat2(digits = 15),
          title = input$title
        )
    })

    # Plot a map
    output$map <- leaflet::renderLeaflet({
      map()
    })

    observeEvent(input$done, {
      fileName <- paste0(input$fileName, ".html")
      stopApp(htmlwidgets::saveWidget(map(), fileName))
    })
  }

  enableBookmarking(store = "url")
  runGadget(shinyApp(ui, server), viewer = dialogViewer("QRA Gadget"))

}
