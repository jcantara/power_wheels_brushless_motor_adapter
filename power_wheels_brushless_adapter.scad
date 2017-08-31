// Variable definitions for adjustment for particular vehicle
motor_plate_thickness = 5; // mm

// hub is the round section that "inserts" into the PW transmission from the motor
hub_diameter = 15;
hub_thickness = 7;

axle_hole_diameter = 5; // hole for motor axle

power_wheels_bolt_thread_diameter = 2;
power_wheels_nut_flat_width = 4; // semi-captive nut for stock PW bolt to screw into and hold motor plate
power_wheels_bolt_hole_separation = 20; // center-to-center distance of PW bolts

brushless_bolt_thread_diameter = 3;
brushless_bolt_count = 4; // or 2 or 3 depending on motor
brushless_bolt_separation = 30; // center-to-center diameter of brushless mount holes 

// designed with 3d-printing in mind, brushless-facing side of motor plate is mostly flat for print surface

// construct the object as a difference of the individual unions of positive shapes and negative holes
difference() {
    union() { // Positive shapes
        // motor plate
        linear_extrude(motor_plate_thickness) {
            motor_plate_diameter = brushless_bolt_separation + brushless_bolt_thread_diameter + motor_plate_thickness;
            circle(d=motor_plate_diameter);
        }
        // hub
        linear_extrude(hub_thickness + motor_plate_thickness) {
            circle(d=hub_diameter);
        }
    }
    union() { // Negative holes
        // move down one mm and make all holes longer than object for clearance
        translate([0,0,-1]) {
            hole_depth = motor_plate_thickness + hub_thickness + 2; // all holes through entire object + more
            // axle hole
            linear_extrude(hole_depth) {
                circle(d=axle_hole_diameter);
            }
            // PW bolt holes
            linear_extrude(hole_depth) {
                translate([power_wheels_bolt_hole_separation/2,0,0]) {
                    circle(d=power_wheels_bolt_thread_diameter);
                }
                translate([-power_wheels_bolt_hole_separation/2,0,0]) {
                    circle(d=power_wheels_bolt_thread_diameter);
                }
            }
            // PW bolt nut hexagonal captive hole
            linear_extrude(motor_plate_thickness/2 + 1) {
                translate([power_wheels_bolt_hole_separation/2,0,0]) {
                    hexagon(power_wheels_nut_flat_width);
                }
                translate([-power_wheels_bolt_hole_separation/2,0,0]) {
                    hexagon(power_wheels_nut_flat_width);
                }
            }
            // brushless motor bolt holes
            for(rotate_amount=[0:360/brushless_bolt_count:359]){
                rotate([0,0,rotate_amount + 360/8]){
                    echo("my rotation amount is: ", rotate_amount);
                    translate([brushless_bolt_separation/2,0,0]){
                        linear_extrude(hole_depth){
                            circle(d=brushless_bolt_thread_diameter);
                        }
                    }
                }
            }
        }
    }
}

module hexagon(flat_width) {
    circle_diameter = flat_width * sqrt(3);
    circle($fn=6, d=circle_diameter);
}