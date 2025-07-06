// Pull handle for DEC Flip Chip modules
// Open the Customiser pane to change: 
//      module number
//      mould release taper
//      logo labelling / style
// written by Steve M    2021
// Last updated 20250706

MODULE_NUMBER = "W005";     // Use empty string for no label
TEXT_HEIGHT = 2.4; // was 2.4; // Module #
CONVERGENCE_POINT_Z = 800; // sides converge a this distance
LOGO_STYLE = "Old"; // ["Old", "New", "None"]

module HideTheFollowingFromCustomiser() {}
HANDLE_WIDTH = 12;

// The model proper
NumberedHandle();
if (LOGO_STYLE == "Old")
    PositionOlderDigitalLogo();
if (LOGO_STYLE == "New")
    PositionNewerDigitalLogo();

// Test model components
//BridgeHalf();
//Wedge();
//FlipchipNumber();
//OlderDigitalLogo();
//NewerDigitalLogo();

$fn=120;    // # facets on curved edges

module NumberedHandle()
{
    difference()
    {
        BlankHandle();
        FlipchipNumber();
    }
}

module BlankHandle()
{
    difference()
    {
        Tapers();
        translate([-50, -50, HANDLE_WIDTH])
            cube([100, 100, 1000]); // removes convergence
        RivetHoles();
    }
}

module Tapers()
{
    TaperHalf();
    mirror([10, 0, 0])
        TaperHalf();
}

module TaperHalf()
{
    TaperOuter();
    TaperInner();    
    Wedge();
    BridgeHalf();
}

module TaperOuter()
{
    hull()
    {
        linear_extrude(0.001)
            OuterTemplate();
        ConvergencePoint();   
    }
}

module OuterTemplate()
{
    outerGripPoints = [
                        [6, 0], [12.83, 3.93],
                        [14.02, 2.15], [6.24, -3.88]
                      ];
    polygon(outerGripPoints);
    translate([13.36, 3.0])
        circle(r = 1.07);
}

module TaperInner()
{
    hull()
    {
        linear_extrude(0.001)
            InnerTemplate();
        ConvergencePoint();   
    }
}

module InnerTemplate()
{
    innerGripPoints = [ [0,0], [6,0], [6.24,-3.88], [0,-3.88] ];
    polygon(innerGripPoints);    
}

module Wedge()
{
    translate([6, -3.88, 0])
        rotate([90, 0, 270])
            linear_extrude(1.81)
                CornerCutTriangle();
}

module BridgeHalf()
{
    translate([0, -6.77 - 11.64, 0])
        cube([61.84 / 2, 11.64, 2.08]);

    translate([4.42, -6.77 - 2.08, 0])
        cube([26.5, 2.08, 3.95]);
    
    // Small filler piece inside pull handle
    translate([0, -6.77, 0])
        cube([4.5, 6.77, 2.08]);
}

// The tapered sides of the handle part conincide
// at a vanishing point
module ConvergencePoint()
{
    translate([0, -10, CONVERGENCE_POINT_Z])
        linear_extrude(0.001)
            circle(r = 0.001);
}

module FlipchipNumber()
{  
    zPos = (len(MODULE_NUMBER) == 4) ? 2 : 1;
    translate([-1.2, -1, zPos])
        rotate([90, 270, 180])
            linear_extrude(1.2)
                text(MODULE_NUMBER, size=TEXT_HEIGHT);
}

module RightTriangle(height, base)
{
    polygon([ [0, 0], [0, height], [base,0] ]);
}

module CornerCutTriangle()
{
    polygon([ [0, 0], [0, 11.6], [4.97, 3.95], [4.97, 0] ]);
}

module RivetHoles()
{
    translate([24.2, -13.82, 0])
        cylinder(d=2.6, h=99);
    translate([-24.2, -13.82, 0])
        cylinder(d=2.6, h=99);    
}

module OlderDigitalLogo()
{
    translate([-25.7, 0, 0])
    {
        t1 = "DIGITAL EQUIPMENT CORPORATION";
        translate([0, 0, 0])
            linear_extrude(0.2)
                scale([1.43, 1, 1])
                    text(t1, size=1.5);
        t2 = "MAYNARD, MASSACHUSETTS";
        translate([5, -8, 0])
            linear_extrude(0.2)
                scale([1.43, 1, 1])
                    text(t2, size=1.5);    
    }
}

module PositionOlderDigitalLogo()
{
    translate([0, -9.2, 0])
        rotate([0, 180, 0])
            OlderDigitalLogo();
}

module NewerDigitalLogo()
{
    t = "digital";
    scale([0.60, .9, .6])
        for (x = [0 : len(t) - 1])
        {
            echo(t[x]);
            translate([x*3, 0, 0])
                difference()
                {
                     cube([2.5, 4, .5]);
                    translate([0.7, 1, 0])
                        linear_extrude(5)
                            text(t[x], size=2);
                }
        }
}

module PositionNewerDigitalLogo()
{
    translate([6.1, -10.8, 0])
        rotate([0, 180, 0])
            NewerDigitalLogo();
}
