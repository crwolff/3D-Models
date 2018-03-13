$fn = 300;
//
// Double row of sockets
//
include <Sockets.scad>

// Configure the set
Selector = 0;
Name =      Sets[Selector][Name_Idx];
Shrinkage = Sets[Selector][Shrinkage_Idx];
OD_in =     Sets[Selector][OD_in_Idx];
PinD_in =   Sets[Selector][PinD_in_Idx];

// Parameters (mm)
Oversize = 0.4;             // Extra hole size
Sidewall = 2;               // Edge of hole to side
Gap = 0.1;                  // Extra space between sockets
Base = 2.5;                 // Base thickness
Wedge = 5;                  // Outer edge to start of wedge
Chamfer = 1;                // Chamfer on tops of pins
DepthPCT = 0.70;            // Pocket depth as percent of pin size

// Convert measurements to mm
OD_mm = OD_in * 25.4 * Shrinkage;   // Also adjust for shrinkage
PinD_mm = PinD_in * 25.4;           // Don't oversize the pins
Num = len(OD_mm);

// Compute pocket depth
Depth = max(PinD_mm) * DepthPCT;

// Radius of hole 'n'
function radius( n ) = (OD_mm[n-1] + Oversize)/2;

// Compute X location of hole n
function x_loc( n, row, gap, loc=0 ) =
    ( row == 1 ) ?
        ( n == 1 ) ?    // '1' is first hole
            loc + radius(n):
            x_loc(n-1,row,gap,loc) + radius( n - 1 ) + gap + radius( n ) :
        ( n == Num ) ?  // 'Num' is first hole
            loc + radius(n):
            x_loc(n+1,row,gap,loc) + radius( n + 1 ) + gap + radius( n );

// Length of a row of holes
function rowlength( first, last, gap=Gap ) =
    (x_loc(last,1,gap) + radius(last)) - (x_loc(first,1,gap) - radius(first));

// Compute best dividing point such that both rows are about the same length
function splitter( n=2, delta=0 ) =
    (rowlength(1,n) < rowlength(n+1,Num)) ? 
        splitter(n+1, rowlength(n+1,Num) - rowlength(1,n) ) :
        ((rowlength(1,n) - rowlength(n+1,Num)) < delta) ?
            n : n-1;

// Extra padding required to make both rows the same length
Mid = splitter();
diff = rowlength( 1, Mid ) - rowlength( Mid+1, Num );
//diff = 0;
Gap1 = (diff <= 0) ? Gap - ( diff / ( Mid - 1 ))         : Gap;
Gap2 = (diff >= 0) ? Gap + ( diff / ( Num - Mid - 1 ))   : Gap;

// Compute Y location of hole n
function y_loc( n, row, edge ) =
    (row == 1) ?
        edge + radius(n) :
        edge - radius(n);

// Compute distance between socket edges
function distance( s1, r1, s2, r2, maxY ) =
    sqrt( pow( x_loc( s1, r1, (r1==1)?Gap1:Gap2 ) - x_loc( s2, r2, (r2==1)?Gap1:Gap2 ), 2 ) +
          pow( y_loc( s1, r1, (r1==1)?0:maxY ) - y_loc( s2, r2, (r2==1)?0:maxY ), 2 )) -
          radius( s1 ) - radius( s2 );

// Find the minimum width so the rows have minimum spacing
function find_maxY( s1, s2, maxY ) =
    (s2 > Num) ?
        maxY :
        find_maxY( (s1==Mid) ? 1 : s1+1,
                   (s1==Mid) ? s2+1 : s2,
                   (distance( s1, 1, s2, 2, maxY ) < Gap) ?
                        maxY - (distance( s1, 1, s2, 2, maxY ) - Gap) :
                        maxY );
MaxY = find_maxY( 1, Mid+1, radius(1) );

// The model
union() {
    difference() {
        // Body
        linear_extrude( height = Base+Depth ) {
            hull() {
                translate([x_loc(1,1,Gap1),y_loc(1,1,0),0])
                    circle(r=radius(1)+Sidewall);
                translate([x_loc(Mid,1,Gap1),y_loc(Mid,1,0),0])
                    circle(r=radius(Mid)+Sidewall);
                translate([x_loc(Mid+1,2,Gap2),y_loc(Mid+1,2,MaxY),0])
                    circle(r=radius(Mid+1)+Sidewall);
                translate([x_loc(Num,2,Gap2),y_loc(Num,2,MaxY),0])
                    circle(r=radius(Num)+Sidewall);
            }
        }
        // Stuff to remove
        translate([0,0,Base])
        {
            linear_extrude( height = Depth+1 ) {
                // Row 1
                for(i=[1:Mid])
                    translate([x_loc(i,1,Gap1),y_loc(i,1,0),0])
                        circle(r=radius(i));
                // Row 2
                for(i=[Mid+1:Num])
                    translate([x_loc(i,2,Gap2),y_loc(i,2,MaxY),0])
                        circle(r=radius(i));
                // Small webs
                for(i=[1:Num-1]) {
                    for(j=[i+1:Num]) {
                        if ( distance( i, (i>Mid)?2:1, j, (j>Mid)?2:1, MaxY ) < 1.0 ) {
                            hull() {
                                translate([ x_loc(i, (i>Mid)?2:1, (i>Mid)?Gap2:Gap1),
                                            y_loc(i, (i>Mid)?2:1, (i>Mid)?MaxY:0), 0])
                                    circle(r=radius(i)-Wedge);
                                translate([ x_loc(j, (j>Mid)?2:1, (j>Mid)?Gap2:Gap1),
                                            y_loc(j, (j>Mid)?2:1, (j>Mid)?MaxY:0), 0])
                                    circle(r=radius(j)-Wedge);
                            }
                        }
                    }
                }
            }
        }
        translate([rowlength(1,Mid,Gap1)/2, MaxY/2, -0.1])
            mirror([0,1,0])
                linear_extrude( height=0.6 )
                    text( Name, size=8, font="Liberation Sans", $fn=16, valign="center", halign="center");

    }
    // Chamfered pins
    union() {
        for(i=[1:Num]) {
            translate([ x_loc(i, (i>Mid)?2:1, (i>Mid)?Gap2:Gap1),
                        y_loc(i, (i>Mid)?2:1, (i>Mid)?MaxY:0), Base])
                cylinder(h=PinD_mm[i-1] - Chamfer, r=PinD_mm[i-1]/2);
            translate([ x_loc(i, (i>Mid)?2:1, (i>Mid)?Gap2:Gap1),
                        y_loc(i, (i>Mid)?2:1, (i>Mid)?MaxY:0), Base + PinD_mm[i-1] - Chamfer])
                cylinder(h=Chamfer, r1=PinD_mm[i-1]/2, r2=PinD_mm[i-1]/2 - Chamfer);
        }
    }
}
