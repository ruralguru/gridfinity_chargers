include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>
include <honeycomb_wall.scad>
//==================================================
// Gridfinity User Input Dimensions
//==================================================
gridx = 2; // number of bases along x-axis
gridy = 3; // number of bases along y-axis
style_hole = 2; // [0:none, 1:mag only, 2: mag / screw, no slit, 3: mag / screw, slit]
//==================================================
// Honeycomb User Dimensions
//==================================================
honeycomb_numx = 3; // X axis hexagon count, 23.6 mm OD
honeycomb_numy = 7; // Y axis hexagon count, 27.25 mm OD
//==================================================
// User Dimensions
//==================================================
phone_thickness = 0.75 * 25.4; //dimension of phone in mm
usb_x = 0.875 * 24.5;
usb_z = 0.4 * 24.5;
wireless_enabled = true;
wireless_diameter = 50; //ASIN B09FLCMGV9
// center from base 56 mm.
// note 10+ center in case, had to average quadlock hole (66.25 + 98.25) / 2 = 82.25
wireless_y_offset = 26.25;

//==================================================
//==================================================
// Gridfinity Set Dimensions
//==================================================
length = 42; // base unit length / width
div_base_x = 1; // div# per unit base, X axis. (INT only, default = 1, auto = 0)
div_base_y = 1; // div# per unit base, Y axis. (INT only, default = 1, auto = 0)
//==================================================
// Honeycomb Set Dimensions
//==================================================
honeycomb_thickness = 8;
honeycomb_wall = 1.8; //[:0.01]
honeycomb_wall_diameter = honeycomb_wall / cos(30);
honeycomb_height_ID = 20; // Wall to wall ID of honeycomb.
honeycomb_height_OD = honeycomb_height_ID + (2 * honeycomb_wall); // Wall to wall OD of honeycomb.
honeycomb_diameter_ID = honeycomb_height_ID / cos(30);
honeycomb_diameter_OD = honeycomb_height_OD / cos(30);
honeycomb_frame_x_OD = (honeycomb_numx + 0.5) * honeycomb_height_OD;
honeycomb_frame_y_OD = (ceil(honeycomb_numy/2)* honeycomb_diameter_OD) + (floor(honeycomb_numy/2)* (honeycomb_diameter_OD / 2));
honeycomb_frame_x_ID = honeycomb_frame_x_OD - (2 * honeycomb_wall);
honeycomb_frame_y_ID = honeycomb_frame_y_OD - (honeycomb_wall_diameter);
//==================================================
// Set Dimensions
//==================================================
filler_thickness = honeycomb_thickness + phone_thickness;
honeycomb_x_offset = 3 * honeycomb_diameter_OD / 8;
honeycomb_y_offset = -honeycomb_height_OD / 4;
wireless_thickness = 6; //adding for thickness

module honeycomb_depth(height, OD, ID)
difference(){
	cylinder(h = height, d = OD, $fn = 6);
	translate([0, 0, -0.01]) cylinder(h = height + 0.02, d = ID, $fn = 6);
}
	

difference(){
	union(){
		rotate([75, 0, 90]) translate([0, honeycomb_frame_y_OD/2 , 5]) 
		difference(){
			union(){
				intersection(){
					translate([0, 0, filler_thickness/2 + 0.5]) cube([honeycomb_frame_x_OD, honeycomb_frame_y_OD, filler_thickness + 1], center= true);
					union(){
                        if(wireless_enabled) difference(){
                            honeycomb_wall_baseplate(honeycomb_numx+1, honeycomb_numy+1, honeycomb_wall, honeycomb_height_ID);
                            translate([0, wireless_y_offset, -0.01]) cylinder(h = wireless_thickness + 0.01, d = wireless_diameter + 0.2);
                        }else{
                            honeycomb_wall_baseplate(honeycomb_numx+1, honeycomb_numy+1, honeycomb_wall, honeycomb_height_ID);
                        }                            
						translate([0, 0, honeycomb_thickness/2]) 
                        difference(){
							cube([honeycomb_frame_x_OD, honeycomb_frame_y_OD, honeycomb_thickness], center= true);
							cube([honeycomb_frame_x_ID, honeycomb_frame_y_ID, honeycomb_thickness + 0.2], center = true);
						}
						rotate([0, 0, 90])translate([honeycomb_x_offset - 3 * honeycomb_diameter_OD, honeycomb_y_offset, 0]) honeycomb_depth(filler_thickness + 1, honeycomb_diameter_OD, honeycomb_diameter_ID); // hex 3
						rotate([0, 0, 90])translate([honeycomb_x_offset - 3 * honeycomb_diameter_OD, honeycomb_y_offset + honeycomb_height_OD, 0]) honeycomb_depth(filler_thickness + 1, honeycomb_diameter_OD, honeycomb_diameter_ID); // hex 2
						rotate([0, 0, 90])translate([honeycomb_x_offset - 3 * honeycomb_diameter_OD, honeycomb_y_offset + (2 * honeycomb_height_OD), 0]) honeycomb_depth(filler_thickness + 1, honeycomb_diameter_OD, honeycomb_diameter_ID); // hex 1
						rotate([0, 0, 90])translate([honeycomb_x_offset - 3 * honeycomb_diameter_OD, honeycomb_y_offset- honeycomb_height_OD, 0]) honeycomb_depth(filler_thickness + 1, honeycomb_diameter_OD, honeycomb_diameter_ID); // hex 4 
						translate([-honeycomb_frame_x_OD / 2, honeycomb_y_offset / 2 - (3 * honeycomb_diameter_OD) - honeycomb_wall, 0]) cube([honeycomb_wall, honeycomb_diameter_OD, filler_thickness + 1]);
					} // leg 1 full
				}
				translate([0, 0, filler_thickness]) intersection(){
					translate([0, -(honeycomb_frame_y_OD -honeycomb_diameter_OD) / 2, honeycomb_thickness/2]) cube([honeycomb_frame_x_OD, honeycomb_diameter_OD, honeycomb_thickness], center= true); // front outline
					union(){
						translate([0, 0, 0]) honeycomb_wall_baseplate(honeycomb_numx+1, honeycomb_numy+1, honeycomb_wall, honeycomb_height_ID); // front honeycomb
						translate([-honeycomb_frame_x_OD / 2, honeycomb_y_offset / 2 - (2.6 * honeycomb_diameter_OD) - honeycomb_wall, 0]) cube([honeycomb_wall, honeycomb_diameter_OD, honeycomb_thickness]); // trim left front
						translate([honeycomb_frame_x_OD / 2 - honeycomb_wall, honeycomb_y_offset / 2 - (2.19 * honeycomb_diameter_OD) - honeycomb_wall, 0]) cube([honeycomb_wall, honeycomb_diameter_OD, honeycomb_thickness]); // right trim front
						translate([-honeycomb_frame_x_OD / 2, honeycomb_y_offset / 2 - (1.6415 * honeycomb_diameter_OD) - honeycomb_wall, 0]) cube([honeycomb_frame_x_OD, honeycomb_wall, honeycomb_thickness]); //front frame top
					}
				}
				translate([ -honeycomb_frame_x_OD / 2, -(honeycomb_frame_y_OD / 2 + honeycomb_thickness), 0]) cube([honeycomb_frame_x_OD, honeycomb_thickness, honeycomb_thickness]); // back attachment bar
                translate([ -honeycomb_frame_x_OD / 2, -(honeycomb_frame_y_OD / 2 + 14.5), honeycomb_thickness]) cube([honeycomb_wall, 25, filler_thickness]); // leg 1
				translate([ honeycomb_y_offset - honeycomb_wall - honeycomb_height_OD, -(honeycomb_frame_y_OD / 2 + 14.5), honeycomb_thickness]) cube([2 * honeycomb_wall, 25, filler_thickness]); // leg 2
				 translate([ honeycomb_y_offset - honeycomb_wall + honeycomb_height_OD, -(honeycomb_frame_y_OD / 2 + 14.5), honeycomb_thickness]) cube([2 * honeycomb_wall, 25, filler_thickness]); // leg 3
				translate([ honeycomb_frame_x_OD / 2 - honeycomb_wall, -(honeycomb_frame_y_OD / 2 + 14.5), honeycomb_thickness]) cube([honeycomb_wall, 25, filler_thickness]); // leg 4
			}
			// cutouts here
			translate([-0.5 * 25.4, -honeycomb_frame_y_OD / 2 - 0.01, honeycomb_thickness + 0.01]) cube([0.75 * 25.4, honeycomb_diameter_OD + 0.02, filler_thickness + 0.01]); //cable phone cutout
			translate([-honeycomb_frame_x_OD / 2 - 0.5, -honeycomb_frame_y_OD / 2 - 2 * honeycomb_thickness - 0.5, -7]) rotate([15, 0, 0]) cube([honeycomb_frame_x_OD + 1, 2 * honeycomb_thickness, filler_thickness +2 * honeycomb_thickness]); // Trim bottom on angle
			translate([-honeycomb_height_OD * 1.75 - 0.01, -66, honeycomb_thickness + phone_thickness / 2]) rotate([0, 90, 0]) cylinder(h = honeycomb_height_OD * 3, d = 9, $fn = 100); // In use cable cutout top
			translate([-honeycomb_height_OD * 1.75 - 0.01, -75, honeycomb_thickness + phone_thickness / 2 - 4.5]) cube([honeycomb_height_OD * 3, 9, 9]); //in use cable cutout.
		}
		translate([0, 0, -7]) gridfinityBase(gridx, gridy, length, div_base_x, div_base_y, style_hole); //base
	}
	translate([15, -honeycomb_frame_x_OD / 2 - 0.01, -0.5]) union(){
		cube([usb_x -( usb_z / 2), honeycomb_frame_x_OD + 0.02, usb_z]); // center passthrough
		translate([usb_x- (usb_z / 2), 0, usb_z / 2]) rotate([-90, 0, 0]) cylinder(h = honeycomb_frame_x_OD + 0.02, d = usb_z, $fn = 100); // front cylinder
		translate([0, 0, usb_z / 2]) rotate([-90, 0, 0]) cylinder(h = honeycomb_frame_x_OD + 0.02, d = usb_z, $fn = 100); // back cylinder
		//translate([0, 0, usb_z / 2]) sphere(d = usb_z, $fn = 100); // rounding for end
	}
}