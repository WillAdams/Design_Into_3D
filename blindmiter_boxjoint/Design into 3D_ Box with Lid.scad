//!OpenSCAD

Height = 1.7;
Width = 8.125;
Depth = 4.0625;
Stock_Thickness = 0.3287;
Number_of_Divisions = 3;
Lid_Type = "Hinged"; // [Sawn:Sawn, Sliding:Sliding, Hinged:Hinged]
Lid_Location = 2;
Part_Spacing = 0.375;
V_endmill = 390;
V_radius = 0.0625;
Square_endmill = 282;
Square_radius = 0.0394;
Units = 25.4; // [1:Metric, 25.4:Imperial]
Generate_3D_Preview = true;
Generate_DXF = true;
Show_Text = true;
Text_Size = 1;
$fn=20;
module empty () {};
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

//tools_and_depths are ((len("any") + len("any")) + (len("square") + st / 2)) + (((len("square") + pd) + (len("vee") + 0)) + (len("square") + 0));

module cutparts(tool, dpth, label, elevation) {
  difference() {
    stockoutline();

    translate([st, st, elevation]){
      sides(tool, dpth);
      translate([(d + (ps + st)), 0, 0]){
        front(tool, dpth);
        translate([(w + (ps + st)), 0, 0]){
          sides(tool, dpth);
          translate([(d + (ps + st)), 0, 0]){
            back2(tool, dpth);
            translate([(w + (ps + st)), 0, 0]){
              top2(tool, dpth);
              translate([(w + (ps + st)), 0, 0]){
                bottom(tool, dpth);
              }
            }
          }
        }
      }
    }
    translate([ts, (d - st), (-st)]){
      // size is multiplied by 0.75 because openScad font sizes are in points, not pixels
      linear_extrude( height=(st * 3), twist=0, center=false){
        text(str(label), font = "Roboto", size = ts*0.75);
      }

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

module gcp_endmill_v(es_v_angle, es_diameter) {
  union(){
    cylinder(r1=0, r2=(es_diameter / 2), h=((es_diameter / 2) / tan((es_v_angle / 2))), center=false);
    translate([0, 0, ((es_diameter / 2) / tan((es_v_angle / 2)))]){
      cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=(st * 2), center=false);
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

module gcp_endmill_ball(es_diameter, es_flute_length) {
  translate([0, 0, (es_diameter / 2)]){
    union(){
      sphere(r=(es_diameter / 2));
      cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=es_flute_length, center=false);
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
  } else if (tool == "square" && dpth == 0) {
    makeboard(st, d, h, "Side");
  }

}

module cutsquare(tool, dpth, jw) {
  if (tool == "any" && dpth == "any" || tool == "square" && dpth == st / 2) {
    union(){
      translate([(-(st / 2)), (st / 2), (st / 2)]){
        cube([(jw + st), (st / 2), st], center=false);
      }
      if (Lid_Type == "Hinged") {

      } else {
        translate([(-(st / 2)), (h - st), (st / 2)]){
          cube([(jw + st), (st / 2), st], center=false);
        }
      }

      if (Lid_Type == "Sawn") {
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

module front(tool, dpth) {
  if (tool == "any" && dpth == "any") {
    if (Lid_Type == "Hinged") {
      frontback(tool, dpth, "F");
    } else {
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

        if (Lid_Type == "Sliding" || Lid_Type == "Sawn") {
          union(){
            cutsquare(tool, dpth, w);
            cutjoinery(tool, dpth, w, "positive");
          }
        }

      }
    }

  } else if (tool == "square" && dpth == st / 2) {
    union(){
      difference() {
        cutsquare(tool, dpth, w);

        if (Lid_Type == "Hinged") {
          translate([st, (h - st), (-(st / 2))]){
            pocket(0, 0, 0, w - st * 2, st * 2, 0, false, false, false, false, sr * 2);
          }
        }

      }
      cutjoinery(tool, dpth, w, "positive");
    }
  } else if (tool == "square" && dpth == pd) {
    union(){
      if (Lid_Type != "Hinged") {
        cutsquare(tool, dpth, w);
      }

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
  } else if (tool == "square" && dpth == 0) {
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

      if (Lid_Type == "Sliding" || Lid_Type == "Sawn") {
        union(){
          cutsquare(tool, dpth, w);
        }
      }

      if (Lid_Type == "Hinged") {
        union(){
          translate([st, (h - st), (-(st / 2))]){
            pocket(0, 0, 0, w - st * 2, st * 2, 0, false, false, false, false, sr * 2);
          }
        }
      }

    }
  }

}

module stockoutline() {
  translate([0, 0, (-(0.1 * st))]){
    cube([((w * 4 + d * 2) + (ps + st) * 7), (d + st * 4), (0.1 * st)], center=false);
  }
}

module makeboard(ht, wd, dpth, name2) {
  difference() {
    cube([wd, dpth, ht], center=false);

    CenteredText(name2, wd, dpth);
  }
}

module pocket(bx, by, bz, ex, ey, ez, ULdogbones, URdogbones, LRdogbones, LLdogbones, tooldiameter) {
  union(){
    hull(){
      translate([(bx + tooldiameter / 2), (by + tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=(st * 2), center=false);
      }
      translate([(bx + tooldiameter / 2), (ey - tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=(st * 2), center=false);
      }
      translate([(ex - tooldiameter / 2), (by + tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=(st * 2), center=false);
      }
      translate([(ex - tooldiameter / 2), (ey - tooldiameter / 2), bz]){
        cylinder(r1=(tooldiameter / 2), r2=(tooldiameter / 2), h=(st * 2), center=false);
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

module gcp_endmill_square(es_diameter, es_flute_length) {
  cylinder(r1=(es_diameter / 2), r2=(es_diameter / 2), h=es_flute_length, center=false);
}

module bottom(tool, dpth) {
  if (tool == "square" && dpth == 0) {
    translate([(st / 2), (st / 2), 0]){
      makeboard(st, w - st, d - st, "B");
    }
  } else if (tool == "square" && dpth == st / 2) {
    translate([st, st, 0]){
      makeboard(st, w - st * 2, d - st * 2, "B");
    }
  } else if (tool == "any" && dpth == "any") {
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

}

module frontback(tool, dpth, fb) {
  difference() {
    if (tool == "any" && dpth == "any") {
      difference() {
        makeboard(st, w, h, fb);

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
    } else if (tool == "square" && dpth == 0) {
      difference() {
        makeboard(st, w, h, "Back");

        cutsquare(tool, dpth, w);
      }
    }

    if (Lid_Type == "Hinged") {
      union(){
        translate([st, (h - st), (-(st / 2))]){
          pocket(0, 0, 0, w - st * 2, st * 2, 0, false, false, false, false, sr * 2);
        }
      }
    }

  }
}

module top2(tool, dpth) {
  if (tool == "any" && dpth == "any") {
    if (Lid_Type == "Sawn") {
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
    } else if (Lid_Type == "Hinged") {
      translate([0, (st * 1), 0]){
        union(){
          difference() {
            makeboard(st, w - st * 2, d, "T");

            translate([(w / 2 - st), 0, (st * 0.75)]){
              cylinder(r1=st, r2=(st * 1.5), h=(st * 0.5), center=false);
            }
            translate([(-(st * 1)), (d - st / 2), (st / 2)]){
              cube([w, st, st], center=false);
            }
            union(){
              gcut(0, 0, st - sr, 0, d, st - sr, V_endmill);
              gcut(w - st * 2, 0, st - sr, w - st * 2, d, st - sr, V_endmill);
            }
          }
          translate([0, (d - st / 2), (st / 2)]){
            rotate([0, 90, 0]){
              cylinder(r1=(st / 2), r2=(st / 2), h=(w - st * 2), center=false);
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
        translate([(w / 2 - st * 0.25), (st * 2.5), (st * 0.75)]){
          cylinder(r1=(st * 1), r2=(st * 1.5), h=(st * 0.5), center=false);
        }
      }
    }

  } else if (tool == "square" && dpth == 0) {
    if (Lid_Type == "Hinged") {
      translate([st, 0, 0]){
        makeboard(st, w - st * 2, d, "T");
      }
    } else if (Lid_Type == "Sliding") {
      translate([(st / 2), 0, 0]){
        makeboard(st, w - st, d - st / 2, "T");
      }
    } else if (Lid_Type == "Sawn") {
      translate([(st / 2), (st / 2), 0]){
        makeboard(st, w - st, d - st, "T");
      }
    }

  } else if (tool == "vee" && dpth == 0) {
    if (Lid_Type == "Hinged") {
      translate([(st * 1), 0, (-(st / 2))]){
        union(){
          gcut(0, 0, st - sr, 0, d, st - sr, V_endmill);
          gcut(w - st * 2, 0, st - sr, w - st * 2, d, st - sr, V_endmill);
        }
      }
    }

  } else if (tool == "square" && dpth == st / 2) {
    translate([0, 0, (-(st / 2))]){
      if (Lid_Type == "Hinged") {
        translate([st, 0, 0]){
          makeboard(st * 2, w - st * 2, d, "T");
        }
      } else if (Lid_Type == "Sawn") {
        translate([st, st, 0]){
          makeboard(st * 2, w - st * 2, d - st * 2, "T");
        }
      } else if (Lid_Type == "Sliding") {
        translate([st, 0, 0]){
          makeboard(st * 2, w - st * 2, d - st, "T");
        }
      }

    }
  } else if (tool == "square" && dpth == pd) {
    translate([0, 0, (-(st / 2))]){
      if (Lid_Type == "Hinged") {

      } else if (Lid_Type == "Sawn") {

      } else if (Lid_Type == "Sliding") {

      }

    }
  }

}

module back2(tool, dpth) {
  frontback(tool, dpth, "Back");
}

if (Generate_3D_Preview == false) {
  if (Generate_DXF == true) {
      projection() {
    union(){
      cutparts("square", 0, "Parts", -(0.9 * st));
      translate([0, (d + (ps + st) * 3), 0]){
        cutparts("square", st / 2, st / 2, -(0.9 * st));
        translate([0, (d + (ps + st) * 3), 0]){
          cutparts("square", pd, pd, -(0.9 * st));
          translate([0, (d + (ps + st) * 3), 0]){
            cutparts("vee", 0, "vee", -(0.9 * st));
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
        bottom("any", "any");
      }
      translate([(h + ps), ((h + ps) + (d + ps)), 0]){
        back2("any", "any");
        translate([0, (h + ps), 0]){
          top2("any", "any");
        }
      }
      translate([((h + ps) + (w + ps)), ((d + h) + ps), 0]){
        rotate([0, 0, 270]){
          sides("any", "any");
        }
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
        bottom("any", "any");
      }
    }
    if (Lid_Type == "Hinged") {
      translate([(ps + st), (-st), (h + ps * 2)]){
        mirror([0,0,1]){
          top2("any", "any");
        }
      }
    } else {
      translate([(ps + st / 2), ps, ((h - st) + ps * 2)]){
        top2("any", "any");
      }
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
