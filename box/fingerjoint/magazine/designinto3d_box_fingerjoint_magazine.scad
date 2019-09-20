//!OpenSCAD

Thickness = 5;
Width = 85;
Depth = 260;
Height = 310;
PartSpacing = 15;
FrontAngleProportion = 25;
BackAngleProportion = 20;
EndmillDiameter = 0.125;
View = 0;

module Front() {
  union(){
    translate([Thickness, Thickness, 0]){
      cube([Width, (Height / (100 / FrontAngleProportion)), Thickness], center=false);
    }
    translate([Thickness, 0, 0]){
      fjointwchamferall(Thickness, Width, EndmillDiameter, "even");
    }
    rotate([0, 0, 270]){
      translate([(0 - (Height / (100 / FrontAngleProportion) + Thickness)), 0, 0]){
        fjointwithchamferstedge(Thickness, Height / (100 / FrontAngleProportion) + Thickness, EndmillDiameter, "even");
      }
    }
    translate([(Width + Thickness * 2), 0, 0]){
      rotate([0, 0, 90]){
        fjointwithchamferstedge(Thickness, Height / (100 / FrontAngleProportion) + Thickness, EndmillDiameter, "even");
      }
    }
  }
}

module Back() {
  union(){
    translate([Thickness, Thickness, 0]){
      cube([Width, Height, Thickness], center=false);
    }
    translate([Thickness, 0, 0]){
      fjointwchamferall(Thickness, Width, EndmillDiameter, "even");
    }
    translate([0, (Height + Thickness * 1), 0]){
      rotate([0, 0, 270]){
        fjointwithchamferstedge(Thickness, Height + Thickness * 1, EndmillDiameter, "even");
      }
    }
    translate([(Width + Thickness * 2), 0, 0]){
      rotate([0, 0, 90]){
        fjointwithchamferstedge(Thickness, Height + Thickness * 1, EndmillDiameter, "even");
      }
    }
  }
}

module roundpocket(rpwidth, rpdepth, rpthickness, rpendmilldiameter) {
  rpradius = rpendmilldiameter / 2;
  difference() {
    hull(){
      translate([rpradius, rpradius, 0]){
        cylinder(r1=rpradius, r2=rpradius, h=rpthickness, center=false);
      }
      translate([rpradius, (rpdepth - rpradius), 0]){
        cylinder(r1=rpradius, r2=rpradius, h=rpthickness, center=false);
      }
      translate([(rpwidth - rpradius), rpradius, 0]){
        cylinder(r1=rpradius, r2=rpradius, h=rpthickness, center=false);
      }
      translate([(rpwidth - rpradius), (rpdepth - rpradius), 0]){
        cylinder(r1=rpradius, r2=rpradius, h=rpthickness, center=false);
      }
    }

    hull(){
      translate([0, 0, (rpthickness * 2)]){
        cylinder(r1=0, r2=(rpendmilldiameter * 20), h=rpendmilldiameter, center=false);
      }
      translate([0, (rpthickness + rpendmilldiameter / 2), (rpthickness * 2)]){
        cylinder(r1=0, r2=rpendmilldiameter, h=rpendmilldiameter, center=false);
      }
    }
  }
}

module fjoint(fjthickness, fjlength, fjendmilldiameter, fjoddoreven) {
  calcnumberofpins = ceil(fjlength / (fjthickness + fjendmilldiameter));
  difference() {
    translate([0, 0, 0]){
      cube([fjlength, fjthickness, fjthickness], center=false);
    }

    if (calcnumberofpins % 2 == 0) {
      pinwidth = fjlength / (calcnumberofpins + 1);
      for (j = [0 : abs(1) : calcnumberofpins]) {
        translate([(j * pinwidth), (0 - fjendmilldiameter / 2), (0 - fjendmilldiameter / 2)]){
          if (j % 2 == 1 && fjoddoreven == "even" || j % 2 == 0 && fjoddoreven == "odd") {
            union(){
              roundpocket(pinwidth, fjthickness + fjendmilldiameter / 2, fjthickness * 2, fjendmilldiameter);
              if (j == 0) {
                cube([(fjendmilldiameter / 2), (fjthickness + fjendmilldiameter / 2), (fjthickness + fjendmilldiameter * 2)], center=false);
              } else if (j == calcnumberofpins) {
                translate([(pinwidth - fjendmilldiameter / 2), 0, 0]){
                  cube([(fjendmilldiameter / 2), (fjthickness + fjendmilldiameter / 2), (fjthickness + fjendmilldiameter * 2)], center=false);
                }
              }

            }
          }

        }
      }

    } else {
      numberofpins = calcnumberofpins;  pinwidth = fjlength / calcnumberofpins;
      for (j = [0 : abs(1) : calcnumberofpins - 1]) {
        translate([(j * pinwidth), (0 - fjendmilldiameter / 2), (0 - fjthickness / 2)]){
          if (j % 2 == 1 && fjoddoreven == "even" || j % 2 == 0 && fjoddoreven == "odd") {
            union(){
              roundpocket(pinwidth, fjthickness + fjendmilldiameter / 2, fjthickness * 2, fjendmilldiameter);
              if (j == 0) {
                cube([(fjendmilldiameter / 2), (fjthickness + fjendmilldiameter / 2), (fjthickness + fjendmilldiameter * 2)], center=false);
              } else if (j == calcnumberofpins - 1) {
                translate([(pinwidth - fjendmilldiameter / 2), 0, 0]){
                  cube([(fjendmilldiameter / 2), (fjthickness + fjendmilldiameter / 2), (fjthickness + fjendmilldiameter * 2)], center=false);
                }
              }

            }
          }

        }
      }

    }

  }
}

module vgroove(vgendmilldiameter, vgthickness) {
  vgradius = vgendmilldiameter / 2;
  hull(){
    cylinder(r1=0, r2=vgendmilldiameter, h=vgendmilldiameter, center=false);
    translate([0, vgthickness, 0]){
      cylinder(r1=0, r2=vgendmilldiameter, h=vgendmilldiameter, center=false);
    }
  }
}

module fjointwchamferall(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven) {
  difference() {
    fjoint(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven);

    chamferall(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven);
  }
}

module chamferall(fjthickness, fjlength, fjendmilldiameter, fjoddoreven) {
  calcnumberofpins = ceil(fjlength / (fjthickness + fjendmilldiameter));
  if (calcnumberofpins % 2 == 0) {
    pinwidth = fjlength / (calcnumberofpins + 1);
    for (j = [0 : abs(1) : calcnumberofpins]) {
      translate([(j * pinwidth), (0 - fjendmilldiameter / 2), (fjthickness - fjendmilldiameter / 2)]){
        if (j % 2 == 1 && fjoddoreven == "odd" || j % 2 == 0 && fjoddoreven == "even") {
          union(){
            vgroove(fjendmilldiameter, fjthickness);
            translate([(0 + pinwidth), 0, 0]){
              vgroove(fjendmilldiameter, fjthickness);
            }
          }
        }

      }
    }

  } else {
    numberofpins = calcnumberofpins;  pinwidth = fjlength / calcnumberofpins;
    for (j = [0 : abs(1) : calcnumberofpins - 1]) {
      translate([(j * pinwidth), (0 - fjendmilldiameter / 2), (0 - fjthickness / 2)]){
        if (j % 2 == 1 && fjoddoreven == "odd" || j % 2 == 0 && fjoddoreven == "even") {
          union(){
            vgroove(fjendmilldiameter, fjthickness);
            translate([(0 + pinwidth), 0, 0]){
              vgroove(fjendmilldiameter, fjthickness);
            }
          }
        }

      }
    }

  }

}

module Side() {
  difference() {
    union(){
      translate([Thickness, Thickness, 0]){
        cube([Depth, Height, Thickness], center=false);
      }
      translate([Thickness, 0, 0]){
        fjointwchamferall(Thickness, Depth, EndmillDiameter, "odd");
      }
      translate([0, (Height / (100 / FrontAngleProportion) + Thickness), 0]){
        rotate([0, 0, 270]){
          fjointwchamferall(Thickness, Height / (100 / FrontAngleProportion) + Thickness, EndmillDiameter, "odd");
        }
      }
      translate([(Depth + Thickness * 2), 0, 0]){
        rotate([0, 0, 90]){
          fjointwchamferall(Thickness, Height + Thickness, EndmillDiameter, "odd");
        }
      }
    }

    translate([0, (Height / (100 / FrontAngleProportion) + Thickness * 0), (0 - Thickness)]){
      rotate([0, 0, (atan((Height * ((100 - FrontAngleProportion) / 100)) / (Depth * ((100 - BackAngleProportion) / 100))))]){
        cube([((Width + Thickness * 2) + 4 * Depth), (Width + (Depth + Thickness * 3)), (Height + Thickness * 2)], center=false);
      }
    }
  }
}

module fjointwithchamferstedge(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven) {
  difference() {
    fjoint(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven);

    chamferint(fjthickness, fjwidth, fjendmilldiameter, fjoddoreven);
  }
}

module chamferint(fjthickness, fjlength, fjendmilldiameter, fjoddoreven) {
  calcnumberofpins = ceil(fjlength / (fjthickness + fjendmilldiameter));
  if (calcnumberofpins % 2 == 0) {
    pinwidth = fjlength / (calcnumberofpins + 1);
    for (j = [1 : abs(1) : calcnumberofpins]) {
      translate([(j * pinwidth - pinwidth), (0 - fjendmilldiameter / 2), (fjthickness - fjendmilldiameter / 2)]){
        if (j % 2 == 1 && fjoddoreven == "odd" || j % 2 == 0 && fjoddoreven == "even") {
          union(){
            vgroove(fjendmilldiameter, fjthickness);
            translate([(0 + pinwidth), 0, 0]){
              vgroove(fjendmilldiameter, fjthickness);
            }
          }
        }

      }
    }

  } else {
    numberofpins = calcnumberofpins;  pinwidth = fjlength / calcnumberofpins;
    for (j = [1 : abs(1) : calcnumberofpins - 1]) {
      translate([(j * pinwidth - pinwidth), (0 - fjendmilldiameter / 2), (0 - fjthickness / 2)]){
        if (j % 2 == 1 && fjoddoreven == "odd" || j % 2 == 0 && fjoddoreven == "even") {
          union(){
            vgroove(fjendmilldiameter, fjthickness);
            translate([(0 + pinwidth), 0, 0]){
              vgroove(fjendmilldiameter, fjthickness);
            }
          }
        }

      }
    }

  }

}

projection(cut=true) {
union(){
  union(){
    translate([Thickness, Thickness, 0]){
      cube([Width, Depth, Thickness], center=false);
    }
    translate([Thickness, 0, 0]){
      fjointwchamferall(Thickness, Width, EndmillDiameter, "odd");
    }
    translate([(Width + Thickness), (Depth + Thickness * 2), 0]){
      rotate([0, 0, 180]){
        fjointwchamferall(Thickness, Width, EndmillDiameter, "odd");
      }
    }
    rotate([0, 0, 270]){
      translate([(0 - (Depth + Thickness * 1)), 0, 0]){
        fjointwchamferall(Thickness, Depth, EndmillDiameter, "even");
      }
    }
    translate([(Width + Thickness * 2), Thickness, 0]){
      rotate([0, 0, 90]){
        fjointwchamferall(Thickness, Depth, EndmillDiameter, "even");
      }
    }
  }
  if (View == 0) {
    rotate([0, 0, 180]){
      translate([(0 - (Width + Thickness * 2)), (PartSpacing - Thickness), 0]){
        Front();
      }
    }
  } else {
    translate([0, (0 - PartSpacing), 0]){
      rotate([90, 0, 0]){
        mirror([0,0,1]){
          Front();
        }
      }
    }
  }

  if (View == 0) {
    translate([0, ((Depth + PartSpacing) + Thickness), 0]){
      Back();
    }
  } else {
    translate([0, ((Depth + PartSpacing) + Thickness * 2), 0]){
      rotate([90, 0, 0]){
        Back();
      }
    }
  }

  if (View == 0) {
    union(){
      translate([(0 - (PartSpacing - Thickness)), 0, 0]){
        rotate([0, 0, 90]){
          Side();
        }
      }
      translate([((Width + PartSpacing) + Thickness), 0, 0]){
        rotate([0, 180, 270]){
          mirror([0,0,1]){
            Side();
          }
        }
      }
    }
  } else {
    union(){
      translate([(0 - PartSpacing), 0, 0]){
        rotate([90, 0, 90]){
          Side();
        }
      }
      translate([((Width + PartSpacing) + Thickness * 2), 0, 0]){
        rotate([90, 0, 90]){
          mirror([0,0,1]){
            Side();
          }
        }
      }
    }
  }
}
}