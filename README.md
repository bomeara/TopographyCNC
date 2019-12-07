# TopographyCNC

Some simple scripts to make CNC ready files (mostly for gifts). It's basically a thin wrapper on top of Will Bishop's tutorial: https://wcmbishop.github.io/rayshader-demo/#introduction.

To use:

`source("functions.R")`

To pick an area, you need to get the latitude and longitude of the bounding box (the rectangle surrounding the area to plot). `SelectArea()` will open a website for this; you can get the CSV formatted coordinates. Once you have those, convert to a bounding box: `bbox <- GetBBox(comma separated list of coordinates)`.

You can preview them with `PreviewArea(bbox)`.

To save the STL in the local directory: `SaveArea(GetArea(bbox))`. If you want to make higher relative elevation, play with zscale; its default is 50, and lower numbers mean more relief. `SaveArea(GetArea(bbox), zscale=10)` for example

For example, for Oak Ridge

```
bbox <- GetBBox(-84.277817,35.977303,-84.116009,36.075146)
PreviewArea(bbox)
SaveArea(GetArea(bbox), stl_file="or.stl", zscale=20)
```

You may want to use slicer to convert the stl file to svg
