pcb_width = 311;
pcb_depth = 120;
pcb_margin = 5;
main_rectangle_height = 2;
keyboard_inclinaison = 15;

bluepill_width = 23;
bluepill_depth = 53;
bluepill_height = 15;
bluepill_margin = 10;

screw_spacer_height = 5;
screw_spacer_radius = 5 / 2;
screw_hole_radius = 3.2 / 2;
screw_positions=[
    [41, 10], [120, 10], [282, 10],
    [47, 70], [282, 70],
    [41, 108], [118, 108], [192, 108], [270, 108]
];

$fn=100;
r=10;

module pod(h, rot) {
    //r=10;
//    h=5;
    a=45;
//    difference() {
    translate([0, 0, h+r])
    rotate([180+a, 0, rot])
        union() {
            cylinder(r=r, h=(h+2*r)/cos(a));
            sphere(r=r);
        };
  //      translate([-111, -111, 0]) cube([pcb_width, pcb_depth, h+r]);
    //}
}

module pods() {
    innerness = 2 * r;
    difference() {
        union() {
            translate([innerness, innerness]) pod(-5, -45);
            translate([pcb_width-innerness, innerness]) pod(-5, 45);
            translate([pcb_width/2, innerness]) pod(-5, 0);
            translate([2*innerness, pcb_depth-innerness]) pod(25, -135);
            translate([pcb_width-innerness, pcb_depth-innerness]) pod(25, 135);
//            translate([pcb_width/2, pcb_depth-innerness]) pod(25, 180);
            translate([pcb_width/2, pcb_depth-innerness]) pod(25, 135);
            translate([pcb_width/2, pcb_depth-innerness]) pod(25, -135);
        }
        translate([0, 0, -15*3]) cube([pcb_width, pcb_depth, 15*3]);
    }
}

module support() {
    translate([pcb_margin, pcb_margin]) 
        difference() {
            cube([pcb_width - 2 * pcb_margin, pcb_depth - 2 * pcb_margin, main_rectangle_height]);
//            translate([50, 20, -1]) cube([200, 70, main_rectangle_height + 2]);
//            translate([130, -10, -1]) cube([130, 40, main_rectangle_height + 2]);
//            translate([130, 80, -1]) cube([40, 40, main_rectangle_height + 2]);
//    translate([-70, -100, -1]) linear_extrude(main_rectangle_height+2) scale([2.5, 1.65, 1]) import("unicorn.svg");
        }
//    for (position = screw_positions)
//        translate([0, 0, -screw_spacer_height]) translate(position) cylinder(r=screw_spacer_radius, h=screw_spacer_height+main_rectangle_height);
    pods();
}

module screw_holes() {
    for (position = screw_positions)
        translate(position) translate([0, 0, -1-screw_spacer_height]) cylinder(r=screw_hole_radius, h=screw_spacer_height+main_rectangle_height+2);
}

module bluepill_hole() {
    translate([-bluepill_margin, pcb_depth - bluepill_depth - bluepill_margin, -bluepill_margin])
        cube([bluepill_width + 2 * bluepill_margin, bluepill_depth + 2 * bluepill_margin, bluepill_height + 2 * bluepill_margin]);
}


module engin() {
difference() {
    support();
    screw_holes();
    bluepill_hole();
    translate([-20, -20, 0]) rotate([keyboard_inclinaison, 0, 0]) translate([-20, -20, 0]) cube([400, 200, 500]);
}
//pods();
}

module entretoise() {
difference() {
cylinder(r=screw_spacer_radius, h=screw_spacer_height);
translate([0, 0, -1]) cylinder(r=screw_hole_radius, h=screw_spacer_height++2);
}
}

module entretoises() {
    for (position = screw_positions)
        translate([0, 0, -screw_spacer_height]) translate(position) entretoise();
}

module supportUSB() {
    //translate([-20, -20, 0]) 
    translate([pcb_width/2, pcb_depth, 0])
    rotate([keyboard_inclinaison, 0, 0])
    translate([-25, 0, 0])cube([50, 5, 8]);
}

supportUSB();
difference() {
engin();
//    translate([ -1, -1, -1]) cube([150, 150, 150]);
}

entretoises();
