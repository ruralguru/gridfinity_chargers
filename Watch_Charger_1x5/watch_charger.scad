include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>
$fn = 100;
//==================================================
// Gridfinity User Input Dimensions
//==================================================
gridx = 1; // number of bases along x-axis
gridy = 5; // number of bases along y-axis  
gridz = 8.3; // bin height.
gridz_define =1; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
height_internal = 0; // overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
length = 42; // base unit
style_hole = 1; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
div_base_x = 0;// number of divisions per 1 unit of base along the X axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_y = 0;// number of divisions per 1 unit of base along the Y axis. (default 1, only use integers. 0 means automatically guess the right division)
enable_scoop = false;// internal fillet for easy part removal
enable_zsnap = false;// snap gridz height to nearest 7mm increment
enable_lip = false;// enable upper lip for stacking other bins
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]

difference(){
	color("blue") union(){
		gridfinityInit(gridx, gridy, height(gridz, gridz_define, enable_lip, enable_zsnap), height_internal, length) {
		cut(s = false);
		cut(y = 1, s = false);
		cut(y = 3, s = false);
		cut(x = 0.5, y = 4.5,w = 0.5, h = 0.5, s = false);
		}	
		gridfinityBase(gridx, gridy, length, div_base_x, div_base_y, style_hole);
	}
//	translate([0, 0, 6.5]) cylinder(h = 9.001	, d = 34);
//	translate([-2.5, 16, 7.5]) cube([5, 11, 8.001]);
//	translate([-1.5, 26.999, 8.5]) cube([3, 45.002, 7.001]);
//	translate([-21, 42 * 2, 8.5]) cube([7.501, 3, 7.001]);
	translate([-13.5, 72, 8.5]){
		intersection(){
			cube([15, 15, 7.001]);
			difference(){
				cylinder(h = 7.001, r = 15);
				cylinder(h = 7.001, r = 12);
			}
		}
	}
	translate([0, -19, 15.1]) rotate([90, 0, 0])  cylinder(h = 8, d = 15, center = true);
}