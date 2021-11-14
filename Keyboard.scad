        // Ajuster profondeur mur du fond (aligner avec la plate)
        // Mur du fond D/G, plus trou pour vis, de la bonne epaisseur
        // Ajuster les cases/inserts. Penser a creuser plus profond que l'insert !
        // découpe en 2
        // cales d'ajustement pour les 2 parties
        // Minimiser inclinaison & hauteur



pcb_width = 311;
pcb_depth = 120;
pcb_height = 1.7;
pcb_margin = 5;
main_rectangle_height = 3;
keyboard_inclinaison = 10;

plate_width = 307;
plate_depth = 117.6;
plate_height = 1.3;
plate_offset= [2, 2];
pcb_plate_gap = 6.5;// - pcb_height - plate_height;

bluepill_width = 23;
bluepill_depth = 53;
bluepill_height = 15;
bluepill_margin = 2;

nut_width = 3.84;
nut_height = 1.5;
nut_length = 4.4;
nut_margin = 0.5;
nut_case_width = 1;
nut_screw_hole_radius = 1.9 / 2 + 0.25; // = 1.2
overlap = 0.1;
infty = 100;
screw_diam_2mm = 2 + 0.2;
screw_diam_3mm = 3;
screw_margin = 0.0;

// outer_diam, inner_diam, outer_height, inner_height
screw_insert_3mm   = [ 4.6, 3.9, 1.0, 7  ];


screw_spacer_height = 3;
screw_spacer_radius = 5 / 2;
screw_hole_radius = 2.2 / 2;
screw_positions=[
    [41, 10], [120, 10], [282, 10],
    [47, 70], [282, 70],
    [41, 108], [118, 108], [192, 108], [270, 108]
];

back_depth = 14;
back_width = 20;
back_point = [0, plate_depth + 2, -pcb_plate_gap - screw_spacer_height];

pod_radius = 10;
pod_positions=[
    [2 * pod_radius, 2 * pod_radius],
    [pcb_width-2 * pod_radius, 2 * pod_radius],
//    [pcb_width-2 * pod_radius, pcb_depth-2 * pod_radius],
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


module plate() {
    color("purple")
    {
        translate(plate_offset)
            translate([0, 0, -pcb_plate_gap])
                cube([plate_width, plate_depth, plate_height]);
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

module pods() {
    for (position = pod_positions)
        translate(position)
            translate([0, 0, -10])
                cylinder(r=pod_radius, h=110);

}

module support() {
    translate([pcb_margin, pcb_margin, -1]) 
//        difference() {
            cube([pcb_width - 2 * pcb_margin, pcb_depth - 2 * pcb_margin, main_rectangle_height + 1]);
    pods();
    back();
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

// screw_insert     = [ 4  , 3.6, 1.5, 5  ]; // 3mm
module screwInsert(screw_insert) {
// outer_diam, inner_diam, outer_height, inner_height
    translate([0, 0, screw_insert[3]-screw_insert[2]-overlap])
        cylinder(r=screw_insert[0]/2, h=screw_insert[2]+2*overlap);
    translate([0, 0, -overlap])
        cylinder(r=screw_insert[1]/2, h=screw_insert[3]+2*overlap);
    translate([0, 0, -overlap])
        cylinder(r=screw_diam_3mm/2, h=50+2*overlap);
}
module screwInsert_old() {
    translate([0, 0, -1])
        cylinder(r=screw_insert_outer_radius, h=screw_insert_outer_height+1);
    translate([0, 0, -1])
        cylinder(r=screw_insert_inner_radius, h=screw_insert_inner_height+1);
}

module entretoises() {
    for (position = screw_positions)
        translate([0, 0, -screw_spacer_height]) translate(position) entretoise();
}

module nutCase(margin) {
    difference()
    {
        X1 = nut_length + 4 * nut_case_width;
        Y1 = nut_length + 4 * nut_case_width;
        Z1 = nut_height + 1 + nut_case_width;
        translate([-X1/2, -Y1/2, -overlap]) cube([X1, Y1, Z1 + overlap]);

        X2 = nut_length + margin;
        Y2 = nut_width + margin/2;
        Z2 = nut_height + 1 + margin;
        translate([-X2/2, -Y2/2, -infty]) cube([X2, Y2+infty, Z2 + infty]);
    }
}

module nuts() {
    for (p = screw_positions)
        translate([p[0], p[1], main_rectangle_height]) 
            nutCase(0.2);
}

module back() {
    translate(back_point) rotate([keyboard_inclinaison, 0, 0]) {
        translate([25, -back_depth, 0])
            difference() {
                cube([10, back_depth, 60]);
                translate([back_width / 2-5, 20, 20]) rotate([90, 0, 0]) cylinder(r=1.1, h=25);
            }
        translate([pcb_width - back_width - 7, -back_depth, 0])
            difference() {
                cube([back_width, back_depth, 60]);
                translate([back_width / 2, 20, 20]) rotate([90, 0, 0]) cylinder(r=1.1, h=25);
            }
        translate([pcb_width/2, -back_depth, 0])
        difference() {
            translate([-25, 0, 0]) cube([50, back_depth, 60]);
            translate([0, 7.55, 24]) {
                rotate([0, 0, 180]) import("sock.stl");
                translate([0, 1, 0]) rotate([0, 0, 180]) import("sock.stl");
                translate([31.0/2-1.75, 8, 0]) rotate([90, 0, 0]) cylinder(r=1.51, h = 20);
                translate([-31.0/2+1.75, 8, 0]) rotate([90, 0, 0]) cylinder(r=1.51, h = 20);
                translate([0, 20, 7]) rotate([90, 0, 0]) cylinder(r=1.1, h=55);
            }
        }
    }
}

module global() {
    difference() {
        support();

//        priseUSB();
        screw_holes();
        bluepill_hole();
        translate([-20, -20, 0]) rotate([keyboard_inclinaison, 0, 0]) translate([-20, -20, 0]) cube([400, 200, 500]);

        translate([-pcb_margin, -pcb_margin, -200]) 
                cube([pcb_width + 2 * pcb_margin, pcb_depth + 2 * pcb_margin, 200]);

        for (position = pod_positions)
            translate(position)
                translate([0, 0, (position[1]+20) * tan(keyboard_inclinaison)])            rotate([keyboard_inclinaison+180, 0, 0]) screwInsert(screw_insert_3mm);

        translate([ -150, -150, -10]) cube([300, 300, 10]);
    }
}

module left() {
difference() {
    global();
    translate([pcb_width / 2 - 8, 0, 0]) rotate([0, 0, -6]) translate([0, -500, -500]) cube([1000, 1000, 1000]);
}
translate([pcb_width / 2 - 2 - 7, pcb_depth / 2 - 25, main_rectangle_height]) cube([14, 10, main_rectangle_height]);
translate([pcb_width / 2 - 2 - 7, pcb_depth / 2 + 15, main_rectangle_height]) cube([14, 10, main_rectangle_height]);
}

module right() {
difference() {
    global();
    translate([pcb_width / 2 - 8, 0, 0]) rotate([0, 0, 180-6]) translate([0, -500, -500]) cube([1000, 1000, 1000]);
}
translate([pcb_width / 2 - 2 - 7, pcb_depth / 2 - 15, main_rectangle_height]) cube([14, 30, main_rectangle_height]);
}




//difference() { union() {
//left();
//right();
//}
//    translate(back_point) rotate([keyboard_inclinaison, 0, 0])
//        translate([pcb_width/2, -back_depth, 0])
//            translate([0, 7.55, 24])
//            rotate([0, 0, 180]) import("sock.stl");
//}

left();

//right();

//global();
//entretoises();




// translate([0, 0, -screw_spacer_height]) PCB();
// translate([0, 0, -screw_spacer_height]) plate();

//rotate([0, 0, 180]) import("sock.stl");
//translate([31.0/2-1.75, 8, 0]) rotate([90, 0, 0]) cylinder(r=1.5, h = 20);
//translate([-31.0/2+1.75, 8, 0]) rotate([90, 0, 0]) cylinder(r=1.5, h = 20);

//    [pcb_width-2 * pod_radius, pcb_depth-2 * pod_radius],
//    translate([pcb_margin, pcb_margin, 10]) cube([pcb_width - 2 * pcb_margin, pcb_depth - 2 * pcb_margin, 3]);
