This is a collection of files which are intended to be used with:

https://github.com/seasick/openscad-web-gui

Each file will have various parameters for dimensions and features, and a variable for: 

    Generate_DXF_or_STL

which may be set to either STL (2) or DXF (1) --- when set to DXF, the command

    projection() 

will be invoked, creating a flattened version of the design suited for generating a DXF (or SVG) when that is selected in the Export button.
