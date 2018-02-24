$fn = 30;
//
// Single row of sockets
//

// Socket OD's (measured in inches)

// Metric 3/8" drive
OD_mm = [ 0.649, 0.658, 0.655, 0.678, 0.723, 0.775, 0.812, 0.862, 0.926, 0.952, 1.004 ] * 25.4;
PinD_mm = [ 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375 ] * 25.4;

// Parameters (mm)
Oversize = 0.4;     // Extra hole size
Sidewall = 2;       // Edge of hole to side
Gap = 0.1;          // Extra space between sockets
Depth = 6;          // Hole depth
Height = 8.6;       // Body height
Wedge = 6;          // Outer edge to start of wedge
Chamfer = 1;        // Chamfer on tops of pins

// Compute location of hole n
function location(n,loc=0) =
    n == 1 ?
        loc :
        location(n-1,loc) + 
            OD_mm[n-2]/2 + Oversize + Gap + Oversize + OD_mm[n-1]/2;

// 
union() {
    difference() {
        // Body
        union() {
            x0 = location(1);
            y0 = OD_mm[0]/2 + Oversize + Sidewall;
            x1 = location(len(OD_mm));
            y1 = OD_mm[len(OD_mm)-1]/2 + Oversize + Sidewall;
            translate([x0,0,0])
                cylinder(h=Height,r=y0);
            translate([x1,0,0])
                cylinder(h=Height,r=y1);
            points = [[x0,-y0,0],
                      [x1,-y1,0],
                      [x1,y1,0],
                      [x0,y0,0],
                      [x0,-y0,Height],
                      [x1,-y1,Height],
                      [x1,y1,Height],
                      [x0,y0,Height]];
            faces = [[0,1,2,3],  // bottom
                     [4,5,1,0],  // front
                     [7,6,5,4],  // top
                     [5,6,2,1],  // right
                     [6,7,3,2],  // back
                     [7,4,0,3]]; // left
            polyhedron( points, faces );
        }
        // Holes
        union() {
            // Holes
            for(i=[1:1:len(OD_mm)]) {
                translate([location(i), 0, Height-Depth])
                    cylinder(h=Depth+1,d=OD_mm[i-1] + Oversize);
            }
            // Remove webs
            x0 = location(1);
            y0 = OD_mm[0]/2 + Oversize + Sidewall - Wedge;
            x1 = location(len(OD_mm));
            y1 = OD_mm[len(OD_mm)-1]/2 + Oversize + Sidewall - Wedge;
            points = [[x0,-y0,0],
                      [x1,-y1,0],
                      [x1,y1,0],
                      [x0,y0,0],
                      [x0,-y0,Height],
                      [x1,-y1,Height],
                      [x1,y1,Height],
                      [x0,y0,Height]];
            faces = [[0,1,2,3],  // bottom
                     [4,5,1,0],  // front
                     [7,6,5,4],  // top
                     [5,6,2,1],  // right
                     [6,7,3,2],  // back
                     [7,4,0,3]]; // left
            translate([0,0,Height-Depth])
                polyhedron( points, faces );
        }
    }
    // Chamfered pins
    union() {
        for(i=[1:1:len(OD_mm)]) {
            translate([location(i), 0, Height - Depth])
                cylinder(h=PinD_mm[i-1] - Chamfer, r=PinD_mm[i-1]/2);
        }
        for(i=[1:1:len(OD_mm)]) {
            translate([location(i), 0, Height - Depth + PinD_mm[i-1] - Chamfer])
                cylinder(h=Chamfer, r1=PinD_mm[i-1]/2, r2=PinD_mm[i-1]/2 - Chamfer);
        }
    }
}
