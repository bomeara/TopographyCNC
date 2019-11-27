library(rayshader)
library(raster)
library(sp)
library(leaflet)
library(RCurl)


# Get utility functions from Will Bishop


URLs <- c(
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/elevation-api.R",
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/find-image-coordinates.R",
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/image-size.R",
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/map-image-api.R",
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/rayshader-gif.R",
  "https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/read-elevation.R"
)

for (i in seq_along(URLs)) {
  script <- getURL(URLs[i], ssl.verifypeer = FALSE)
  eval(parse(text = script))
}


SelectArea <- function() {
    utils::browseURL("https://boundingbox.klokantech.com/")
}

GetBBox <- function(lowerleft_lon=-122.522, lowerleft_lat=37.707, upperright_lon=-122.354, upperright_lat=37.84) {
  bbox <- list(
    p1 = list(long = lowerleft_lon, lat = lowerleft_lat),
    p2 = list(long = upperright_lon, lat = upperright_lat)
  )
  return(bbox)
}

PreviewArea <- function(bbox=GetBBox()) {

# Function from Will Bishop at https://wcmbishop.github.io/rayshader-demo/#introduction
# define bounding box with longitude/latitude coordinates


  leaflet() %>%
    addTiles() %>%
    addRectangles(
      lng1 = bbox$p1$long, lat1 = bbox$p1$lat,
      lng2 = bbox$p2$long, lat2 = bbox$p2$lat,
      fillColor = "transparent"
    ) %>%
    fitBounds(
      lng1 = bbox$p1$long, lat1 = bbox$p1$lat,
      lng2 = bbox$p2$long, lat2 = bbox$p2$lat,
    )
}

GetArea <- function(bbox=GetBBox(), major_dim=500) {
  elev_file <- file.path(tempdir(), "elevation.tif")
  image_size <- define_image_size(bbox, major_dim = major_dim)
  get_usgs_elevation_data(bbox, size = image_size$size, file = elev_file,
                        sr_bbox = 4326, sr_image = 4326)
  elev_img <- raster::raster(elev_file)
  elev_matrix <- matrix(
    raster::extract(elev_img, raster::extent(elev_img), buffer = 1000),
    nrow = ncol(elev_img), ncol = nrow(elev_img)
  )
  return(elev_matrix)
}

SaveArea <- function(elev_matrix=GetArea(), stl_file="cnc.stl", zscale=50, unit="in", maxwidth=4) {
  elev_matrix %>%
    sphere_shade() %>%
    plot_3d(elev_matrix,zscale=zscale)
  save_3dprint(stl_file, maxwidth = maxwidth, unit = unit)
}
