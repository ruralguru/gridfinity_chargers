include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>
$fn = 100;

// Fits desktop charging stations. confirmed to work with: Baseus PowerCombo 65W (ASIN: B09HBJ1Z96) and  Rolvse GaN 65W (ASIN: B09JZG32SW)
// use # at beginning of module or line to provide debug visual, even of cutouts.
//==================================================
// Gridfinity User Input Dimensions
//==================================================
gridx = 1; // number of bases along x-axis
gridy = 3; // number of bases along y-axis  
gridz = 10; // bin height.
slot_height = 18.9; // internal slot height
gridz_define =1; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
height_internal = 14.3; // overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
length = 42; // base unit
style_hole = 1; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
div_base_x = 0;// number of divisions per 1 unit of base along the X axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_y = 0;// number of divisions per 1 unit of base along the Y axis. (default 1, only use integers. 0 means automatically guess the right division)
enable_scoop = false;// internal fillet for easy part removal
enable_zsnap = false;// snap gridz height to nearest 7mm increment
enable_lip = false;// enable upper lip for stacking other bins
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]

intersection(){
translate([0, 0, -5]) gridfinityInit(gridx, gridy, height(38, 2, enable_lip, enable_zsnap), 0, length); // volume trim
    difference(){
        union(){
            translate([0, 2.06, 19.8]) rotate([1, 0, 0]) gridfinityInit(gridx, gridy + 0.1, height(gridz, gridz_define, enable_lip, enable_zsnap), height_internal, length){ // power supply inset at backward slant
                cut(w = 1, h = 4, s = enable_scoop);// full
            }
            gridfinityInit(gridx, gridy, height(slot_height, gridz_define, enable_lip, enable_zsnap), 0, length); // Cable track lift
    		gridfinityBase(gridx, gridy, length, div_base_x, div_base_y, style_hole); 
        }
        translate([0, -length * gridy / 2, 35.6]) rotate([90, 0, 0])  cylinder(h = 7, d = 15, center = true); // AC Power slot
        translate([- length * 0.3, (length * gridy) / 2, 10.7]) rotate([90, 0, 0]) minkowski() { // parallel cable track
          cube([length * 0.6,19.5 - (2 * 4.2), (length * gridy)]);
          cylinder(r=4.2,h=0.01);
        }
        translate([-(length * gridx) / 2, -(length * (gridx + 1)) / 2, 10.7]) rotate([90, 0, 90]) minkowski() { // sideways cable track
          cube([length * 0.6,19.5 - (2 * 4.2), (length * gridx)]);
          cylinder(r=4.2,h=0.01);
        }
    }
}
