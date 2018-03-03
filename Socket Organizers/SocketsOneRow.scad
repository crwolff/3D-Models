$fn = 300;
//
// Single row of sockets
//

// Socket OD's (measured in inches)

// Craftsman 11 piece metric 3/8" drive
OD_mm = [ 0.649, 0.658, 0.655, 0.678, 0.723, 0.775, 0.812, 0.862, 0.926, 0.952, 1.004 ] * 25.4;
PinD_mm = [ 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375 ] * 25.4;

// Parameters (mm)
Shrinkage = 1.03;           // Adjust for 3% shrinkage in X/Y
Oversize = 0.4;             // Extra hole size
Sidewall = 2;               // Edge of hole to side
Gap = 0.1;                  // Extra space between sockets
Base = 2.5;                 // Base thickness
Depth = max(PinD_mm) * 0.70;// Depth of pockets
Wedge = 6;                  // Outer edge to start of wedge
Chamfer = 1;                // Chamfer on tops of pins

// Compute location of hole n
function location(n,loc=0) =
    n == 1 ?
        loc :
        location(n-1,loc) + 
            OD_mm[n-2]/2 + Oversize + Gap + Oversize + OD_mm[n-1]/2;
            
// Draw a wedge
module wedge(x0,y0,z0,x1,y1,z1)
{
    polyhedron( [[x0,-y0,z0],[x1,-y1,z0],[x1,y1,z0],[x0,y0,z0],
                 [x0,-y0,z1],[x1,-y1,z1],[x1,y1,z1],[x0,y0,z1]],
                [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                 [5,6,2,1],[6,7,3,2],[7,4,0,3]] );
}

// 
scale([Shrinkage,Shrinkage,1.00]) {
    difference() {
        // Body
        union() {
            x0 = location(1);
            y0 = OD_mm[0]/2 + Oversize + Sidewall;
            x1 = location(len(OD_mm));
            y1 = OD_mm[len(OD_mm)-1]/2 + Oversize + Sidewall;
            z0 = 0;
            z1 = Base + Depth;
            translate([x0,0,0])
                cylinder(h=z1,r=y0);
            translate([x1,0,0])
                cylinder(h=z1,r=y1);
            wedge(x0,y0,z0,x1,y1,z1);
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
            wedge(x0,y0,z0,x1,y1,z1);
        }
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
