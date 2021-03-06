# RF-GDS
RF-GDS is a MATLAB library to enable RF analog integrated-circuit designers to convert and manipulate GDS structures and then export them to Cadence layout without DRC errors. I needed a tool during my PhD to move designs from HFSS to Cadence layout without drawing the designs manually again in Cadence. Refere to the [RF-GDS.pdf file](https://github.com/zainkhalifa/RF-GDS/blob/master/RF-GDS.pdf) for a quick overview. Although, I made this library for this specific application, I have created many general functions for GDS files that you might find useful. 

Note: This library depends on the work of Ulf Griesmann in his [gdsii-toolbox](https://github.com/ulfgri/gdsii-toolbox). This repository includes his source code together with any copyright notice therein. 

Disclaimer: The library is not professionally written. I wrote it along the way as I needed. So always be aware if I missed anything in my descriptions. Make sure that it is doing what you intend and don't count on me taking care of everything for you !

## How to use
Clone or download the library.
### On Windows MATLAB, 
1. Install mex compiler by running the file `mingw.mlpkginstall` [here](https://github.com/zainkhalifa/RF-GDS/blob/master/GDS_Lib/mingw.mlpkginstall) or google it for other methods if you dont have that file.
2. Set path in Matlab to `include all subfolders` in your location of the library. You can do that from `HOME --> Set Path`.
3. Compile the library by running `makemex.m` [here](https://github.com/zainkhalifa/RF-GDS/blob/master/GDS_Lib/gdsii-toolbox-master/makemex.m). You need to do this only once. 

### On Linux MATLAB,

Set path in Matlab to `include all subfolders` in your location of the library. You can do that from `HOME --> Set Path`.

## What you can do with this library
General use:
* Import GDS files from HFSS, Cadence or create your own GDS elements/structures 
* Perform operations such as Merge, Split, Mosaic, find intersections, Math operations (and, or, diff)...etc ([List of functions](https://github.com/zainkhalifa/RF-GDS/blob/master/GDS_Lib/GDS_Functions/Contents.m)).
* plot and visualize the designs in Matlab before exporting. 
* Assign layer and datatype numbers to your elements - layer mapping. 
* Rename your structures and gds libraries or change properties. 
* Export GDS files.
* Check also [gdsii-toolbox](https://github.com/ulfgri/gdsii-toolbox). 

Specific use:
* Discretize a structure so that all vertices fit in the minimum assigned grid (minGrid) as specified in the PDK. 
* Make all transitions with horizontal and vertical angles comply with the DRC of your technology. 
* Fix/Distort your structures for minimum width and minimum spacing as needed. This works for RF passives since minor chanages won't affect the EM performance of the design if the distortion is much smaller than your minimum wavelength. 
* Generate vias between metal structures. 
* Fill empty spaces in your design by any basic grid block you want so that it can pass density requirements in DRC. Otherwise, leave it open for auto generated fillings in Cadence later on. 

## Examples
I included my latest project [codes](https://github.com/zainkhalifa/RF-GDS/tree/master/Procedure%20Codes) as a demo. I cannot include full details nor `GDS` files. However, you can see the procedure flow and corrosponding images in [RF-GDS.pdf](https://github.com/zainkhalifa/RF-GDS/blob/master/RF-GDS.pdf) file. 

## List of functions
[List of functions](https://github.com/zainkhalifa/RF-GDS/blob/master/GDS_Lib/GDS_Functions/Contents.m).

## Notes
* Some of my functions can lose the identifier values for `layer number` and `datatype` number. It is a good practice to call `GDS_reset` to remap before exporting.
* Most functions deal with *boundry* data type only rather than *path*, *text* or others. 
* Some of my functions do not deal with elements that have more than one *boundry*. 
* Call `help` for details about the functions. Check out my codes for how to use them. 
* I kept the [Graveyard](https://github.com/zainkhalifa/RF-GDS/blob/master/GDS_Lib/GDS_Functions/The%20Graveyard.zip) which contains my previous and failed codes. It can help if you want to develop new codes. 
* I did not optimise the codes for the fastest simulation time but I prioritize usability since I dont have very complicated desings. 
