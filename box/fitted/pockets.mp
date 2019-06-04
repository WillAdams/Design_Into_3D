%module HP(x,y,z,w,l,h,d){hull()
def hp (expr x,y,z,w,l,h,d) =
draw(x,y)--(w,y)--(w,l)--(x,l)--cycle;
enddef;

def hpr (expr x,y,z,w,l,h,d) =
draw(x,y)--(w,y)--(w,l)--(x,l)--cycle withcolor red;
enddef;

def trp (expr x,y,a,b,e,f,z,h,d) =
draw(x,y)--(a,b)--(e,f)--cycle;
enddef;

def trpr (expr x,y,a,b,e,f,z,h,d) =
draw(x,y)--(a,b)--(e,f)--cycle withcolor red;
enddef;

def hc (expr x,y,z,w,l,h,d) =
pair A, B, C, D;
A:=(w/2,0+y); B:=(w-x,l/2);
C:=(w/2,l-y); D:=(0+x,l/2);
draw A..B..C..D..cycle;
enddef;

def cc (expr x,y,d) =
pair t,b,l,r;
t:=(x,y+d/2); b:=(x,y-d/2);l:=(x-d/2,y);r:=(x+d/2,y);
draw t..l..b..r..cycle;
enddef;

def rp (expr x,y,z,w,l,t,d) =
draw(x,y+ t)..(x+t/3.41397849, y+t/3.41397849)..(x+t,y+0)--(x+w - t,y+0)..(x+w - t/3.41397849, y+t/3.41397849)..(x+w,y+t)--(x+w,y+l - t)..(x+w - t/3.41397849,y+l - t/3.41397849)..(x+w - t,y+l)--(x+t,y+l)..(x+t/3.41397849,y+l - t/3.41397849)..(x, y+l - t)--cycle;
enddef;

def rpf (expr x,y,z,w,l,t,d,f) =
fill (x,y+ t)..(x+t/3.41397849, y+t/3.41397849)..(x+t,y+0)--(x+w - t,y+0)..(x+w - t/3.41397849, y+t/3.41397849)..(x+w,y+t)--(x+w,y+l - t)..(x+w - t/3.41397849,y+l - t/3.41397849)..(x+w - t,y+l)--(x+t,y+l)..(x+t/3.41397849,y+l - t/3.41397849)..(x, y+l - t)--cycle withgreyscale f;
enddef;

def rpu (expr x,y,z,w,l,t,d) =
unfill (x,y+ t)..(x+t/3.41397849, y+t/3.41397849)..(x+t,y+0)--(x+w - t,y+0)..(x+w - t/3.41397849, y+t/3.41397849)..(x+w,y+t)--(x+w,y+l - t)..(x+w - t/3.41397849,y+l - t/3.41397849)..(x+w - t,y+l)--(x+t,y+l)..(x+t/3.41397849,y+l - t/3.41397849)..(x, y+l - t)--cycle;
enddef;
