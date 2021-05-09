hole = 5;
cube([40 - hole, 7.5,1]);
translate([38.6, 2 , 0.75]) rotate([90, 0, 0]) {
    difference() {
        cylinder(h=2, r=4, $fa = 0.5, $fs = 0.5);
        translate([0, 0, -1]) cylinder(h=6, r=2, $fa = 0.5, $fs = 0.5);
    }
}
translate([35, 2, 0.75]) rotate([90, 180, 0]) linear_extrude(2) 
circle(3,$fn=3);