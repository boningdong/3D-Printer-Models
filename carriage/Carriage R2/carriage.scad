//Used JC Doll's belt clip design and incorporated it to this carriage.


include <configuration.scad>;

//belt clip module

// Belt parameters
belt_width = 6;                    // width of the belt, typically 6 (mm)
belt_thickness = 1.0 - 0.06;       // slightly less than actual belt thickness for compression fit (mm)           
belt_pitch = 2.0;                  // tooth pitch on the belt, 2 for GT2 (mm)
tooth_radius = 0.8;                // belt tooth radius, 0.8 for GT2 (mm)
belt_offset = 1;
// Overall clamp dimensions
clamp_width = 11.5;
clamp_length = 21;
clamp_base = 1;
clamp_body = 1.5;
path_height = belt_width + 1;
clamp_thickness = path_height+clamp_base;
groove=0.8;

$fn = 40;

//clamp_outside_radius = 10; //default
clamp_outside_radius = 10;
    clamp_inside_radius=clamp_outside_radius-belt_thickness;

dTheta_inside = belt_pitch/clamp_inside_radius;
dTheta_outside = belt_pitch/clamp_outside_radius;
pi = 3.14159;

small = 0.01;  // avoid graphical artifacts with coincident faces

module tube(r1, r2, h) {
  difference() {
    cylinder(h=h,r=r2);
    cylinder(h=h,r=r1);
  }
}

module belt_cutout(clamp_radius, dTheta) {
  // Belt paths
  tube(r1=clamp_inside_radius,r2=clamp_outside_radius,h=path_height+small);
  for (theta = [-pi/2:dTheta:pi*2-pi/2]) {
    translate([clamp_radius*cos(theta*180/pi),clamp_radius*sin(theta*180/pi),0]) cylinder(r=tooth_radius, h=path_height+small);
  }

}
module clips1() {
//    difference() {
//                cube([clamp_width,clamp_length,clamp_thickness]);
        for(y=[0:belt_pitch:clamp_length]) {
            translate([0,y,clamp_base])
            cylinder(r=tooth_radius, h=path_height+small);
        }
        translate([0,0,clamp_base])
        cube([belt_thickness,clamp_length,path_height+small]);
//    }
}

module belt_clips() {

  difference() {
        translate([0,0,0]) 
        cube([clamp_width,clamp_length,clamp_thickness]);


//	translate([12,-4,5]) rotate([15,-59,-11])
//	cube([10,16,10]);
  translate([0,0,clamp_base]) 
//      clips1();
      belt_cutout(clamp_inside_radius, dTheta_inside);
    translate([0,clamp_length,clamp_base]) rotate([0, 0, -90])
        belt_cutout(clamp_inside_radius, dTheta_inside);
//	    }
	  }

          translate([0,-11,0])
          cube([7.5,12,clamp_thickness]);
         translate([0,20,0])
          cube([7.5,12,clamp_thickness]);

}

//Carriage Module


separation = 40;
thickness = 6;

horn_thickness = 13;
horn_x = 8;

belt_width = 5;
belt_x = 5.6;
belt_z = 7;

module carriage() {
  // Timing belt (up and down).
  translate([-belt_x, 0, belt_z + belt_width/2]) %
    cube([1.7, 100, belt_width], center=true);
  translate([belt_x, 0, belt_z + belt_width/2]) %
    cube([1.7, 100, belt_width], center=true);
  difference() {
    union() {
      // Main body.
      translate([0, 2.5, thickness/2])
        cube([27, 43, thickness], center=true);
      // Ball joint mount horns.
      for (x = [-1, 1]) {
        scale([x, 1, 1]) intersection() {
          translate([0, 12, horn_thickness/2])
            cube([separation, 24, horn_thickness], center=true);
          translate([horn_x, 16, horn_thickness/2]) rotate([0, 90, 0])
            cylinder(r1=17, r2=2.5, h=separation/2-horn_x);
        }
      }

	translate([-3.5,-8,thickness])
	belt_clips();
      // Belt clamps.
 //     difference() {
//        union() {
//         translate([6.5, -2.5, horn_thickness/2+1])
  //          cube([14, 7, horn_thickness-2], center=true);
//          translate([10.75, 2.5, horn_thickness/2+1])
//            cube([5.5, 16, horn_thickness-2], center=true);
//        }
//        // Avoid touching diagonal push rods (carbon tube).
//        translate([20, -10, 12.5]) rotate([35, 35, 30])
//          cube([40, 40, 20], center=true);
//      }
//      for (y = [-12, 7]) {
//        translate([1.25, y, horn_thickness/2+1])
//          cube([7, 8, horn_thickness-2], center=true);
//      }
	 }
    // Screws for linear slider.
    for (x = [-10, 10]) {
      for (y = [-10, 10]) {
        translate([x, y, thickness]) 
          cylinder(r=m3_wide_radius, h=30, center=true, $fn=12);
      }
    }
    // Screws for ball joints.
    translate([-15, 16, horn_thickness/2]) rotate([0, 90, 0]) 
          cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
    translate([15, 16, horn_thickness/2]) rotate([0, 90, 0]) 
      cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
    // Lock nuts for ball joints.
    for (x = [-1, 1]) {
      scale([x, 1, 1]) intersection() {
        translate([horn_x, 16, horn_thickness/2]) rotate([90, 0, -90])
          cylinder(r=m3_nut_radius, h=8,
                   center=true, $fn=6);
      }
    }
  }
}




carriage();
