//Please use the Customizer to interact with this (if necessary, show it by clearing the checkbox in front of View | Hide Customizer), and close this Editor window.

/* [Overview] */
//Part
PARTNO = "0"; // [0:All, 1:Top, 2:Bottom]

//Type of Lid (to implement: 2:Hinged)
LidType = "0"; // [0:None, 1:Fitted]

//Type of Corner (to implement: 3:Chamfered, 4:Inset Circle (Flipped Fillet))
BoxShape = "0"; // [0:Round/Oval, 1:Square, 2:Rounded (Fillet)]

//Size of Corner Feature
cornersize=0.25;


//Height of box bottom (expressed as a percentage if using a lid)
boxbottomheight=50; // [0:100]

//Endmill Diameter
diameter=0.125;

//Fit Tolerance
fittolerance=0.001;

//Part Spacing
partspacing=2;

$fa=1;
$fs=1;
//$fn=100;

//Units
Units="0"; // [0:Inches, 1:Millimeters]

/* [Size] */
//Length
length = 3;

//Width
width = 2;

//Height
height = 2;

//Thickness
thickness = 0.375;

//Lid and Bottom Thickness
bottomthickness=0.125;

/* [Dividers] */
//Number of Dividers
Dividers = 0;

//Orientation of Dividers
DividerOrientation = "0"; // [0:widthwise, 1:lengthwise, 2:grid, 3:diagonal, 4:grid with lengthwise pocket, 5:grid with widthwise pocket]


conversionfactor = (Units=="0") ? 25.4 : 1;

cwidth = width*conversionfactor;
clength = length*conversionfactor;
cheight = height*conversionfactor;
cthickness = thickness*conversionfactor;
cbottomthickness=bottomthickness*conversionfactor;
cpartspacing=partspacing*conversionfactor;

ccs=cornersize*conversionfactor;

cdiameter = diameter*conversionfactor;
ctolerance = fittolerance*conversionfactor;

cinteriorwidth = cwidth-cthickness*2;
cinteriorlength = clength-cthickness*2;

cinteriorheight=cheight-cbottomthickness*2-cthickness;

//Height of Dividers (percentage of interior height)
//DividerHeight = 50; //[0:100]

//cdivheight=cinteriorheight*DividerHeight/100;

Divs=Dividers+1;

cadjh=cbottomthickness*2+((cheight-cbottomthickness*2)*boxbottomheight/100)-cdiameter;


module HP(x,y,z,w,l,h,d){hull() {
translate([x+d/2,y+d/2,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
translate([w+x-d/2,y+d/2,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
translate([w+x-d/2,l+y-d/2,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
translate([x+d/2,l+y-d/2,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
};};

module pocket(x,y,z,a,b,c,e,h,d){hull() {
translate([x,y,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
translate([a,b,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
translate([c,e,z]) cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
};};

module chamferedbox(x,y,z,w,l,h,d){difference() {translate([x,y,z]) cube(size = [w,l,h], center = false);
union(){
rotate([0,0,45]) translate([-d,-d,-h/10])cube(size = [d*2,d*2,h*1.2], center = false);
translate([cwidth,-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
translate([cwidth,clength-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
translate([0,clength-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
};
}
};

module ogeebox(x,y,z,w,l,h,d){difference() {translate([x,y,z]) cube(size = [w,l,h], center = false);
union(){
rotate([0,0,45]) translate([-d,-d,-h/10])cube(size = [d*2,d*2,h*1.2], center = false);
translate([cwidth,-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
translate([cwidth,clength-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
translate([0,clength-d*1.5,-h/10])rotate([0,0,45]) cube(size = [d*2,d*2,h*1.2], center = false);
};
}
};

//if (cwidth == clength) 
//{
    xs = 1;
    ys = 1;
//}
    
if (cwidth > clength) {xs = cwidth/clength;
    ys = 1;}

if (cwidth < clength) 
{xs = 1;
    ys = clength/cwidth;}
//else



//Bottom
module Bottom() {difference(){
    union() {
//cylinder(h = h, r1 = d/2, r2 = d/2, center = false);
if (BoxShape=="0" && cwidth == clength) translate([cwidth/2,clength/2,0])cylinder(h = cadjh, r1 = cwidth/2, r2 = cwidth/2, center = false);
if (BoxShape=="0" && cwidth > clength) translate([cwidth/2,clength/2,0])scale([cwidth/clength,1,1]) cylinder(h = cadjh, r1 = clength/2, r2 = clength/2, center = false);
if (BoxShape=="0" && cwidth < clength) translate([cwidth/2,clength/2,0])scale([1,clength/cwidth,1]) cylinder(h = cadjh, r1 = cwidth/2, r2 = cwidth/2, center = false);
if (BoxShape=="1") cube(size = [cwidth,clength,cadjh], center = false);
if (BoxShape=="2") HP(0,0,0,cwidth,clength,cadjh,ccs);
if (BoxShape=="3") chamferedbox(0,0,0,cwidth,clength,cadjh,ccs);
if (BoxShape=="4") ogeebox(0,0,0,cwidth,clength,cadjh,ccs);
    
if (BoxShape=="0" && cwidth == clength) 
{translate([cwidth/2,clength/2,cbottomthickness]) cylinder(h = cadjh, r1 = (cwidth-cthickness)/2, r2 = (cwidth-cthickness)/2, center = false);}

if (BoxShape=="0" && cwidth > clength) 
{translate([cwidth/2,clength/2,cbottomthickness]) scale([cwidth/clength,1,1]) cylinder(h = cadjh, r1 = (clength-cthickness)/2, r2 = (clength-cthickness)/2, center = false);}

if (BoxShape=="0" && cwidth < clength) 
{translate([cwidth/2,clength/2,cbottomthickness]) scale([1,clength/cwidth,1]) cylinder(h = cadjh, r1 = (cwidth-cthickness)/2, r2 = (cwidth-cthickness)/2, center = false);}


if (BoxShape!="0")
  HP(cthickness-cdiameter,cthickness-cdiameter,cbottomthickness,cwidth-cthickness*2+cdiameter*2,clength-cthickness*2+cdiameter*2,cadjh,cdiameter);  
};

if (BoxShape=="0" && cwidth == clength)
{       
translate([cwidth/2,cwidth/2,cbottomthickness])cylinder(h = cheight, r1 = (cwidth-cthickness-cdiameter*2)/2, r2 = (cwidth-cthickness-cdiameter*2)/2, center = false);
}

if (BoxShape=="0" && cwidth > clength)
{       
translate([cwidth/2,clength/2,cbottomthickness]) scale([1,clength/cwidth,1]) cylinder(h = cheight, r1 = (cwidth-cthickness*2-cdiameter)/2, r2 = (cwidth-cthickness*2-cdiameter)/2, center = false);
}

if (BoxShape=="0" && cwidth < clength)
{       
translate([cwidth/2,clength/2,cbottomthickness]) scale([cwidth/clength,1,1]) cylinder(h = cheight, r1 = (clength-cthickness*2-cdiameter)/2, r2 = (clength-cthickness*2-cdiameter)/2, center = false);
}

if (Dividers == 0 && BoxShape!="0")
{       
HP(cthickness,cthickness,cbottomthickness,cwidth-cthickness*2,clength-cthickness*2,cheight,cdiameter);
}
{
if ((Dividers >= 1)&&(DividerOrientation == "0") && (BoxShape!="0"))
   {for (i = [1 : Divs]){
pocket=(clength-cthickness*2-cdiameter*(Dividers))/(Divs);
//(x,y,z,w,l,h,d)
HP(
//x
cthickness,
//y
cthickness+(pocket*(i-1))+cdiameter*(i-1),
//z
cbottomthickness,
//width
cwidth-cthickness-cdiameter*2,
//length
pocket,
cheight,
cdiameter);
};
};
};
{
if ((Dividers >= 1)&&(DividerOrientation == "1") && BoxShape!="0")
   {for (i = [1 : Divs]){
pocket=(cwidth-cthickness*2-cdiameter*(Dividers))/(Divs);
//(x,y,z,w,l,h,d)
HP(
//x
cthickness+(pocket*(i-1))+cdiameter*(i-1),
//y
cthickness,
//z
cbottomthickness,
//width
pocket,
//length
clength-cthickness-cdiameter*2,
cheight,
cdiameter);
   };
};
};


{
if ((Dividers >= 1)&&(DividerOrientation == "2") && BoxShape!="0")
   {pocketwidth=(cwidth-cthickness*2-cdiameter*(Dividers))/(Divs);
pocketlength=(clength-cthickness*2-cdiameter*(Dividers))/(Divs);
for (i = [1 : Divs], j = [1 : Divs])
       //
{
//i=1;
//j=1;
//(x,y,z,w,l,h,d)
HP(
//x
cthickness+(pocketwidth*(i-1))+cdiameter*(i-1),
//y
cthickness+(pocketlength*(j-1))+cdiameter*(j-1),
//z
cbottomthickness,
//width
pocketwidth,
//length
pocketlength,
cheight,
cdiameter);};
};
};




{
if ((Dividers == 1)&&(DividerOrientation == "3") && BoxShape!="0")
   {//(x,y,z,a,b,c,e,h,d)
pocket(//x
       cthickness+cdiameter/2,
       //y
       cthickness+cdiameter/2,
       //z
       cbottomthickness,
       //a
       cwidth-cthickness-cdiameter*2,
       //b
       cthickness+cdiameter/2,
       //c
       cthickness+cdiameter/2,
       //e
       clength-cthickness-cdiameter*2,
       cheight,cdiameter);
   
pocket(cwidth-cthickness-cdiameter/2,clength-cthickness-cdiameter/2,cbottomthickness,cthickness+cdiameter*2,clength-cthickness-cdiameter/2,cwidth-cthickness-cdiameter/2,cthickness+cdiameter*2,cheight,cdiameter);
};
};


{
if ((Dividers > 1)&&(DividerOrientation == "3") && BoxShape!="0")
   {//(x,y,z,a,b,c,e,h,d)
pocket(//x
       cthickness+cdiameter/2,
       //y
       cthickness+cdiameter*2,
       //z
       cbottomthickness,
       //a
       cwidth/2-cthickness+cdiameter/2,
       //b
       clength/2,
       //c
       cthickness+cdiameter/2,
       //e
       clength-cthickness-cdiameter*2,
       cheight,cdiameter);
pocket(//x
       cwidth-cthickness-cdiameter/2,
       //y
       cthickness+cdiameter*2,
       //z
       cbottomthickness,
       //a
       cwidth/2+cthickness-cdiameter/2,
       //b
       clength/2,
       //c
       cwidth-cthickness-cdiameter/2,
       //e
       clength-cthickness-cdiameter*2,
       cheight,cdiameter);
pocket(cwidth-cthickness-cdiameter*2,
   clength-cthickness-cdiameter/2,
   cbottomthickness,
   cthickness+cdiameter*2,clength-cthickness-cdiameter/2,
   cwidth/2,
   clength/2+cthickness-cdiameter/2,
   cheight,cdiameter);
pocket(cwidth-cthickness-cdiameter*2,
   cthickness+cdiameter/2,
   cbottomthickness,
   cthickness+cdiameter*2,cthickness+cdiameter/2,
   cwidth/2,
   clength/2-cthickness+cdiameter/2,
   cheight,cdiameter);
};};

{
if ((Dividers >= 1)&&(DividerOrientation == "4") && BoxShape!="0")
   {pocketwidth=(cwidth-cthickness*2-cdiameter*(Dividers))/(Divs);
pocketlength=(clength-cthickness*2-cdiameter*(Dividers))/(Divs);
for (i = [1 : Divs], j = [1 : Divs])
       //
{
HP(
//x
cthickness+(pocketwidth*(i-1))+cdiameter*(i-1),
//y
cthickness+(pocketlength*(j-1))+cdiameter*(j-1),
//z
cbottomthickness,
//width
pocketwidth,
//length
pocketlength,
cheight,
cdiameter);};

if (Dividers % 2 == 0) {
pocket=(cwidth-cthickness*2-cdiameter*(Dividers))/(Divs);
//(x,y,z,w,l,h,d)
HP(
//x
//cthickness,
cwidth/2-pocket/2,
//y
cthickness,
//z
cbottomthickness,
//width
pocket,
//length
clength-cthickness-cdiameter*2,
cheight,
cdiameter);
}
};
};


{
if ((Dividers >= 1)&&(DividerOrientation == "5") && BoxShape!="0")
   {pocketwidth=(cwidth-cthickness*2-cdiameter*(Dividers))/(Divs);
pocketlength=(clength-cthickness*2-cdiameter*(Dividers))/(Divs);
for (i = [1 : Divs], j = [1 : Divs])
       //
{
//i=1;
//j=1;
//(x,y,z,w,l,h,d)
HP(
//x
cthickness+(pocketwidth*(i-1))+cdiameter*(i-1),
//y
cthickness+(pocketlength*(j-1))+cdiameter*(j-1),
//z
cbottomthickness,
//width
pocketwidth,
//length
pocketlength,
cheight,
cdiameter);};

pocket=(clength-cthickness*2-cdiameter*(Dividers))/(Divs);
//(x,y,z,w,l,h,d)
HP(
//x
cthickness,
//y
cthickness,
//z
cbottomthickness,
//width
cwidth-cthickness-cdiameter*2,
//length
pocket,
cheight,
cdiameter);

};
};
}

{
if (BoxShape=="0" && cwidth == clength && DividerOrientation == "0" && DividerOrientation != "3") {
    //rotate(a = [0, 0, 90]) 
    translate(v = [cwidth/2, clength/2, cheight/2+cbottomthickness/4])  
    for ( i = [1 : Dividers] ){
    rotate(a = [0, 0, 180/Dividers*i]) 
    cube(size = [cdiameter,clength-cthickness*2+cdiameter,cheight-cbottomthickness/2], center = true);}
}}
{
if ((Dividers >= 1)&& BoxShape=="0" && cwidth == clength && DividerOrientation == "3")
{       
translate([cwidth/2,cwidth/2,cbottomthickness])intersection() {cylinder(h = cadjh, r1 = (cwidth-cthickness-cdiameter*2)/2, r2 = (cwidth-cthickness-cdiameter*2)/2, center = false);
    union(){
   translate([0,-cwidth/4-cdiameter/2,0]) difference(){cylinder(h = cheight,r1=cwidth/4+cdiameter,r2=cwidth/4+cdiameter);union(){cylinder(h = cheight*1.1,r1=cwidth/4,r2=cwidth/4);;translate([-cwidth/2,-cwidth/4+cdiameter,0])cube(size = [cwidth/2,cwidth/2,cheight*2], center = false);}}
    translate([0,cwidth/4+cdiameter/2,0]) difference(){cylinder(h = cheight,r1=cwidth/4+cdiameter,r2=cwidth/4+cdiameter); union(){cylinder(h = cheight*1.1,r1=cwidth/4,r2=cwidth/4);translate([0,-cwidth/4-cdiameter,0])cube(size = [cwidth,clength,cheight*2], center = false);}
}}
   }
}

if (LidType == "0") {translate ([0,0,cadjh]) cube(size = [cwidth,clength,(cheight-cheight*boxbottomheight/100)+cdiameter*2], center = false);} 


//translate([cwidth/2,clength/2,0]) #cylinder(h = cheight*2, r1 = cdiameter/2, r2 = cdiameter/2, center = false);
};
};


//Top
module Top() {
    translate([0,clength+cpartspacing,0]){
    difference(){
    union() {
//cube(size = [cwidth,clength,(cheight-cheight*boxbottomheight/100)+cdiameter*2], center = false);
if (BoxShape=="0" && cwidth == clength) translate([cwidth/2,cwidth/2,0])cylinder(h = (cheight-cheight*boxbottomheight/100)+cdiameter*2, r1 = cwidth/2, r2 = cwidth/2, center = false);
if (BoxShape=="0" && cwidth > clength) translate([cwidth/2,clength/2,0])scale([1,clength/cwidth,1]) cylinder(h = (cheight-cheight*boxbottomheight/100)+cdiameter*2, r1 = cwidth/2, r2 = cwidth/2, center = false);
if (BoxShape=="0" && cwidth < clength) translate([cwidth/2,clength/2,0])scale([cwidth/clength,1,1]) cylinder(h = (cheight-cheight*boxbottomheight/100)+cdiameter*2, r1 = clength/2, r2 = clength/2, center = false);
if (BoxShape=="1") cube(size = [cwidth,clength,(cheight-cheight*boxbottomheight/100)+cdiameter*2], center = false);
if (BoxShape=="2") HP(0,0,0,cwidth,clength,(cheight-cheight*boxbottomheight/100)+cdiameter*2,ccs);

    };

//if (Dividers == 0)
{if (BoxShape=="0" && cwidth == clength) translate([cwidth/2,cwidth/2,cbottomthickness]) cylinder(h = cheight, r1 = (cwidth-cthickness)/2, r2 = (cwidth-cthickness)/2, center = false);

if (BoxShape=="0" && cwidth < clength) translate([cwidth/2,clength/2,cbottomthickness]) scale([cwidth/clength,1,1]) cylinder(h = cheight, r1 = (clength-cthickness)/2, r2 = (clength-cthickness)/2, center = false);

if (BoxShape=="0" && cwidth > clength) translate([cwidth/2,clength/2,cbottomthickness]) scale([1,clength/cwidth,1]) cylinder(h = cheight, r1 = (cwidth-cthickness)/2, r2 = (cwidth-cthickness)/2, center = false);

if (BoxShape!="0")
HP(cthickness-cdiameter-ctolerance/2,cthickness-cdiameter-ctolerance/2,cbottomthickness,cwidth-cthickness*2+cdiameter*2+ctolerance/2,clength-cthickness*2+cdiameter*2+ctolerance/2,cheight*2,cdiameter);
};              
};
};
};


// [[0:All, 1:Top, 2:Bottom,3:Dividers]
//[0:None, 1:Fitted, 2:Hinged]

 if (PARTNO == "1") Top();
 if (PARTNO == "2") Bottom();
       
  // optionally use 0 for whole object
 if (PARTNO == "0") {
 if (LidType == "1")   Top();
  Bottom();
 }
 
 if (PARTNO == "3") {
for (i = [-1, 1]){
    translate([0, 0, i])
    cube(size = 1, center = false);
}

 }; 
//module HP(x,y,z,w,l,h,d)
//HP(0,0,0,25,50,12,6.35);
 
//#cube([cwidth,clength,120]);
