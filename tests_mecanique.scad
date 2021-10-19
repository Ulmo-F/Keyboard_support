$fn=100;

overlap = 0.1;
infty = 100;

main_rectangle_height = 2;

text_height = 0.6;
text_size = 6;

pod_diam = 9;
pod_height_margin = 0;

nut_width = 3.84;
nut_height = 1.5;
nut_length = 4.4;
nut_margin = 0.2;
nut_case_width = 1;
nut_screw_hole_radius = 1.9 / 2 + 0.25; // = 1.2
screw_diam_2mm = 2;
screw_diam_3mm = 3;
screw_margin = 0.0;
//nut_screw_hole_radius = 2.4 / 2;

nut_positions=[
    [-10, 6, .0],
    [-20, 6, .1],
    [-31, 6, .2],
    [-42, 6, .3]
];

module nutCase(margin) {
    difference()
    {
        X1 = nut_length + 2 * nut_case_width;
        Y1 = nut_length + 2 * nut_case_width;
        Z1 = nut_height + nut_case_width;
        translate([-X1/2, -Y1/2, -overlap]) cube([X1, Y1, Z1 + overlap]);

        X2 = nut_width + margin;
        Y2 = nut_length + margin/2;
        Z2 = nut_height + margin;
        translate([-X2/2, -Y2/2, -infty]) cube([X2, Y2+infty, Z2 + infty]);
    }
}

module nutCaseScrew() {
    translate([0, 0, -overlap])
        cylinder(r=nut_screw_hole_radius, h=main_rectangle_height+nut_height+nut_case_width+2*overlap);
}

module screwHole(diam) {
    translate([0, 0, -overlap-infty])
        cylinder(r=diam/2 + screw_margin, h=main_rectangle_height+infty*2+2*overlap);
}

module base(x1, y1, x2, y2) {
    translate([x1, y1])
        cube([x2-x1, y2-y1, main_rectangle_height]);
}

module pod(screw_insert, use_conical) {
// outer_diam, inner_diam, outer_height, inner_height
    difference()
    {
        translate([0, 0, -2*overlap]) cylinder(r = pod_diam/2, h = screw_insert[3] + pod_height_margin + 2*overlap);

        translate([0, 0, pod_height_margin]) 
            if (use_conical)
                screwInsertConical(screw_insert);
            else
                screwInsert(screw_insert);
    }
}

// screw_insert_1     = [ 4  , 3.6, 1.5, 5  ]; // 3mm
module screwInsert(screw_insert) {
// outer_diam, inner_diam, outer_height, inner_height
    translate([0, 0, screw_insert[3]-screw_insert[2]-overlap])
        cylinder(r=screw_insert[0]/2, h=screw_insert[2]+2*overlap);
    translate([0, 0, -overlap])
        cylinder(r=screw_insert[1]/2, h=screw_insert[3]+2*overlap);
}

module screwInsertConical(screw_insert) {
// outer_diam, inner_diam, outer_height, inner_height
    translate([0, 0, screw_insert[3]-screw_insert[2]-overlap])
//        cylinder(r=screw_insert[0]/2, h=screw_insert[2]+2*overlap);
        cylinder(r1=screw_insert[1]/2, r2=screw_insert[0]-screw_insert[1]/2, h=screw_insert[2]+2*overlap);
    translate([0, 0, -overlap])
        cylinder(r=screw_insert[1]/2, h=screw_insert[3]+2*overlap);
}

// outer_diam, inner_diam, outer_height, inner_height
screw_insert_1     = [ 4.6, 3.6, 1.5, 5  ]; // 3mm
screw_insert_1_m   = [   5,   4, 1.5, 5  ]; // 3mm
screw_insert_2     = [ 3.6, 2.9, 2.5, 5  ]; // 2mm

difference() {
    union() {
        base(-48, -6, 22, 16);
        translate([ 0,  0, main_rectangle_height]) pod(screw_insert_1  , true );
        translate([10,  0, main_rectangle_height]) pod(screw_insert_1  , false);
        translate([18, -2, main_rectangle_height]) linear_extrude(text_height + overlap)
                text(".0", text_size, halign="center");
        translate([ 0, 10, main_rectangle_height]) pod(screw_insert_1_m, true );
        translate([10, 10, main_rectangle_height]) pod(screw_insert_1_m, false);
        translate([18,  8, main_rectangle_height]) linear_extrude(text_height + overlap)
                text(".4", text_size, halign="center");

        for (p = nut_positions)
            translate([p[0], p[1], main_rectangle_height]) 
            nutCase(p[2]);
        for (p = nut_positions)
            translate([p[0], p[1] - 10, main_rectangle_height - overlap])
            linear_extrude(text_height + overlap)
                text(str(p[2]), text_size, halign="center");
    }
    union()
    {
        for (p = nut_positions)
            translate([p[0], p[1]]) screwHole(screw_diam_2mm);
        translate([ 0,  0]) screwHole(screw_diam_3mm);
        translate([10,  0]) screwHole(screw_diam_3mm);
        translate([ 0, 10]) screwHole(screw_diam_3mm);
        translate([10, 10]) screwHole(screw_diam_3mm);
    }
}
