//!OpenSCAD

$fa = 1;
marbleorpin = 1;
gamepiecediameter = 13;
gamepiecespacing = 18;
stockthickness = 13;
gamepieceradius = gamepiecediameter / 2;
gamepiecedepthorproportion = 3;
showgamepiece = 0;
compartments = 1;
surroundspacing = 0.5;
border = 1;
borderstyle = "V";
borderthickness = 0.5;
endmillangle = 60;
DXF = 0;

module Vline() {
  hull(){
    translate([0, ((gamepiecespacing * 9) * cos(30)), 0]){
      V();
    }
    rotate([0, 0, 120]){
      translate([0, ((gamepiecespacing * 9) * cos(30)), 0]){
        V();
      }
    }
  }
}

module V() {
  cylinder(r1=0, r2=(borderthickness / 2), h=((borderthickness / 2) / tan(30)), center=false);
}

module gamepiece() {
  if (marbleorpin == 1) {
    translate([0, 0, (gamepieceradius / gamepiecedepthorproportion)]){
      sphere(r=gamepieceradius);
    }
  } else {
    translate([0, 0, (gamepiecedepthorproportion * -1)]){
      cylinder(r1=gamepieceradius, r2=gamepieceradius, h=(gamepieceradius * 3), center=false);
    }
  }

}

module ccboard() {
union(){
  difference() {
    cylinder(r1=(gamepiecespacing * (7.5 + surroundspacing)), r2=(gamepiecespacing * (7.5 + surroundspacing)), h=stockthickness, center=false);

    translate([0, 0, stockthickness]){
      gamepiece();
    }
    translate([0, 0, stockthickness]){
      for (j = [0 : abs(1) : 5]) {
        rotate([0, 0, (60 * j)]){
          union(){
            translate([(gamepiecespacing / 2), (gamepiecespacing * cos(30)), 0]){
              for (i = [0 : abs(1) : 1]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([gamepiecespacing, ((gamepiecespacing * 2) * cos(30)), 0]){
              for (i = [0 : abs(1) : 2]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([(gamepiecespacing * 1.5), ((gamepiecespacing * 3) * cos(30)), 0]){
              for (i = [0 : abs(1) : 3]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([(gamepiecespacing * 2), ((gamepiecespacing * 4) * cos(30)), 0]){
              for (i = [0 : abs(1) : 4]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([(gamepiecespacing * 1.5), ((gamepiecespacing * 5) * cos(30)), 0]){
              for (i = [0 : abs(1) : 3]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([gamepiecespacing, ((gamepiecespacing * 6) * cos(30)), 0]){
              for (i = [0 : abs(1) : 2]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([(gamepiecespacing / 2), ((gamepiecespacing * 7) * cos(30)), 0]){
              for (i = [0 : abs(1) : 1]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([0, (gamepiecespacing * 7), 0]){
              gamepiece();
            }
          }
        }
      }

    }
    for (k = [0 : abs(1) : 5]) {
      rotate([0, 0, (60 * k)]){
        translate([0, 0, (stockthickness * 1.01 - (borderthickness / 2) / tan(30))]){
          Vline();
        }
      }
    }

    if (compartments * surroundspacing > 0.9) {
      for (o = [0 : abs(1) : 5]) {
        rotate([0, 0, (30 + 60 * o)]){
          hull(){
            translate([0, (gamepiecespacing * 5.5), stockthickness]){
              sphere(r=gamepieceradius);
            }
            rotate([0, 0, (-30 + atan((gamepiecespacing * 1.5) / (gamepiecespacing * 7)))]){
              translate([0, (gamepiecespacing * 7), stockthickness]){
                sphere(r=gamepieceradius);
              }
            }
            rotate([0, 0, (30 - atan((gamepiecespacing * 1.5) / (gamepiecespacing * 7)))]){
              translate([0, (gamepiecespacing * 7), stockthickness]){
                sphere(r=gamepieceradius);
              }
            }
            translate([0, (gamepiecespacing * (7 + surroundspacing) - gamepiecespacing / 2), stockthickness]){
              sphere(r=gamepieceradius);
            }
          }
        }
      }

    } else if (compartments * surroundspacing == 0) {

    } else if (compartments * surroundspacing <= 0.9) {
      for (m = [0 : abs(1) : 5]) {
        rotate([0, 0, (30 + 60 * m)]){
          hull(){
            translate([0, (gamepiecespacing * 5.5), stockthickness]){
              sphere(r=gamepieceradius);
            }
            for (n = [-30 + atan((gamepiecespacing * 1.5) / (gamepiecespacing * 7)) : abs(1) : 30 - atan((gamepiecespacing * 1.5) / (gamepiecespacing * 7))]) {
              rotate([0, 0, (n * 1)]){
                translate([0, (gamepiecespacing * 7), stockthickness]){
                  sphere(r=gamepieceradius);
                }
              }
            }

          }
        }
      }

    }

  }
  if (showgamepiece == 1) {
    translate([0, 0, stockthickness]){
      for (j = [0 : abs(1) : 5]) {
        rotate([0, 0, (60 * j)]){
          union(){
            translate([(gamepiecespacing * 1.5), ((gamepiecespacing * 5) * cos(30)), 0]){
              for (i = [0 : abs(1) : 3]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([gamepiecespacing, ((gamepiecespacing * 6) * cos(30)), 0]){
              for (i = [0 : abs(1) : 2]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([(gamepiecespacing / 2), ((gamepiecespacing * 7) * cos(30)), 0]){
              for (i = [0 : abs(1) : 1]) {
                translate([(gamepiecespacing * (i * -1)), 0, 0]){
                  gamepiece();
                }
              }

            }
            translate([0, (gamepiecespacing * 7), 0]){
              gamepiece();
            }
          }
        }
      }

    }
  }

}
}

if (DXF == 1) {
projection(cut = true) translate([0,0,-stockthickness*0.999]) ccboard();}
else
{translate([0,0,-stockthickness]) ccboard();}
