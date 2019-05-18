beginfig(1); 

rp(0,0,0,Width * u, Length * u, Thickness *u, diameter * u);

rp(Thickness/2 * u-halfclearance*u,Thickness/2 * u-halfclearance*u,0,Width * u - Thickness * u+Clearance*u, Length * u - Thickness * u+Clearance*u, Thickness *u-Thickness/4*u, diameter * u);

endfig;