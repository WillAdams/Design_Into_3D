//!OpenSCAD

outer_radius = 15;
overall_thickness = 18;
rib_thickness = 6;
width = 155;
depth = 101;
hole_diameter = 14;
counterbore_depth = 8;
counterbore_diameter = 22;
central_diameter = 55;
central_height = 45;
central_hole_diameter = 42;
rib_width = 8;
rib_lower_height = 21;
slot_depth = 13;
slot_width = 8;
difference() {
  union(){
    hull(){
      translate([outer_radius, outer_radius, 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=(overall_thickness - rib_thickness), center=false);
      }
      translate([(width - outer_radius), outer_radius, 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=(overall_thickness - rib_thickness), center=false);
      }
      translate([outer_radius, (depth - outer_radius), 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=(overall_thickness - rib_thickness), center=false);
      }
      translate([(width - outer_radius), (depth - outer_radius), 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=(overall_thickness - rib_thickness), center=false);
      }
    }
    hull(){
      translate([outer_radius, outer_radius, 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=overall_thickness, center=false);
      }
      translate([(width - outer_radius), (depth - outer_radius), 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=overall_thickness, center=false);
      }
    }
    hull(){
      translate([outer_radius, (depth - outer_radius), 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=overall_thickness, center=false);
      }
      translate([(width - outer_radius), outer_radius, 0]){
        cylinder(r1=outer_radius, r2=outer_radius, h=overall_thickness, center=false);
      }
    }
    translate([(width / 2), (depth / 2), 0]){
      cylinder(r1=(central_diameter / 2), r2=(central_diameter / 2), h=central_height, center=false);
    }
    hull(){
      translate([(width / 2), (depth / 2), (rib_lower_height / 2)]){
        cube([rib_width, depth, rib_lower_height], center=true);
      }
      translate([(width / 2), (depth / 2), (central_height / 2)]){
        cube([rib_width, central_diameter, central_height], center=true);
      }
    }
  }

  union(){
    translate([outer_radius, outer_radius, (-rib_thickness)]){
      cylinder(r1=(hole_diameter / 2), r2=(hole_diameter / 2), h=(overall_thickness + rib_thickness * 2), center=false);
    }
    translate([(width - outer_radius), outer_radius, (-rib_thickness)]){
      cylinder(r1=(hole_diameter / 2), r2=(hole_diameter / 2), h=(overall_thickness + rib_thickness * 2), center=false);
    }
    translate([outer_radius, (depth - outer_radius), (-rib_thickness)]){
      cylinder(r1=(hole_diameter / 2), r2=(hole_diameter / 2), h=(overall_thickness + rib_thickness * 2), center=false);
    }
    translate([(width - outer_radius), (depth - outer_radius), (-rib_thickness)]){
      cylinder(r1=(hole_diameter / 2), r2=(hole_diameter / 2), h=(overall_thickness + rib_thickness * 2), center=false);
    }
  }
  union(){
    translate([outer_radius, outer_radius, (overall_thickness - counterbore_depth)]){
      cylinder(r1=(counterbore_diameter / 2), r2=(counterbore_diameter / 2), h=(counterbore_depth + overall_thickness), center=false);
    }
    translate([(width - outer_radius), outer_radius, (overall_thickness - counterbore_depth)]){
      cylinder(r1=(counterbore_diameter / 2), r2=(counterbore_diameter / 2), h=(counterbore_depth + overall_thickness), center=false);
    }
    translate([outer_radius, (depth - outer_radius), (overall_thickness - counterbore_depth)]){
      cylinder(r1=(counterbore_diameter / 2), r2=(counterbore_diameter / 2), h=(counterbore_depth + overall_thickness), center=false);
    }
    translate([(width - outer_radius), (depth - outer_radius), (overall_thickness - counterbore_depth)]){
      cylinder(r1=(counterbore_diameter / 2), r2=(counterbore_diameter / 2), h=(counterbore_depth + overall_thickness), center=false);
    }
  }
  translate([(width / 2), (depth / 2), (-overall_thickness)]){
    cylinder(r1=(central_hole_diameter / 2), r2=(central_hole_diameter / 2), h=(central_height + overall_thickness * 2), center=false);
  }
  translate([(width / 2), (depth / 2), central_height]){
    cube([central_diameter, slot_width, (slot_depth * 2)], center=true);
  }
}