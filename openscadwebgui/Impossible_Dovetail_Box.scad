//!OpenSCAD

Height = 1.5;
Width_and_Depth = 3;
Number_of_Tails = 1;
Units = 25.4;
Dovetail_Angle = 14;
Dovetail_Height = 0.5;
Dovetail_Diameter = 0.5;
Box_Proportion = 0.5;
Hole_Proportion = 0.33;
Generate_DXF_or_STL = "STL"; // [DXF, STL]
Open_or_Closed = "Open"; // [Open, Closed]

module makebottom() {
  difference() {
    translate([0, 0, ((ht * Box_Proportion) / 2)]){
      rotate([0, 0, 45]){
        cube([wd, wd, (ht * Box_Proportion)], center=true);
      }
    }

    cutbottomdovetails();
    cutpocket();
  }
}

ht = Height * Units;
wd = Width_and_Depth * Units;
dh = Dovetail_Height * Units;
dr = (Dovetail_Diameter * Units) / 2;
do = tan(Dovetail_Angle) * dh;
sd = dr - do;
rwidth = sqrt(wd * wd + wd * wd);
rwidthhalf = rwidth / 2;
rwidthquarter = rwidth / 4;
//item = 0;


module cutbottomdovetails() {
  union(){
    cutdovetails(-rwidthquarter, -(rwidthquarter * 1.5), ht * Box_Proportion - dh, -rwidthquarter, rwidthquarter * 1.5, ht * Box_Proportion - dh);
    cutdovetails(rwidthquarter, -(rwidthquarter * 1.5), ht * Box_Proportion - dh, rwidthquarter, rwidthquarter * 1.5, ht * Box_Proportion - dh);
  }
}

module cutdovetails(bx, by, bz, ex, ey, ez) {
  hull(){
    translate([bx, by, bz]){
      dovetail();
    }
    translate([ex, ey, ez]){
      dovetail();
    }
  }
}

module maketop() {
  color([0.6,0.4,0.2]) {
    difference() {
      translate([0, 0, (((ht - ht * Box_Proportion) + dh) / 2)]){
        rotate([0, 0, 45]){
          cube([wd, wd, ((ht - ht * Box_Proportion) + dh)], center=true);
        }
      }

      cuttopdovetails();
    }
  }
}

module cuttopdovetails() {
  union(){
    hull(){
      cutdovetails(-(rwidthquarter - sd * 2), -(rwidthquarter * 1.875), ht * Box_Proportion, -(rwidthquarter - sd * 2), rwidthquarter * 1.875, ht * Box_Proportion);
      cutdovetails(rwidthquarter - sd * 2, -(rwidthquarter * 1.875), ht * Box_Proportion, rwidthquarter - sd * 2, rwidthquarter * 1.875, ht * Box_Proportion);
    }
    hull(){
      cutdovetails(-(rwidthquarter + sd * 4), -rwidthquarter, ht * Box_Proportion, -(rwidthquarter + sd * 4), rwidthquarter, ht * Box_Proportion);
      cutdovetails(-(rwidthquarter * 1.875), -rwidthquarter, ht * Box_Proportion, -(rwidthquarter * 1.875), rwidthquarter, ht * Box_Proportion);
    }
    hull(){
      cutdovetails(rwidthquarter + sd * 4, -rwidthquarter, ht * Box_Proportion, rwidthquarter + sd * 4, rwidthquarter, ht * Box_Proportion);
      cutdovetails(rwidthquarter * 1.875, -rwidthquarter, ht * Box_Proportion, rwidthquarter * 1.875, rwidthquarter, ht * Box_Proportion);
    }
  }
}

module cutpocket() {
  hull(){
    translate([0, ((wd * Hole_Proportion) / 2), (ht / 4)]){
      cylinder(r1=((wd * Hole_Proportion) / 2), r2=10, h=(ht * 3), center=false);
    }
    translate([0, (-((wd * Hole_Proportion) / 2)), (ht / 4)]){
      cylinder(r1=((wd * Hole_Proportion) / 2), r2=10, h=(ht * 3), center=false);
    }
  }
}

module dovetail() {
  if (Generate_DXF_or_STL == "STL") {
    union(){
      cylinder(r1=dr, r2=(dr - do), h=dh, center=false);
    }
  } else {
    translate([0, 0, (-ht)]){
      cylinder(r1=(dr - do), r2=(dr - do), h=(ht * 3), center=false);
    }
  }

}

if (Generate_DXF_or_STL == "STL") {
  if (Open_or_Closed == "Open") {
    union(){
      translate([(-(rwidthhalf * 1.1)), 0, 0]){
        makebottom();
      }
      translate([(rwidthhalf * 1.1), 0, 0]){
        maketop();
      }
    }
  } else {
    union(){
      makebottom();
      translate([0, 0, ht]){
        rotate([0, 180, 0]){
          maketop();
        }
      }
    }
  }

} else {
  projection()
  union(){
    translate([(-(rwidthhalf * 1.1)), 0, 0]){
      union(){
        difference() {
          cube([rwidth, rwidth, (ht * 0.1)], center=true);

          rotate([0, 0, 45]){
            cube([wd, wd, ((ht - ht * Box_Proportion) + dh)], center=true);
          }
        }
        intersection() {
          rotate([0, 0, 45]){
            cube([wd, wd, (ht * 0.1)], center=true);
          }

          translate([0, 0, (-ht)]){
            cutpocket();
          }

        }
      }
    }
    translate([(rwidthhalf * 1.1), 0, 0]){
      difference() {
        cube([rwidth, rwidth, (ht * 0.1)], center=true);

        cutbottomdovetails();
      }
    }
    translate([(rwidthhalf * 3.3), 0, 0]){
      difference() {
        cube([rwidth, rwidth, (ht * 0.1)], center=true);

        cuttopdovetails();
      }
    }
  }
}
