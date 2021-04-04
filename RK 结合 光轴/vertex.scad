// R/K Delta by sushiyaki
// http://www.thingiverse.com/sushiyaki/designs/
//
// EDIT : Mini Kossel by Johann C. Rocholl
// https://github.com/jcrocholl/kossel
// licensed under the Creative Commons - GNU GPL license. 

include <configuration.scad>;

$fn = 24;
roundness = 6;

module extrusion_cutout(h, extra) {
  difference() {
    cube([extrusion+extra, extrusion+extra, h], center=true);
    for (a = [0:90:359]) rotate([0, 0, a]) {
      translate([extrusion/2, 0, 0])
        cube([6, 6, h+1], center=true);
    }
  }
}

module screw_socket() {
  cylinder(r=m3_wide_radius, h=20, center=true);
  translate([0, 0, 3.8-5]) cylinder(r=3.5, h=5);
}

module screw_socket_cone() {
  union() {
    translate([0,0,2.5])
      screw_socket();
    translate([0,0,-2.8]) scale([1.25, 1, -1]) cylinder(r1=4, r2=7, h=8);
  }
}

module vertex(height, idler_offset, idler_space) {
  union() {
    // Pads to improve print bed adhesion for slim ends.
    translate([-37.5-5, 52.2+5, -height/2]) cylinder(r=10, h=0.3);
    translate([37.5+5, 52.2+5, -height/2]) cylinder(r=10, h=0.3);

    difference() {
      union() {
        intersection() {
			union() {
			  translate([0, 33+16, 0])
			    cube([100,100,60],center=true);
			  for(i=[1,-1]) {
              translate([(13.5+3.5-0.2)*i,-3.5+0.3,0])
              difference() {
                translate([-2.4*i,0,0])
                  cube([10,4.8,50],center=true);
                translate([2.4*i,-2.4,0])
                  cylinder(r=4.8,h=55,center=true, $fn=24);
              }				
            }
            translate([0, 33, 0])
			  intersection() {
			    cube([29,100,60],center=true);
				 difference() {
                translate([0, -11, 0])
            		 cylinder(r=36-15+extrusion, h=height, center=true, $fn=24);
                translate([0,-50,12]) rotate([45,0,0])
                  cube([40,40,20],center=true);
              }
            }
          }
          translate([0, 22, 0])
            cylinder(r=36-12+extrusion, h=height, center=true, $fn=24);
          translate([0, -37+24, 0]) rotate([0, 0, 30])
            cylinder(r=50, h=height+1, center=true, $fn=6);
        }
        translate([0, 38, 0]) intersection() {
          rotate([0, 0, -90])
            cylinder(r=55+5, h=height, center=true, $fn=3);
			union() {
            translate([0, 10, 0])
              cube([100, 100, 2*height], center=true);
            translate([0, 6, 0])
			    cube([29,100,60],center=true);
          }
          translate([0, -10, 0]) rotate([0, 0, 30])
            cylinder(r=55+5, h=height+1, center=true, $fn=6);
        }
      }
      difference() {
        translate([0, 58, 0]) minkowski() {
          intersection() {
            rotate([0, 0, -90])
              cylinder(r=55+5, h=height, center=true, $fn=3);
            translate([0, -32, 0])
              cube([100, 16, 2*height], center=true);
          }
          cylinder(r=roundness, h=1, center=true);
        }
        // Idler support cones.
        translate([0, 26+idler_offset-30, 0]) rotate([-90, 0, 0])
          cylinder(r1=30, r2=2, h=30-idler_space/2);
        translate([0, 26+idler_offset+30, 0]) rotate([90, 0, 0])
          cylinder(r1=30, r2=2, h=30-idler_space/2);
      }
      translate([0, 58, 0]) minkowski() {
        intersection() {
          rotate([0, 0, -90])
            cylinder(r=55+5, h=height, center=true, $fn=3);
          translate([0, 7, 0])
            cube([100, 30, 2*height], center=true);
        }
        cylinder(r=roundness, h=1, center=true);
      }
      translate([0, -2.5, 0])
      extrusion_cutout(height+10, 2*extra_radius);
      translate([0,-2.5,0]) rotate([0,90,0]) {
        translate([0,0,13])
          screw_socket_cone();        
        scale([1, 1, -1]) translate([0,0,13])
          screw_socket_cone();
        translate([-6.2, -extrusion/2,0]) cube([8,8,8],center=true);
        for(i=[-27.0,27.0]) {
          translate([0,-0,i])
          scale([height/extrusion,1.3,1])
            cylinder(r=6,h=25,$fn=6,center=true);
        }
      }
      // 8mm Smooth rods.
      for(i=[-30.1,30.1]) {
        translate([i,12-0.3,0])
          cylinder(r=4+2*extra_radius,h=200,center=true);
      }
      for (z = [0:30:height]) {
        for (a = [-1, 1]) {
          rotate([0, 0, 30*a]) translate([-16*a, 111, z+extrusion/2-height/2]) {
            // Screw sockets.
            for (y = [-88*0.85, -44*0.9]) {
              translate([a*extrusion/2, y, 0]) rotate([0, a*90, 0]) screw_socket();
            }
          }
        }
      }
    }
  }
}

translate([0, 0, extrusion/2]) vertex(extrusion, idler_offset=0, idler_space=10);
