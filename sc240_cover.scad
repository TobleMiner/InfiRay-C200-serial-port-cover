HEIGHT = 3.25;

RIM_LENGTH = 40.5;
RIM_WIDTH = 14.5;
RIM_HEIGHT = 1.25;

BASE_LENGTH = 38;
BASE_WIDTH = 12;
BASE_HEIGHT = HEIGHT - 0.55;

SD_CARD_LENGTH = 15;
SD_CARD_WIDTH = 2.11;
SD_CARD_BLIND_LENGTH = 2.5;

USB_C_LENGTH = 9.8;
USB_C_HEIGHT = 3.5;

FLAP_LENGTH = 8.9;
FLAP_WIDTH = 2;

SCREW_HOLE_TAPER_HEIGHT = 1;
SCREW_HOLE_TAPER_OD = 3.4; // non-oversized 2.8mm
SCREW_HOLE_TAPER_ID = 2.6; // non-oversized 2.2mm

HEADER_LENGTH = 9;
HEADER_WIDTH = 2.4;

module rounded_rect(vec) {
    length = vec[0];
    width = vec[1];
    height = vec[2];
    cylinder(height, width/2, width/2, $fn=100);
    translate([0, -width/2, 0]) cube([length - width, width, height]);
    translate([length - width, 0, 0]) cylinder(height, width/2, width/2, $fn=100);
}

module double_rounded_rect(vec, corner_radius) {
    length = vec[0];
    width = vec[1];
    height = vec[2];
    translate([corner_radius, corner_radius, 0]) cylinder(height, corner_radius, corner_radius, $fn=100);
    translate([corner_radius, width - corner_radius, 0]) cylinder(height, corner_radius, corner_radius, $fn=100);
    translate([length - corner_radius, corner_radius, 0]) cylinder(height, corner_radius, corner_radius, $fn=100);
    translate([length - corner_radius, width - corner_radius, 0]) cylinder(height, corner_radius, corner_radius, $fn=100);
    translate([0, corner_radius, 0]) cube([length, width - 2 * corner_radius, height]);
    translate([corner_radius, 0 , 0]) cube([length - 2 * corner_radius, width, height]);
}

module rounded_rect_origin(vec) {
    translate([vec[1]/2, vec[1]/2, 0]) rounded_rect(vec);
}

module base() {
    rounded_rect([BASE_LENGTH, BASE_WIDTH, BASE_HEIGHT]);
}

module rim() {
    difference() {
        rounded_rect([RIM_LENGTH, RIM_WIDTH, RIM_HEIGHT]);
        translate([0, 0, -0.1]) rounded_rect([BASE_LENGTH - 1, BASE_WIDTH - 1, RIM_HEIGHT + 0.2]);
    }
}

module cover_shape() {
    translate([RIM_WIDTH/2, RIM_WIDTH/2, 0]) {
        base();
        translate([0, 0, HEIGHT - RIM_HEIGHT]) rim();
    }
}

module sd_card_slot() {
    cube([SD_CARD_LENGTH, SD_CARD_WIDTH, BASE_HEIGHT - 0.5]);
    translate([SD_CARD_BLIND_LENGTH, 0 , 0]) cube([SD_CARD_LENGTH - SD_CARD_BLIND_LENGTH, SD_CARD_WIDTH, 10]);
    translate([SD_CARD_LENGTH, 0 , 0]) cube([3, SD_CARD_WIDTH, 0.8]);
}

module serial_header() {
    cube([HEADER_LENGTH, HEADER_WIDTH, 10]);
}

module usb_c_receptacle() {
    double_rounded_rect([USB_C_LENGTH, USB_C_HEIGHT, 10], 1);
//    cube([USB_C_LENGTH, USB_C_HEIGHT, 10]);
}

module flap_retention() {
    rounded_rect_origin([FLAP_LENGTH, FLAP_WIDTH, 10]);
}

module screw_hole() {
    translate([SCREW_HOLE_TAPER_ID/2, SCREW_HOLE_TAPER_ID/2, 0]) {
        cylinder(10, SCREW_HOLE_TAPER_ID/2, SCREW_HOLE_TAPER_ID/2, $fn=100);
    }
    translate([SCREW_HOLE_TAPER_ID/2, SCREW_HOLE_TAPER_ID/2, 0]) {
        translate([0, 0, BASE_HEIGHT - SCREW_HOLE_TAPER_HEIGHT]) cylinder(SCREW_HOLE_TAPER_HEIGHT, SCREW_HOLE_TAPER_ID/2, SCREW_HOLE_TAPER_OD/2, $fn=100);
    }
}

module cover_features() {
    translate([6.8, 8.5, 0]) sd_card_slot();
    translate([7.5, 5.4, 0]) serial_header();
    translate([23.75, 7.25, 0]) usb_c_receptacle();
    translate([16, 2.5, 0]) flap_retention();
    translate([0, 3.2, 0]) {
        translate([4, 0, 0]) screw_hole();
        translate([RIM_LENGTH - 3.3 - SCREW_HOLE_TAPER_OD, 0, 0]) screw_hole();
    }
}

module serial_pin1_marker() {
    rotate([0, 0, -30]) cylinder(0.5, 1 ,1, $fn=3);
}

module cover_markings() {
    translate([0, 0, BASE_HEIGHT]) {
        //translate([8.5 + 1.75, 5.4 - 1.5, 0]) serial_pin1_marker();
        translate([7.5 + 0.3, 5.4 - 2.95, 0]) linear_extrude(height=0.5) text("GRT", 2.75, font="Droid Sans:style=Bold", spacing=1.22);
    }
}

module cover() {
    difference() {
        cover_shape();
        cover_features();
    }
    color("brown") cover_markings();
}

cover();