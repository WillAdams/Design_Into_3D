//!OpenSCAD
//Please use the Customizer to interact with this (if necessary, show it by clearing the checkbox in front of View | Hide Customizer), and close this Editor window.

/* [Overview] */

//Part
PARTNO = "0"; // [0:All, 1:Top, 2:Bottom]

partspacing = 12.7;

$fn=45;

/* [Box Parameters] */

//Type of Corner
boxshape = "rounded"; // ["square":Square, "rounded":Rounded]
width = 50.8;
length = 50.8;
height = 12.7;
thickness = 6.35;

/* [Dividers] */
//Thickness
dividers_thickness = 3.175;
//Number of dividers lengthwise
dividers_lengthwise = 2;
//Number of dividers widthwise
dividers_widthwise = 1;
//Large Compartment
largecompartment = "widthwise"; // ["lengthwise":Lengthwise, "widthwise":Widthwise, "none":None]

/* [Endmill Parameters] */

//Shape
endmillshape = "ball";// ["ball":Ball, "square":Square]
diameter = 3.175;
depth = 25.4;


halfthickness = thickness / 2;
quarterthickness = thickness / 4;
radius = diameter / 2;
adjdepth = depth - radius;
intwidth = width - thickness * 2;
intlength = length - thickness * 2;
pcwidth = (intwidth - dividers_thickness * dividers_lengthwise) / (dividers_lengthwise + 1);
pclength = (intlength - dividers_thickness * dividers_widthwise) / (dividers_widthwise + 1);

module endmillcut(emcshape, emcdiameter, emcdepth) {
  emcshape = emcshape;
  emcdiameter = emcdiameter;
  emcdepth = emcdepth;
  emcradius = emcdiameter / 2;
  if (emcshape == "ball") {
    emcadjdepth = emcdepth - emcradius;
    union(){
      translate([0, 0, emcradius]){
        sphere(r=emcradius);
      }
      translate([0, 0, emcradius]){
        cylinder(r1=emcradius, r2=emcradius, h=emcadjdepth, center=false);
      }
    }
  } else if (emcshape == "square") {
    translate([0, 0, 0]){
      cylinder(r1=emcradius, r2=emcradius, h=emcdepth, center=false);
    }
  }

}

module lid() {
  translate([0, (length + partspacing), 0]){
    difference() {
      if (boxshape == "rounded") {
        pocketrect(0, 0, 0, "square", thickness, length, width, thickness);
      } else {
        cube([width, length, thickness], center=false);
      }

      pocketrect(thickness / 2, thickness / 2, halfthickness, "square", halfthickness, length - thickness, width - thickness, height);
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
      if (boxshape == "rounded") {
        pocketrect(0, 0, 0, "square", thickness, length, width, height - halfthickness);
      } else {
        cube([width, length, (height - halfthickness)], center=false);
      }

      pocketrect(thickness / 2, thickness / 2, halfthickness, "square", halfthickness, length - thickness, width - thickness, height - halfthickness);
    }

    for (i = [0 : abs(1) : dividers_lengthwise]) {
      for (j = [0 : abs(1) : dividers_widthwise]) {
        if (largecompartment == "lengthwise" && (i % 2 == 1 && j == 0)) {
          pocketrect((thickness + pcwidth * i) + dividers_thickness * (i + 0), (thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, intlength, pcwidth, height);
        } else if (largecompartment == "widthwise" && (j % 2 == 0 && i == 0)) {
          pocketrect((thickness + pcwidth * i) + dividers_thickness * (i + 0), (thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, pclength, intwidth, height);
        } else {
          pocketrect((thickness + pcwidth * i) + dividers_thickness * (i + 0), (thickness + pclength * j) + dividers_thickness * (j + 0), radius, endmillshape, diameter, pclength, pcwidth, height);
        }

      }

    }

  }
}


if (PARTNO == "1") lid();
if (PARTNO == "2") box();

// optionally use 0 for whole object

if (PARTNO == "0") {
box();
lid();
}
