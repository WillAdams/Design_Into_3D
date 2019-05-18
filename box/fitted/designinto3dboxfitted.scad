//!OpenSCAD
//
// Please use the Customizer to interact with this (if necessary, show it by clearing the checkbox in front of View | Hide Customizer), and close this Editor window.
// * [Overview] *
// Part
PARTNO = 0;// [0:All, 1:Top, 2:Bottom]

partspacing = 12.7;

$fn=45;

// Type of Corner
Boxshape = 0; //[1:Square, 0:Rounded]
Width = 50.8;
Length = 25.4;
Height = 12.7;
Thickness = 6.35;

/* [Dividers] */
// Thickness
dividers_thickness = 3.175;
// Number of dividers widthwise
dividers_widthwise = 2;
// Number of dividers lengthwise
dividers_lengthwise = 1;
// Large Compartment
largecompartment = 0;// [0:None,1:Lengthwise, 2:Widthwise, 0:None]

/* [Endmill Parameters] */
// Shape
endmillshape = 1;// [0:Ball, 1:Square]
diameter = 3.175;
depth = 25.4;

Clearance = 0.01;
module endmillcut(emcshape, emcdiameter, emcdepth) {
  emcshape = emcshape;
  emcdiameter = emcdiameter;
  emcdepth = emcdepth;
  emcradius = emcdiameter / 2;
  if (emcshape == 0) {
    emcadjdepth = emcdepth - emcradius;
    union(){
      translate([0, 0, emcradius]){
        sphere(r=emcradius);
      }
      translate([0, 0, emcradius]){
        cylinder(r1=emcradius, r2=emcradius, h=emcadjdepth, center=false);
      }
    }
  } else if (emcshape == 1) {
    translate([0, 0, 0]){
      cylinder(r1=emcradius, r2=emcradius, h=emcdepth, center=false);
    }
  }

}

module fittedbox() {
  if (PARTNO == 1) {
    lid();
  } else if (PARTNO == 2) {
    box();
  } else {
    union(){
      lid();
      box();
    }
  }

}

module lid() {
  translate([0, (Length + partspacing), 0]){
    difference() {
      if (Boxshape == 0) {
        pocketrect(0, 0, 0, 1, Thickness, Length, Width, Thickness);
      } else {
        cube([Width, Length, Thickness], center=false);
      }

      pocketrect(Thickness / 2 - halfclearance, Thickness / 2 - halfclearance, halfthickness, 1, halfthickness, (Length - Thickness) + halfclearance * 2, (Width - Thickness) + halfclearance * 2, Height);
    }
  }
}

module pocketrect(px, py, pbottom, endmillshape, pdiameter, plength, pwidth, pdepth) {
  pradius = pdiameter / 2;
  translate([px, py, pbottom]){
    hull(){
      translate([pradius, pradius, 0]){
        endmillcut(endmillshape, pdiameter, pdepth);
      }
      translate([(pwidth - pradius), pradius, 0]){
        endmillcut(endmillshape, pdiameter, pdepth);
      }
      translate([(pwidth - pradius), (plength - pradius), 0]){
        endmillcut(endmillshape, pdiameter, pdepth);
      }
      translate([pradius, (plength - pradius), 0]){
        endmillcut(endmillshape, pdiameter, pdepth);
      }
    }
  }
}

module box() {
  difference() {
    union(){
      if (Boxshape == 0) {
        pocketrect(0, 0, 0, 1, Thickness, Length, Width, Height - halfthickness);
      } else {
        cube([Width, Length, (Height - halfthickness)], center=false);
      }

      pocketrect(Thickness / 2 + halfclearance, Thickness / 2 + halfclearance, halfthickness, 1, halfthickness, (Length - Thickness) - halfclearance * 2, (Width - Thickness) - halfclearance * 2, Height - halfthickness);
    }

    for (i = [0 : abs(1) : dividers_widthwise]) {
      for (j = [0 : abs(1) : dividers_lengthwise]) {
        if (largecompartment == 1 && (i % 2 == 1 && j == 0)) {
          pocketrect((Thickness + pcwidth * i) + dividers_thickness * (i + 0), (Thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, intlength, pcwidth, Height);
        } else if (largecompartment == 2 && (j % 2 == 0 && i == 0)) {
          pocketrect((Thickness + pcwidth * i) + dividers_thickness * (i + 0), (Thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, pclength, intwidth, Height);
        } else {
          pocketrect((Thickness + pcwidth * i) + dividers_thickness * (i + 0), (Thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, pclength, pcwidth, Height);
        }

      }

    }

  }
}

halfthickness = Thickness / 2;
quarterthickness = Thickness / 4;
radius = diameter / 2;
adjdepth = depth - radius;
intwidth = Width - Thickness * 2;
intlength = Length - Thickness * 2;
pcwidth = (intwidth - dividers_thickness * dividers_widthwise) / (dividers_widthwise + 1);
pclength = (intlength - dividers_thickness * dividers_lengthwise) / (dividers_lengthwise + 1);
halfclearance = Clearance / 2;

fittedbox();
