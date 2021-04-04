// R/K Delta by sushiyaki
// http://www.thingiverse.com/sushiyaki/designs/
//
// EDIT : Mini Kossel by Johann C. Rocholl
// https://github.com/jcrocholl/kossel
// licensed under the Creative Commons - GNU GPL license. 

include <configuration.scad>;

use <vertex.scad>;
use <nema17.scad>;

$fn = 24;

module frame_motor() {
  difference() {
    // No idler cones.
    vertex(2.5*extrusion, idler_offset=0, idler_space=100);
    // Motor cable paths.
    for (i = [-1, 1]) scale([i, 1, 1]) {
      translate([-35, 45, 0]) rotate([0, 0, -30])
        cube([4, extrusion, extrusion], center=true);
      translate([-11-7, 5, 0]) rotate([0,0,-12])
        cube([4, extrusion, extrusion], center=true);
	   translate([-11-13.25, 17+2.5, 0])  rotate([0,0,64])
        cube([4, extrusion, extrusion], center=true);
    }
    translate([0, motor_offset, 0]) {
      // Motor shaft/pulley cutout.
      rotate([90, 0, 0]) cylinder(r=12, h=20, center=true, $fn=60);
      // NEMA 17 stepper motor mounting screws.
      for (x = [-1, 1]) for (z = [-1, 1]) {
        scale([x, 1, z]) translate([15.5, -5, 15.5]) {
          rotate([90, 0, 0]) cylinder(r=1.65, h=20, center=true, $fn=12);
          // Easier ball driver access.
          rotate([74-3, -30, 0]) # cylinder(r=1.8, h=60, $fn=12);
        }
      }
    }
    translate([0, motor_offset, 0]) rotate([90, 0, 0]) % nema17();
  }
}

translate([0, 0, 1.25*extrusion]) frame_motor();
