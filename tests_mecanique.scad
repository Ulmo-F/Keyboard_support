$fn=100;


main_rectangle_height = 1;

screw_insert_outer_radius = 4/2;
screw_insert_inner_radius = 3/2;
screw_insert_outer_height = 1;
screw_insert_inner_height = 3;

screw_insert_outer_radius_3 = 4.1 / 2;
screw_insert_inner_radius_3 = 3.5 / 2;
screw_insert_outer_height_3 = 1.6;
screw_insert_inner_height_3 = 5;

screw_insert_outer_radius_2 = 3.6 / 2;
screw_insert_inner_radius_2 = 2.9 / 2;
screw_insert_outer_height_2 = 1.3;
screw_insert_inner_height_2 = 5;

nut_width = 3.9;
nut_height = 1.6;
nut_length = 4.4;
nut_margin = 0.2;
screw_spacer_height = 3;
screw_spacer_radius = 5 / 2;
screw_hole_radius = 2.4 / 2;

module nutCase() {
    difference()
    {
        translate([-nut_length / 2 - 2, -nut_length / 2 - 2, main_rectangle_height / 2]) cube([nut_length + 4, nut_length + 4, nut_height + 1.5 + main_rectangle_height / 2]);
        translate([-nut_width / 2 - nut_margin, 6 - 6 - nut_length / 2 - nut_margin, main_rectangle_height - nut_margin]) cube([nut_width+2*nut_margin, 12+1*nut_length+2*nut_margin, nut_height + nut_margin]);
    }
}

screw_positions=[
    [-7, -3]
];




module screwInsert() {
    translate([0, 0, -1])
        cylinder(r=screw_insert_outer_radius, h=screw_insert_outer_height+1);
    translate([0, 0, -1])
        cylinder(r=screw_insert_inner_radius, h=screw_insert_inner_height+1);
}

difference() {
    union() {
        translate([-15, -10, 0]) cube([30, 20, main_rectangle_height]);
        for (position = screw_positions)
            translate(position) nutCase();
    }
    for (position = screw_positions)
        translate(position) translate([0, 0, -4-screw_spacer_height]) cylinder(r=  screw_hole_radius, h=screw_spacer_height+   main_rectangle_height+8);
}

translate([5, 0, 0]) difference() {
    cylinder(r = 4, h = 4);
    translate([0, 0, 2]) screwInsert();
}

translate([-7, 3, main_rectangle_height]) linear_extrude(0.3) text("1.6", 4, halign="center");