$fn = 300;
//
// Single row of sockets
//

// Configure the set
Selector = 10;
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
PinD_mm = PinD_in * 25.4;           // Don't oversize the pins

// Compute pocket depth
Depth = max(PinD_mm) * DepthPCT;

// Compute location of hole n
function location(n,loc=0) =
    n == 1 ?
        loc :
        location(n-1,loc) + 
            OD_mm[n-2]/2 + Oversize + Gap + Oversize + OD_mm[n-1]/2;

// Compute length of a row of sockets
function rowlength( first, last ) =
    (location(last) + OD_mm[last-1]/2) - (location(first) - OD_mm[first-1]/2);
            
// 
union() {
    difference() {
        // Body
        union() {
            x0 = location(1);
            y0 = OD_mm[0]/2 + Oversize + Sidewall;
            x1 = location(len(OD_mm));
            y1 = OD_mm[len(OD_mm)-1]/2 + Oversize + Sidewall;
            z0 = 0;
            z1 = Base + Depth;
            linear_extrude( height=z1 )
                hull() {
                    translate([x0,0,0])
                        circle(r=y0);
                    translate([x1,0,0])
                        circle(r=y1);
                }
        }
        // Holes
       union() {
            // Holes
            for(i=[1:1:len(OD_mm)]) {
                translate([location(i), 0, Base])
                    cylinder(h=Depth+1,d=OD_mm[i-1] + Oversize);
            }
            // Remove webs
            x0 = location(1);
            y0 = OD_mm[0]/2 + Oversize + Sidewall - Wedge;
            x1 = location(len(OD_mm));
            y1 = OD_mm[len(OD_mm)-1]/2 + Oversize + Sidewall - Wedge;
            z0 = Base;
            z1 = Base + Depth + 1;
            translate([0,0,Base])
                linear_extrude( height = Depth + 1)
                    hull() {
                        translate([x0,0,0])
                            circle(r=y0);
                        translate([x1,0,0])
                            circle(r=y1);
                    }
        }
        translate([rowlength(1,len(OD_mm))/2-OD_mm[0]/2, 0, -0.1])
            mirror([0,1,0])
                linear_extrude( height=0.6 )
                    text( Name, size=6, font="Bitstream Vera Sans:style=Bold", $fn=16, valign="center", halign="center");
    }
    // Chamfered pins
    union() {
        for(i=[1:1:len(OD_mm)]) {
            translate([location(i), 0, Base])
                cylinder(h=PinD_mm[i-1] - Chamfer, r=PinD_mm[i-1]/2);
        }
        for(i=[1:1:len(OD_mm)]) {
            translate([location(i), 0, Base + PinD_mm[i-1] - Chamfer])
                cylinder(h=Chamfer, r1=PinD_mm[i-1]/2, r2=PinD_mm[i-1]/2 - Chamfer);
        }
    }
}
