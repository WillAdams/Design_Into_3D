//!OpenSCAD

Height = 3.5;
Width = 10;
Depth = 8;
Stock_Thickness = 0.25;
Top_Bottom_Thickness = 0.21653543;
Part_Spacing = 0.375;
//(millimeters or inches)
Units = 1; //[1:millimeters, 25.4:inches]
Preview_3D = true;
Joinery_Cut = false;
Generate_DXF = false;
Endmill_Diameter = 0.125;


h = Height * Units;
w = Width * Units;
d = Depth * Units;
st = Stock_Thickness * Units;
tbt = Top_Bottom_Thickness * Units;
ps = Part_Spacing * Units;
cd = Endmill_Diameter * Units;
fjcount = (ceil(Height / Stock_Thickness) / 2) * 2 + 1;
fjsize = h / fjcount;

module board(ht, wd, dpth) {
  cube([wd, dpth, ht], center=false);
}

module topbottom() {
  board(tbt, w - st, d - st);
}

module cut(cbx, cby, cex, cey, abx, aby, aex, aey, sd, ed) {
  translate([0, 0, (sd - ed)]){
    hull(){
      translate([cbx, cby, 0]){
        em();
      }
      translate([cex, cey, 0]){
        em();
      }
      translate([abx, aby, 0]){
        em();
      }
      translate([aex, aey, 0]){
        em();
      }
    }
  }
}

module em() {
  cylinder(r1=(cd / 2), r2=(cd / 2), h=(cd + st), center=false);
}

module frontback() {
  difference() {
    board(st, w, h);

    cut(st / 2, st / 2 + cd / 2, w - st / 2, st / 2 + cd / 2, st / 2, (st / 2 + tbt) - cd / 2, w - st / 2, (st / 2 + tbt) - cd / 2, st, st / 2);
    translate([0, (h - st * 2), 0]){
      cut(st / 2, st / 2 + cd / 2, w - st / 2, st / 2 + cd / 2, st / 2, (st / 2 + tbt) - cd / 2, w - st / 2, (st / 2 + tbt) - cd / 2, st, st / 2);
    }
    if (Generate_DXF == false) {
      union(){
        translate([(-cd), 0, (-st)]){
          for (i = [0 : abs(2) : fjcount - 1]) {
            translate([0, (i * fjsize), 0]){
              cube([(cd + st), fjsize, (st * 3)], center=false);
            }
          }

        }
        translate([(w - st), 0, (-st)]){
          for (i = [0 : abs(2) : fjcount - 1]) {
            translate([0, (i * fjsize), 0]){
              cube([(cd + st), fjsize, (st * 3)], center=false);
            }
          }

        }
      }
    }

  }
}

module sides() {
  difference() {
    board(st, h, d);

    cut(st / 2 + cd / 2, st / 2, st / 2 + cd / 2, d - st / 2, (st / 2 + tbt) - cd / 2, st / 2, (st / 2 + tbt) - cd / 2, d - st / 2, st, st / 2);
    translate([(h - st * 2), 0, 0]){
      cut(st / 2 + cd / 2, st / 2, st / 2 + cd / 2, d - st / 2, (st / 2 + tbt) - cd / 2, st / 2, (st / 2 + tbt) - cd / 2, d - st / 2, st, st / 2);
    }
    if (Generate_DXF == false) {
      union(){
        translate([0, (-cd), (-st)]){
          for (i = [1 : abs(2) : fjcount]) {
            translate([(i * fjsize), 0, 0]){
              cube([fjsize, (cd + st), (st * 3)], center=false);
            }
          }

        }
        translate([0, (d - st), (-st)]){
          for (i = [1 : abs(2) : fjcount]) {
            translate([(i * fjsize), 0, 0]){
              cube([fjsize, (cd + st), (st * 3)], center=false);
            }
          }

        }
      }
    }

  }
}

if (Preview_3D == false) {
    projection(cut = true)
    {
  union(){
    translate([0, (h + ps), -st*0.9]){
      sides();
    }
    translate([(h + ps), 0, -st*0.9]){
      frontback();
    }
    translate([((h + ps) + st / 2), ((h + ps) + st / 2), 0]){
      topbottom();
    }
    translate([(h + ps), ((h + ps) + (d + ps)), -st*0.9]){
      frontback();
    }
    translate([((h + ps) + (w + ps)), (h + ps), -st*0.9]){
      sides();
    }
  }
}} else {
  if (Joinery_Cut == false) {
    union(){
      translate([0, ps, (h + ps)]){
        rotate([0, 90, 0]){
          sides();
        }
      }
      translate([0, 0, 0]){
        mirror([0,1,0]){
          translate([ps, 0, ps]){
            rotate([90, 0, 0]){
              frontback();
            }
          }
        }
      }
      translate([(ps + st / 2), (ps + st / 2), (st / 2)]){
        topbottom();
      }
      translate([(ps + st / 2), (ps + st / 2), ((h + ps * 2) - st * 1.5)]){
        topbottom();
      }
      translate([((w + ps * 2) - 0), ps, (h + ps)]){
        rotate([0, 90, 0]){
          mirror([0,0,1]){
            sides();
          }
        }
      }
      translate([ps, (d + ps * 2), ps]){
        rotate([90, 0, 0]){
          frontback();
        }
      }
    }
  } else {
    if (Generate_DXF == true) {
        projection(){
      union(){
        cube([(cd / 2), (cd / 2), (cd / 2)], center=false);
        translate([fjsize, (-(cd / 2)), 0]){
          for (j = [0 : abs(2) : fjcount]) {
            translate([(j * fjsize), 0, 0]){
              cube([fjsize, ((st * 4 + ps * 3) + cd), (st * 2)], center=false);
            }
          }

        }
      }
    }} else {
      difference() {
        union(){
          translate([0, st, (st - d)]){
            rotate([90, 0, 0]){
              union(){
                sides();
                translate([0, 0, (-(st + ps))]){
                  sides();
                }
              }
            }
          }
          translate([fjsize, ((st + ps) * 2 + st), st]){
            rotate([90, 90, 0]){
              union(){
                frontback();
                translate([0, 0, (-(st + ps))]){
                  frontback();
                }
              }
            }
          }
        }

        translate([fjsize, (-(cd / 2)), 0]){
          for (j = [0 : abs(2) : fjcount]) {
            translate([(j * fjsize), 0, 0]){
              cube([fjsize, ((st * 4 + ps * 3) + cd), (st * 2)], center=false);
            }
          }

        }
      }
    }

  }

}
