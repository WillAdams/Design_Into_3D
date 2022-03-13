//!OpenSCAD

Height = 2.6;
Width = 8;
Depth = 5;
Stock_Thickness = 0.3287;
Number_of_Divisions = 7;
Lid_Type = "Sliding";// [Sliding, Hinged]
Lid_Location = 11;
Part_Spacing = 0.375;
V_endmill = 390;
V_radius = 0.0625;
Square_endmill = 282;
Square_radius = 0.0394;
Units = 25.4; // [1:Metric, 25.4:Imperial]
//3D Preview
Generate_3D_Preview = true;
Generate_DXF = false;
Show_Text = true;
Text_Size = 1;
$fn=20;
h = Height * Units;
w = Width * Units;
d = Depth * Units;
st = Stock_Thickness * Units;
ps = Part_Spacing * Units;
ts = Text_Size * Units;
vr = V_radius * Units;
pd = vr / tan((90 / 2));
sr = Square_radius * Units;
dboffset = sr - sin(45) * sr;
pw = (h - st * 2) / (Number_of_Divisions * 2 + 1);

module back2(tool, dpth) {
  if (tool == "any" && dpth == "any") {
    difference() {
      makeboard(st, w, h, "B");

      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "square" && dpth == st / 2) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "square" && dpth == pd) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "vee" && dpth == 0) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  }

}

module front(tool, dpth) {
  if (tool == "any" && dpth == "any") {
    difference() {
      difference() {
        makeboard(st, w, h, "F");

        if (Lid_Type == "Sliding") {
          union(){
            translate([st, (h - st), (-(st / 2))]){
              cube([(w - st * 2), st, (st * 2)], center=false);
            }
            translate([(st / 2), (h - st), (-(st / 2))]){
              cube([(w - st), (st / 2), (st * 2)], center=false);
            }
          }
        }

      }

      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "square" && dpth == st / 2) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "square" && dpth == pd) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "vee" && dpth == 0) {
    union(){
      cutsquare(tool, dpth, w);
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "outline") {
    difference() {
      makeboard(st, w, h, "F");

      union(){
        translate([st, (h - st), (-(st / 2))]){
          cube([(w - st * 2), st, (st * 2)], center=false);
        }
        translate([(st / 2), (h - st), (-(st / 2))]){
          cube([(w - st), (st / 2), (st * 2)], center=false);
        }
      }
    }
  }

}

module select_tool(tool_number) {
  if (tool_number == 201) {
    gcp_endmill_square(6.35, 19.05);
  } else if (tool_number == 202) {
    gcp_endmill_ball(6.35, 19.05);
  } else if (tool_number == 102) {
    gcp_endmill_square(3.175, 19.05);
  } else if (tool_number == 101) {
    gcp_endmill_ball(3.175, 19.05);
  } else if (tool_number == 301) {
    gcp_endmill_v(90, 12.7);
  } else if (tool_number == 302) {
    gcp_endmill_v(60, 12.7);
  } else if (tool_number == 390) {
    gcp_endmill_v(90, 3.175);
  } else if (tool_number == 282) {
    gcp_endmill_square(2, 6.604);
  }

}

module gcp_endmill_v(es_v_angle, es_diameter) {
  union(){
    cylinder(r1=0, r2=(es_diameter / 2), h=((es_diameter / 2) / tan((es_v_angle / 2))), center=false);
    translate([0, 0, ((es_diameter / 2) / tan((es_v_angle / 2)))]){
      cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=(st * 2), center=false);
    }
  }
}

module pocket(bx, by, bz, ex, ey, ez, ULdogbones, URdogbones, LRdogbones, LLdogbones, tooldiameter) {
  union(){
    hull(){
      translate([(bx + tooldiameter / 2), (by + tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
      }
      translate([(bx + tooldiameter / 2), (ey - tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
      }
      translate([(ex - tooldiameter / 2), (by + tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
      }
      translate([(ex - tooldiameter / 2), (ey - tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
      }
    }
    union(){
      if (URdogbones == true) {
        translate([((ex - tooldiameter / 2) + dboffset), ((ey - tooldiameter / 2) + dboffset), bz]){
          cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
        }
      }

      if (LLdogbones == true) {
        translate([((bx + tooldiameter / 2) - dboffset), ((by + tooldiameter / 2) - dboffset), bz]){
          cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
        }
      }

      if (ULdogbones == true) {
        translate([((bx + tooldiameter / 2) - dboffset), ((ey - tooldiameter / 2) + dboffset), bz]){
          cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
        }
      }

      if (LRdogbones == true) {
        translate([((ex - tooldiameter / 2) + dboffset), ((by + tooldiameter / 2) - dboffset), bz]){
          cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=st, center=false);
        }
      }

    }
  }
}

module gcut(bx, by, bz, ex, ey, ez, tn) {
  hull(){
    translate([bx, by, bz]){
      select_tool(tn);
    }
    translate([ex, ey, ez]){
      select_tool(tn);
    }
  }
}

module gcp_endmill_square(es_diameter, es_flute_length) {
  cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=es_flute_length, center=false);
}

module gcp_endmill_ball(es_diameter, es_flute_length) {
  translate([0, 0, (es_diameter / 2)]){
    union(){
      sphere(r=(es_diameter / 2));
      cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=es_flute_length, center=false);
    }
  }
}

module makeboard(ht, wd, dpth, name2) {
  difference() {
    cube([wd, dpth, ht], center=false);

    CenteredText(name2, wd, dpth);
  }
}

module CenteredText(Text2, x, y) {
  if (Show_Text == true) {
    translate([(x / 2), (y / 2), (-st)]){
      // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
      linear_extrude( height=(st * 3), twist=0, center=false){
        text(str(Text2), font = "Roboto", size = ts*0.75, halign="center", valign="center");
      }

    }
  }

}

module bottom() {
  difference() {
    makeboard(st, w - st, d - st, "B");

    translate([(-(st / 2)), (-(st / 2)), (st / 2)]){
      cube([w, st, st], center=false);
      translate([0, (d - st), 0]){
        cube([w, st, st], center=false);
      }
      cube([st, d, st], center=false);
      translate([(w - st), 0, 0]){
        cube([st, d, st], center=false);
      }
    }
  }
}

module sides(tool, dpth) {
  if (tool == "any" && dpth == "any") {
    difference() {
      makeboard(st, d, h, "Side");

      cutsquare(tool, dpth, d);
      cutjoinery(tool, dpth, d, "negative");
    }
  } else if (tool == "square" && dpth == st / 2) {
    union(){
      cutsquare(tool, dpth, d);
      cutjoinery(tool, dpth, d, "negative");
    }
  } else if (tool == "square" && dpth == pd) {
    union(){
      cutsquare(tool, dpth, d);
      cutjoinery(tool, dpth, d, "negative");
    }
  } else if (tool == "vee" && dpth == 0) {
    union(){
      cutsquare(tool, dpth, d);
      cutjoinery(tool, dpth, d, "negative");
    }
  }

}

module cutjoinery(tool, dpth, jw, type) {
  if (type == "negative") {
    union(){
      if (tool == "any" && dpth == "any" || tool == "vee" && dpth == 0) {
        union(){
          gcut(0, 0, 0, 0, h, 0, V_endmill);
          gcut(jw, 0, 0, jw, h, 0, V_endmill);
        }
      }

      if (tool == "any" && dpth == "any" || tool == "square" && dpth == pd) {
        union(){
          union(){
            pocket(-vr, -vr, pd, st, st + vr, pd, false, false, false, false, sr * 2.1);
            pocket(-vr, -vr, pd, vr, h + vr, pd, false, false, false, false, sr * 2.1);
            pocket(-vr, h - (st + vr), pd, st, h + vr, pd, false, false, false, false, sr * 2.1);
          }
          union(){
            pocket(jw - st, -vr, pd, jw, st + vr, pd, false, false, false, false, sr * 2.1);
            pocket(jw - vr, -vr, pd, jw + vr, h + vr, pd, false, false, false, false, sr * 2.1);
            pocket(jw - st, h - (st + vr), pd, jw, h + vr, pd, false, false, false, false, sr * 2.1);
          }
          translate([0, st, 0]){
            for (i = [0 : abs(2) : Number_of_Divisions * 2]) {
              union(){
                pocket(0, i * pw, pd, st, (i + 1) * pw, pd, false, true, true, false, sr * 2.1);
                pocket(jw - st, i * pw, pd, jw, (i + 1) * pw, pd, true, false, false, true, sr * 2.1);
              }
            }

          }
        }
      }

    }
  } else if (type == "positive") {
    union(){
      if (tool == "any" && dpth == "any" || tool == "vee" && dpth == 0) {
        union(){
          gcut(0, 0, 0, 0, h, 0, 390);
          gcut(jw, 0, 0, jw, h, 0, 390);
        }
      }

      if (tool == "any" && dpth == "any" || tool == "square" && dpth == pd) {
        union(){
          union(){
            pocket(-vr, -vr, pd, vr, h + vr, pd, false, false, false, false, sr * 2.1);
          }
          union(){
            pocket(jw - vr, -vr, pd, jw + vr, h + vr, pd, false, false, false, false, sr * 2.1);
          }
          translate([0, st, 0]){
            for (i = [1 : abs(2) : Number_of_Divisions * 2 - 1]) {
              union(){
                pocket(0, i * pw, pd, st, (i + 1) * pw, pd, false, true, true, false, sr * 2.1);
                pocket(jw - st, i * pw, pd, jw, (i + 1) * pw, pd, true, false, false, true, sr * 2.1);
              }
            }

          }
        }
      }

    }
  }

}

module cutsquare(tool, dpth, jw) {
  if (tool == "any" && dpth == "any" || tool == "square" && dpth == st / 2) {
    union(){
      translate([(-(st / 2)), (st / 2), (st / 2)]){
        cube([(jw + st), (st / 2), st], center=false);
      }
      translate([(-(st / 2)), (h - st), (st / 2)]){
        cube([(jw + st), (st / 2), st], center=false);
      }
      if (Lid_Type == "Hinged") {
        if (Generate_3D_Preview == true) {
          translate([(-(st / 2)), ((st - sr) + pw * Lid_Location), (-(st / 2))]){
            cube([(jw + st), (sr * 2), (st * 3)], center=false);
          }
        } else {
          translate([(-(st / 2)), ((st - sr) + pw * Lid_Location), (st / 2)]){
            cube([(jw + st), (sr * 2), st], center=false);
          }
        }

      }

    }
  }

}

module Top() {
  if (Lid_Type == "Hinged") {
    translate([0, (st / 2), 0]){
      difference() {
        makeboard(st, w - st, d - st, "T");

        translate([(-(st / 2)), (-(st / 2)), (st / 2)]){
          cube([w, st, st], center=false);
          translate([0, (d - st), 0]){
            cube([w, st, st], center=false);
          }
          cube([st, d, st], center=false);
          translate([(w - st), 0, 0]){
            cube([st, d, st], center=false);
          }
        }
      }
    }
  } else {
    difference() {
      makeboard(st, w - st, d - st / 2, "T");

      translate([(-(st / 2)), 0, (st / 2)]){
        translate([0, (d - st), 0]){
          cube([w, st, st], center=false);
        }
        cube([st, d, st], center=false);
        translate([(w - st), 0, 0]){
          cube([st, d, st], center=false);
        }
      }
    }
  }

}

if (Generate_3D_Preview == false) {
  if (Generate_DXF == true) {
    union(){
      difference() {
        cube([((w * 3 + d) + (ps + st) * 5), (d + st * 2), (0.1 * st)], center=false);

        translate([st, st, (-(0.1 * st))]){
          cube([d, h, st], center=false);
          translate([(d + (ps + st)), 0, 0]){
            cube([w, h, st], center=false);
            translate([(w + (ps + st)), 0, 0]){
              cube([w, d, st], center=false);
              translate([(w + (ps + st)), 0, 0]){
                cube([w, d, st], center=false);
              }
            }
          }
        }
        translate([ts, (d - st), (-st)]){
          // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
          linear_extrude( height=(st * 3), twist=0, center=false){
            text("Parts", font = "Roboto", size = ts*0.75);
          }

        }
      }
      translate([0, (d + (ps + st)), 0]){
        difference() {
          cube([((w * 3 + d) + (ps + st) * 5), (d + st * 2), (0.1 * st)], center=false);

          translate([st, st, (-(0.9 * st))]){
            union(){
              sides("square", st / 2);
              translate([(d + (ps + st)), 0, 0]){
                back2("square", st / 2);
                translate([(w + (ps + st * 1.5)), (st / 2), (st * 0.25)]){
                  bottom();
                  translate([(w + (ps + st * 1.5)), (st / 2), 0]){
                    Top();
                  }
                }
              }
            }
          }
          translate([ts, (d - st), (-st)]){
            // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
            linear_extrude( height=(st * 3), twist=0, center=false){
              text(str((st / 2)), font = "Roboto", size = ts*0.75);
            }

          }
        }
      }
      translate([0, ((d + (ps + st)) * 2), 0]){
        difference() {
          cube([((w * 3 + d) + (ps + st) * 5), (d + st * 2), (0.1 * st)], center=false);

          translate([st, st, (-(0.9 * st))]){
            sides("square", pd);
            translate([(d + (ps + st)), 0, 0]){
              back2("square", pd);
              translate([(w + (ps + st * 1.5)), (st / 2), (0.6 * st)]){
                bottom();
                translate([(w + (ps + st * 1.5)), (st / 2), 0]){
                  Top();
                }
              }
            }
          }
          translate([(st + ts), (d - st), (-st)]){
            // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
            linear_extrude( height=(st * 3), twist=0, center=false){
              text(str((st - pd)), font = "Roboto", size = ts*0.75);
            }

          }
        }
      }
      translate([0, ((d + (ps + st)) * 3), 0]){
        difference() {
          cube([((w * 3 + d) + (ps + st) * 5), (d + st * 2), (0.1 * st)], center=false);

          translate([st, st, (-st)]){
            sides("vee", 0);
            translate([(d + (ps + st)), 0, 0]){
              back2("vee", 0);
            }
          }
          translate([(st + ts), (d - st), (-st)]){
            // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
            linear_extrude( height=(st * 3), twist=0, center=false){
              text(str(st), font = "Roboto", size = ts*0.75);
            }

          }
        }
      }
      if (Lid_Type == "Sliding") {
        translate([0, ((d + (ps + st)) * 4), 0]){
          difference() {
            cube([((w * 3 + d) + (ps + st) * 5), (d + st * 2), (0.1 * st)], center=false);

            translate([st, st, (-(st / 4))]){
              translate([(d + (ps + st)), 0, 0]){
                front("outline", pd);
              }
            }
            translate([(st + ts), (d - st), (-st)]){
            }
          }
        }
      }

    }
  } else {
    union(){
      translate([h, (h + ps), 0]){
        rotate([0, 0, 90]){
          sides("any", "any");
        }
      }
      translate([((h + w) + ps), h, 0]){
        rotate([0, 0, 180]){
          front("any", "any");
        }
      }
      translate([(h + ps), (h + ps), 0]){
        bottom();
      }
      translate([(h + ps), ((h + ps) + (d + ps)), 0]){
        back2("any", "any");
      }
      translate([((h + ps) + (w + ps)), ((d + h) + ps), 0]){
        rotate([0, 0, 270]){
          sides("any", "any");
        }
      }
      translate([(h + ps), ((h + ps) * 2 + (d + ps)), 0]){
        Top();
      }
    }
  }

} else {
  union(){
    translate([0, ps, ps]){
      rotate([0, 90, 0]){
        rotate([0, 0, 90]){
          sides("any", "any");
        }
      }
    }
    translate([(w + ps), 0, ps]){
      rotate([90, 0, 0]){
        rotate([0, 180, 0]){
          front("any", "any");
        }
      }
    }
    translate([(ps + st / 2), (ps + st / 2), st]){
      mirror([0,0,1]){
        bottom();
      }
    }
    translate([(ps + st / 2), ps, ((h - st) + ps * 2)]){
      Top();
    }
    translate([(w + ps * 2), (d + ps), ps]){
      rotate([0, 90, 0]){
        rotate([0, 0, 90]){
          rotate([0, 180, 0]){
            sides("any", "any");
          }
        }
      }
    }
    translate([ps, (d + ps * 2), ps]){
      rotate([90, 0, 0]){
        back2("any", "any");
      }
    }
  }
}
