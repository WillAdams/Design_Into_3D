//!OpenSCAD

BoxWidth = 175;
BoxDepth = 100;
BoxHeight = 33;
StockThickness = 5;
SkinThickness = 0.635;
VendmillDiameter = 3.175;
PocketEndmillDiameter = 6.35;
ExportVcuts = false;
ExportPocketCuts = false;

$fn = 360;

vendmillradius = VendmillDiameter / 2;
pocketendmillradius = PocketEndmillDiameter / 2;

module pocketcut(width, depth, xorigin, yorigin, xend, yend) {
  hull(){
    translate([xorigin, yorigin, (0 - depth)]){
      cube([width, width, StockThickness], center=false);
    }
    translate([xend, yend, (0 - depth)]){
      cube([width, width, StockThickness], center=false);
    }
  }
}

module vcut(diameter, depth, xorigin, yorigin, xend, yend) {
  radius = diameter / 2;
  hull(){
    translate([xorigin, yorigin, (0 - depth)]){
      union(){
        translate([0, 0, radius]){
          cylinder(r1=radius, r2=radius, h=StockThickness, center=false);
        }
        cylinder(r1=0, r2=radius, h=vendmillradius, center=false);
      }
    }
    translate([xend, yend, (0 - depth)]){
      union(){
        translate([0, 0, radius]){
          cylinder(r1=radius, r2=radius, h=StockThickness, center=false);
        }
        cylinder(r1=0, r2=radius, h=vendmillradius, center=false);
      }
    }
  }
}

module vcuts() {
  union(){
    vcut(VendmillDiameter, StockThickness - SkinThickness, BoxHeight, 0 - vendmillradius, BoxHeight, (BoxDepth + BoxHeight * 2) + 0);
    vcut(VendmillDiameter, StockThickness - SkinThickness, BoxHeight + BoxWidth, 0 - vendmillradius, BoxHeight + BoxWidth, (BoxDepth + BoxHeight * 2) + 0);
    vcut(VendmillDiameter, StockThickness - SkinThickness, 0 - vendmillradius, BoxHeight, (BoxWidth + BoxHeight * 2) + 0, BoxHeight);
    vcut(VendmillDiameter, StockThickness - SkinThickness, 0 - vendmillradius, BoxDepth + BoxHeight, BoxWidth + (BoxHeight * 2 + 0), BoxDepth + BoxHeight);
  }
}

module pocketcuts() {
  union(){
    pocketcut(StockThickness, StockThickness - (vendmillradius + SkinThickness), (BoxHeight - StockThickness) + vendmillradius, 0 - pocketendmillradius, (BoxHeight - StockThickness) + vendmillradius, (BoxDepth + BoxHeight * 2) - VendmillDiameter);
    pocketcut(StockThickness, StockThickness - (vendmillradius + SkinThickness), (BoxHeight + BoxWidth) - vendmillradius, 0 - pocketendmillradius, (BoxHeight + BoxWidth) - vendmillradius, (BoxDepth + BoxHeight * 2) - VendmillDiameter);
    pocketcut(StockThickness, StockThickness - (vendmillradius + SkinThickness), 0 - pocketendmillradius, (BoxHeight - StockThickness) + vendmillradius, (BoxWidth + BoxHeight * 2) - VendmillDiameter, (BoxHeight - StockThickness) + vendmillradius);
    pocketcut(StockThickness, StockThickness - (vendmillradius + SkinThickness), 0 - pocketendmillradius, (BoxHeight + BoxDepth) - vendmillradius, (BoxWidth + BoxHeight * 2) - VendmillDiameter, (BoxHeight + BoxDepth) - vendmillradius);
  }
}

if (ExportVcuts == true) {
  projection (cut = true) {vcuts();}
} else if (ExportPocketCuts == true) {
  projection (cut = true) {pocketcuts();}
} else {
  difference() {
    translate([0, 0, (0 - StockThickness)]){
      cube([(BoxWidth + BoxHeight * 2), (BoxDepth + BoxHeight * 2), StockThickness], center=false);
    }

    vcuts();
    pocketcuts();
  }
}
