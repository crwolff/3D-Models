
$fn = 90;
difference() {
    rotate_extrude()
        scale([25.4,25.4,25.4])
            polygon( points=[[0.25,0],[0.625,0],[0.625,0.21],[0.58,0.21],[0.58,0.45],[0.565,0.45],[0.565,2],[0.25,2],[0.25,0]] );
    union() {
        translate([ 11,  0, 0]) cylinder( h=51, d=4.83 );
        translate([-11,  0, 0]) cylinder( h=51, d=4.83 );
        translate([  0, 11, 0]) cylinder( h=51, d=4.83 );
        translate([  0,-11, 0]) cylinder( h=51, d=4.83 );
        hull() {
            linear_extrude(7.5) square(14, center=true);
            translate([0,0,9.5]) linear_extrude(0.1) circle(6.25);
        }
    }
}