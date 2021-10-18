pcb_width = 311;
pcb_depth = 120;
pcb_height = 1;
pcb_margin = 5;
main_rectangle_height = 3;
keyboard_inclinaison = 15;

bluepill_width = 23;
bluepill_depth = 53;
bluepill_height = 15;
bluepill_margin = 2;

nut_width = 3.9;
nut_height = 1.5;
nut_length = 4.4;
nut_margin = 0.2;

screw_spacer_height = 3;
screw_spacer_radius = 5 / 2;
screw_hole_radius = 2.2 / 2;
screw_positions=[
    [41, 10], [120, 10], [282, 10],
    [47, 70], [282, 70],
    [41, 108], [118, 108], [192, 108], [270, 108]
];

screw_insert_outer_radius = 4/2;
screw_insert_inner_radius = 3/2;
screw_insert_outer_height = 1;
screw_insert_inner_height = 3;

screw_insert_outer_radius = 4.1 / 2;
screw_insert_inner_radius = 3.5 / 2;
screw_insert_outer_height = 1.6;
screw_insert_inner_height = 5;

screw_insert_outer_radius_2 = 3.6 / 2;
screw_insert_inner_radius_2 = 2.9 / 2;
screw_insert_outer_height_2 = 1.3;
screw_insert_inner_height_2 = 5;


pod_radius = 10;
    pod_positions=[
        [2 * pod_radius, 2 * pod_radius],
        [pcb_width-2 * pod_radius, 2 * pod_radius],
        [pcb_width-2 * pod_radius, pcb_depth-2 * pod_radius],
        [4 * pod_radius, pcb_depth- 3 * pod_radius],
        [pcb_width/3, pcb_depth/2],
        [2*pcb_width/3, pcb_depth/2],
        [pcb_width/2, 2 * pod_radius],
    ];


$fn=100;

module PCB() {
    color("blue")
    {
        translate([0, 0, -pcb_height]) cube([pcb_width, pcb_depth, pcb_height]);
        translate([-bluepill_margin, pcb_depth - bluepill_depth - bluepill_margin, -bluepill_margin]) cube([bluepill_width + 2 * bluepill_margin, bluepill_depth + 2 * bluepill_margin, bluepill_height +2 * bluepill_margin]);
    }
}

module pod(h, rot) {
    //r=10;
//    h=5;
    a=45;
//    difference() {
    translate([0, 0, h+r])
    rotate([180+a, 0, rot])
        union() {
            cylinder(r=pod_radius, h=(h+2*r)/cos(a));
            sphere(r=pod_radius);
        };
  //      translate([-111, -111, 0]) cube([pcb_width, pcb_depth, h+r]);
    //}
}

module pod2(position) {
    translate(position)
        translate([0, 0, 50+pod_radius]) rotate([180, 0, 0]) cylinder(r=pod_radius, h=50+2*pod_radius);
}

module pods() {
    for (position = pod_positions)
        translate(position)
            translate([0, 0, -10])
                cylinder(r=pod_radius, h=110);

}

module pods2() {
    innerness = 2 * pod_radius;
    difference() {
        union() {
            translate([innerness, innerness]) pod2();
            translate([pcb_width-innerness, innerness]) pod2();
            translate([pcb_width/2, innerness]) pod2();
            translate([2*innerness, pcb_depth-innerness]) pod2();
            translate([pcb_width-innerness, pcb_depth-innerness]) pod2();
//            translate([pcb_width/2, pcb_depth-innerness]) pod(25, 180);
//            translate([pcb_width/2-5, pcb_depth-innerness]) pod(25, 135);
//            translate([pcb_width/2+5, pcb_depth-innerness]) pod(25, -135);
            translate([pcb_width/3, pcb_depth/2]) pod2();
            translate([pcb_width*2/3, pcb_depth/2]) pod2();
        }
//        translate([0, 0, -15*3]) cube([pcb_width, pcb_depth, 15*3]);
    }
}

module support() {
    translate([pcb_margin, pcb_margin, -1]) 
//        difference() {
            cube([pcb_width - 2 * pcb_margin, pcb_depth - 2 * pcb_margin, main_rectangle_height + 1]);
//            translate([50, 20, -1]) cube([200, 70, main_rectangle_height + 2]);
//            translate([130, -10, -1]) cube([130, 40, main_rectangle_height + 2]);
//            translate([130, 80, -1]) cube([40, 40, main_rectangle_height + 2]);
//    translate([-70, -100, -1]) linear_extrude(main_rectangle_height+2) scale([2.5, 1.65, 1]) import("unicorn.svg");
//        }
//    for (position = screw_positions)
//        translate([0, 0, -screw_spacer_height]) translate(position) cylinder(r=screw_spacer_radius, h=screw_spacer_height+main_rectangle_height);
    pods();
    supportUSB();
    nuts();
}

module screw_holes() {
    for (position = screw_positions)
        translate(position) translate([0, 0, -4-screw_spacer_height]) cylinder(r=screw_hole_radius, h=screw_spacer_height+main_rectangle_height+8);
}

module bluepill_hole() {
    translate([-bluepill_margin, pcb_depth - bluepill_depth - bluepill_margin, -1*bluepill_margin])
        cube([bluepill_width + 2 * bluepill_margin, bluepill_depth + 2 * bluepill_margin, bluepill_height + 2 * bluepill_margin]);
}

module entretoise() {
difference() {
cylinder(r=screw_spacer_radius, h=screw_spacer_height+1);
translate([0, 0, -1]) cylinder(r=screw_hole_radius, h=screw_spacer_height+3);
}
}

module screwInsert() {
    translate([0, 0, -1])
        cylinder(r=screw_insert_outer_radius, h=screw_insert_outer_height+1);
    translate([0, 0, -1])
        cylinder(r=screw_insert_inner_radius, h=screw_insert_inner_height+1);
}

module entretoises() {
    for (position = screw_positions)
        translate([0, 0, -screw_spacer_height]) translate(position) entretoise();
}

module nutCase() {
    difference() {
        cube([nut_length + 4, nut_length + 4, 4 * nut_height], center = true);
        translate([0, 6-0*nut_length-0*nut_margin, 0]) cube([nut_width+2*nut_margin, 12+1*nut_length+2*nut_margin, 2*nut_height+2*nut_margin], center = true);
    }
}

module nuts() {
    for (position = screw_positions)
        translate([0, 0, +main_rectangle_height]) translate(position)
    nutCase();
}

module supportUSB() {
    //translate([-20, -20, 0]) 
    translate([pcb_width/2, pcb_depth-10, 10])
    rotate([keyboard_inclinaison, 0, 0])
    {
        translate([-25, -9, -8])
        cube([50, 15, 40]);
    }
}

module priseUSB() {
    //translate([-20, -20, 0]) 
    translate([pcb_width/2, pcb_depth-5, 0])
    rotate([keyboard_inclinaison, 0, 0])
    {
        translate([0, -3, 20])
        rotate([0, 0, 180]) import("sock.stl");
    }
}

difference() {
    union() {
        support();
//        priseUSB();
    }
    priseUSB();
    screw_holes();
//    bluepill_hole();
    translate([-20, -20, 0]) rotate([keyboard_inclinaison, 0, 0]) translate([-20, -20, 0]) cube([400, 200, 500]);

    translate([-pcb_margin, -pcb_margin, -200]) 
            cube([pcb_width + 2 * pcb_margin, pcb_depth + 2 * pcb_margin, 200]);

    for (position = pod_positions)
        translate(position)
            translate([0, 0, (position[1]+20) * tan(keyboard_inclinaison)])            rotate([keyboard_inclinaison+180, 0, 0]) screwInsert();
translate([0, 0, -screw_spacer_height]) PCB();

    translate([ -150, -150, -10]) cube([300, 300, 10]);
}
entretoises();

