//!OpenSCAD

stockwidth = 89;
stockthickness = 19.5;
my_3DprevieworDXF = true;
$fa = 0.4;//0.2;
$fs = 0.4;//0.2;

nou = round(stockwidth / stockthickness - 0.5);
pindiameter = stockthickness / 4;
pinradius = pindiameter / 2;
covediameter = pindiameter * 3;
coveradius = covediameter / 2;
covespacing = (stockwidth - nou * covediameter) / nou;
csr = covespacing / 2;


if (my_3DprevieworDXF == true) {
  knappbox3d();
} else {
  projection(cut = true) knappboxjoint();
}


module knappbox3d() {
  union(){
    difference() {
      translate([0, (stockthickness / 2), 0]){
        union(){
          cube([stockwidth, (stockthickness * 4.5), stockthickness], center=false);
          translate([(covediameter / 2 + covespacing / 2), 0, 0]){
            for (i = [0 : abs(1) : nou - 1]) {
              translate([(covespacing * i + covediameter * i), 0, 0]){
                cylinder(r1=coveradius, r2=coveradius, h=stockthickness, center=false);
              }
            }

          }
        }
      }

      translate([(covediameter / 2 + covespacing / 2), (stockthickness / 2), 0]){
        for (i = [0 : abs(1) : nou - 1]) {
          translate([(covespacing * i + covediameter * i), 0, 0]){
            union(){
              cylinder(r1=pinradius, r2=pinradius, h=stockthickness, center=false);
              translate([(0 - (coveradius + csr)), 0, 0]){
                cylinder(r1=csr, r2=csr, h=stockthickness, center=false);
              }
              translate([(coveradius + csr), 0, 0]){
                cylinder(r1=csr, r2=csr, h=stockthickness, center=false);
              }
            }
          }
        }

      }
    }
    translate([0, (0 - stockthickness * 2), 0]){
      difference() {
        translate([0, 0, (0 - stockthickness * 4)]){
          cube([stockwidth, stockthickness, (stockthickness * 5)], center=false);
        }

        translate([(covediameter / 2 + covespacing / 2), (stockthickness / 2), 0]){
          for (i = [0 : abs(1) : nou - 1]) {
            translate([(covespacing * i + covediameter * i), 0, 0]){
              difference() {
                union(){
                  cylinder(r1=coveradius, r2=coveradius, h=stockthickness, center=false);
                  translate([(coveradius / 2 - covediameter * 1.05), 0, 0]){
                    cube([(covespacing + covediameter * 1.1), stockthickness, (stockthickness * 2)], center=false);
                  }
                }

                union(){
                  cylinder(r1=pinradius, r2=pinradius, h=stockthickness, center=false);
                  translate([(0 - (coveradius + csr)), 0, 0]){
                    cylinder(r1=csr, r2=csr, h=stockthickness, center=false);
                  }
                  translate([(coveradius + csr), 0, 0]){
                    cylinder(r1=csr, r2=csr, h=stockthickness, center=false);
                  }
                }
              }
            }
          }

        }
      }
    }
  }
}

module knappboxjoint() {
  difference() {
    translate([(0 - pindiameter), (0 - stockthickness * 2), 0]){
      difference() {
        union(){
          translate([pindiameter, 0, 0]){
            cube([stockwidth, (stockthickness * 3), (stockthickness / 2)], center=false);
          }
          translate([0, (stockthickness / 2 + covespacing / 2), 0]){
            cube([(stockwidth + pindiameter * 2), (stockthickness * 2), (stockthickness / 2)], center=false);
          }
        }

        translate([0, (stockthickness + 0), 0]){
          cube([(stockwidth + pindiameter * 2), (stockthickness - pinradius), (stockthickness * 2)], center=false);
        }
      }
    }

    knappbox3d();
  }
}

