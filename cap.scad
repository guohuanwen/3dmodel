//内径75mm，外径90mm
cylinder(h = 1, r = 44, center = true, $fn = 0, $fa = 1, $fs = 2);
translate([0, 0, 1]) {
    cylinder(h = 3, r1 = 38, r2 = 37, center = true, $fn = 0, $fa = 1, $fs = 2);
}