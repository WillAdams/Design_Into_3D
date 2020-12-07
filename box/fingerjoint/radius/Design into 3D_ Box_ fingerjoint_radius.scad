//!OpenSCAD

Height = 3;
Width = 3;
Depth = 3;
Stock_Thickness = 0.25;
Part_Spacing = 0.5;
Scaling_Factor = 1;
Rounding = true;
Preview = "3D"; // [3D:3D Preview, Parts:Parts, Radius:Radius, Intersect:Intersect]
Detail = 20;
Endmill_Diameter = 0.25;

feedrate = 600;
plungerate = 150;
safeheight = 8;

h = Height * Scaling_Factor;
w = Width * Scaling_Factor;
d = Depth * Scaling_Factor;
st = Stock_Thickness * Scaling_Factor;
ps = Part_Spacing * Scaling_Factor;
endmillradius = Endmill_Diameter / 2;
fjnumx = calcnumpins(Width);
fjnumy = calcnumpins(Depth);
fjnumz = calcnumpins(Height);
fjwidx = (w - st) / fjnumx;
fjwidy = (d - st) / fjnumy;
fjwidz = (h - st) / fjnumz;

$fn = Detail * 1;

tool_radius_tip = 0.03125 * Scaling_Factor;
tool_radius_width = 0.125 * Scaling_Factor;


module radiuscut(beginx, beginy, endx, endy) {
n = Detail;
step = 360/n;

//echo(str("G0 X",beginx," Y",beginy," Z",safeheight));
//echo(str("G1 Z",-endmillradius," F",plungerate));
//echo(str("G1 X",endx," Y",endy," F",feedrate));
//echo(str("G0 Z",safeheight));



//hull(){
translate([0,0,st/2]){
//cylinder(step,tool_radius_tip,tool_radius_tip);
//translate([endx,endy,0])
//cylinder(step,tool_radius_tip,tool_radius_tip);
//}

hull(){
translate([beginx,beginy,tool_radius_width])
cylinder(tool_radius_width*2,tool_radius_tip+tool_radius_width,tool_radius_tip+tool_radius_width);
    
translate([endx,endy,tool_radius_width])
cylinder(tool_radius_width*2,tool_radius_tip+tool_radius_width,tool_radius_tip+tool_radius_width);
}

for (i=[0:step:90]) {
    angle = i;
    dx = tool_radius_width*cos(angle);
    dxx = tool_radius_width*cos(angle+step);
    dzz = tool_radius_width*sin(angle);
    dz = tool_radius_width*sin(angle+step);
    dh = dz-dzz;
    hull(){
    translate([beginx,beginy,dz])
       cylinder(dh,tool_radius_tip+tool_radius_width-dx,tool_radius_tip+tool_radius_width-dxx);
    translate([endx,endy,dz])
       cylinder(dh,tool_radius_tip+tool_radius_width-dx,tool_radius_tip+tool_radius_width-dxx);
        }
}
}}

//radiuscut(0, 0, 20, 20);

function calcnumpins(x) = floor((x / Scaling_Factor + (x / Scaling_Factor - Scaling_Factor)) / 2) * 2 + 1;

module frontback() {
  difference() {
    board(st, w, h);

    translate([(st / 2), (-endmillradius), 0]){
      cutxevenfingerjoints();
    }
    translate([(-endmillradius), (st / 2), 0]){
      cutzevenfingerjoints();
    }
    translate([(w - st), (st / 2), 0]){
      cutzevenfingerjoints();
    }
  }
}

module cutzevenfingerjoints() {
  for (i = [1 : abs(2) : fjnumz - 1]) {
    translate([0, (fjwidz * i), 0]){
      cutroundedpocketx(0, 0, st, st + endmillradius, fjwidz, 0);
    }
  }

}

module cutxoddfingerjoints() {
  for (i = [0 : abs(2) : fjnumx - 1]) {
    translate([(fjwidx * i), 0, 0]){
      cutroundedpockety(0, 0, st, fjwidx, st + endmillradius, 0);
    }
  }

}

module cutxevenfingerjoints() {
  for (i = [1 : abs(2) : fjnumx - 1]) {
    translate([(fjwidx * i), 0, 0]){
      cutroundedpockety(0, 0, st, fjwidx, st + endmillradius, 0);
    }
  }

}

module topbottom() {
  difference() {
    union(){
      translate([0, st, 0]){
        board(st, w, d - st * 2);
      }
      translate([st, 0, 0]){
        board(st, w - st * 2, d);
      }
    }

    translate([(st / 2), (-endmillradius), 0]){
      cutxoddfingerjoints();
    }
    translate([(st / 2), (d - st), 0]){
      cutxoddfingerjoints();
    }
    translate([(-endmillradius), (st / 2), 0]){
      cutyoddfingerjoints();
    }
    translate([(w - st), (st / 2), 0]){
      cutyoddfingerjoints();
    }
  }
}

module board(ht, wd, dpth) {
  cube([wd, dpth, ht], center=false);
}

module cutyoddfingerjoints() {
  for (i = [0 : abs(2) : fjnumy - 1]) {
    translate([0, (fjwidy * i), 0]){
      cutroundedpocketx(0, 0, st, st + endmillradius, fjwidy, 0);
    }
  }

}

module sides() {
  difference() {
    union(){
      translate([0, st, 0]){
        board(st, h, d - st * 2);
      }
      translate([st, 0, 0]){
        board(st, h - st * 2, d);
      }
    }

    translate([(st / 2), (-endmillradius), 0]){
      cutzoddfingerjoints();
    }
    translate([(st / 2), (d - st), 0]){
      cutzoddfingerjoints();
    }
    translate([(h - st), (st / 2), 0]){
      cutyevenfingerjoints();
    }
  }
}

module cutzoddfingerjoints() {
  for (i = [0 : abs(2) : fjnumz - 1]) {
    translate([(fjwidz * i), 0, 0]){
      cutroundedpockety(0, 0, st, fjwidz, st + endmillradius, 0);
    }
  }

}

module cutroundedpocket(bx, by, bz, ex, ey, ez) {
  hull(){
    translate([(bx + endmillradius), (by + endmillradius), -ez/2]){
      cylinder(r1=endmillradius, r2=endmillradius, h=(abs(bz - ez) * 2), center=false);
    }
    translate([(ex - endmillradius), (by + endmillradius), -ez/2]){
      cylinder(r1=endmillradius, r2=endmillradius, h=(abs(bz - ez) * 2), center=false);
    }
    translate([(bx + endmillradius), (ey - endmillradius), -ez/2]){
      cylinder(r1=endmillradius, r2=endmillradius, h=(abs(bz - ez) * 2), center=false);
    }
    translate([(ex - endmillradius), (ey - endmillradius), -ez/2]){
      cylinder(r1=endmillradius, r2=endmillradius, h=(abs(bz - ez) * 2), center=false);
    }
  }
}

module cutroundedpockety(bx, by, bz, ex, ey, ez) {
cutroundedpocket(bx, by, bz, ex, ey, ez);
    if (Rounding == true) {
radiuscut(bx+tool_radius_tip, by+tool_radius_width, bx+tool_radius_tip, ey-tool_radius_width);
radiuscut(ex-tool_radius_tip, by+tool_radius_width, ex-tool_radius_tip, ey-tool_radius_width);
}}

module cutroundedpocketx(bx, by, bz, ex, ey, ez) {
cutroundedpocket(bx, by, bz, ex, ey, ez);
    if (Rounding == true) {
radiuscut(bx+tool_radius_width, by+tool_radius_tip, ex-tool_radius_width, by+tool_radius_tip);
radiuscut(bx+tool_radius_width, ey-tool_radius_tip, ex-tool_radius_width, ey-tool_radius_tip);
}}

//radiuscut(0, 0, 2, 2);

module cutyevenfingerjoints() {
  for (i = [1 : abs(2) : fjnumz]) {
    translate([0, (fjwidy * i), 0]){
      cutroundedpocketx(0, 0, st, st + endmillradius, fjwidy, 0);
    }
  }

}

if (Preview == "Parts") {
  union(){
    translate([0, (h + ps), 0]){
      sides();
    }
    translate([(h + ps), 0, 0]){
      frontback();
    }
    translate([(h + ps), (h + ps), 0]){
      topbottom();
    }
    translate([(h + ps), ((h + ps) + (d + ps)), 0]){
      frontback();
    }
  }
}

if (Preview == "3D") 
{
  union(){
    translate([0, ps, (h + ps)]){
      rotate([0, 90, 0]){
        sides();
      }
    }
    translate([w+ps, 0, ps]){
      rotate([90, 0, 180]){
        frontback();
      }
    }
    translate([ps, ps, 0]){
      topbottom();
    }
    translate([w+ps*2, d+ps, (h + ps)]){
      rotate([0, 90, 180]){
        sides();
      }
    }
    translate([ps, (d + ps * 2), ps]){
      rotate([90, 0, 0]){
        frontback();
      }
    }
  }
} 

if (Preview == "Radius") 
{
    cutroundedpocketx(0, 0, st, st + endmillradius, 1, 0);
}

if (Preview == "Intersect") 
{
  intersection(){
    translate([w+ps, 0, ps]){
      rotate([90, 0, 180]){
        frontback();
      }
    }
    translate([ps, ps, 0]){
      topbottom();
    }
}
} 
