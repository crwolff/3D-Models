$fn = 300;
//
// Single row of sockets
//

// Configure the set
Selector = 22;
include <Sockets.scad>

// Parameters (mm)
Oversize = 0.4;             // Extra hole size
Sidewall = 2;               // Edge of hole to side
Gap = 0.1;                  // Extra space between sockets
Base = 2.5;                 // Base thickness
Wedge = 6;                  // Outer edge to start of wedge
Chamfer = 1;                // Chamfer on tops of pins
DepthPCT = 0.70;            // Pocket depth as percent of pin size

// Convert measurements to mm
OD_mm = OD_in * 25.4 * Shrinkage;   // Also adjust for shrinkage
OD2_mm = OD2_in * 25.4 * Shrinkage;
Len_mm = Len_in * 25.4 * Shrinkage;
Len2_mm = Len2_in * 25.4 * Shrinkage;
Num = len(OD_mm);

// Compute location of hole n
function location(n,loc=0) =
    n == 1 ?
        loc :
        location(n-1,loc) + 
            (OD_mm[n-2] + Oversize)/2 + Gap + (OD_mm[n-1] + Oversize)/2;

// Locate corners
x0 = location(1) - (OD_mm[0] + Oversize)/2 - Sidewall;
y0 = -Sidewall;
x1 = location(Num) + (OD_mm[Num-1] + Oversize)/2 + Sidewall;
y1 = Len_mm + Sidewall;

// The model
difference() {
    // Body
    linear_extrude(height = max(OD_mm) / 2 + Base) {
        hull() {

            translate([ x0+0.5, y0+0.5, 0 ]) circle(r=0.5);
            translate([ x0+0.5, y1-0.5, 0 ]) circle(r=0.5);
            translate([ x1-0.5, y1-0.5, 0 ]) circle(r=0.5);
            translate([ x1-0.5, y0+0.5, 0 ]) circle(r=0.5);
        }
        
    }
    // Removals
    union() {
        // Socket Pockets
        for(i=[1:len(OD_mm)]) {
            translate([ location(i), 
                        0,
                        max(OD_mm)/2 + Oversize + Base ])
                rotate([-90,90,0])
                    cylinder(d=OD_mm[i-1] + Oversize,
                             h=Len_mm - Len2_mm);
            translate([ location(i), 
                        Len_mm,
                        max(OD_mm)/2 + Oversize + Base ])
                rotate([90,90,0])
                    cylinder(d=OD2_mm[i-1] + Oversize,
                             h=Len_mm - Len2_mm);
        }
        // Remove webs
        translate([0,0,max(OD_mm)/2])
            cube([location(Num)-location(1), Len_mm, 2*Base]);
        // Label
        translate([x0 + (x1-x0)/2, y0 + (y1-y0)/2, -0.1])
            mirror([0,1,0])
                linear_extrude( height=0.6 )
                    text( Name, size=6, font="Bitstream Vera Sans:style=Bold", $fn=16, 
                            valign="center", halign="center");

    }
}
