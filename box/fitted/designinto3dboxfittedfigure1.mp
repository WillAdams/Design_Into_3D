beginfig(1); 

rpf(-diam,-diam,0,Width * u + diam*2, Length * u + diam*2, Thickness *u, diameter * u,0.0);

rpu(0,0,0,Width * u, Length * u, Thickness *u, diam);

%fill 
rpf(Thickness/2 * u-halfclearance*u,Thickness/2 * u-halfclearance*u,0,Width * u - Thickness * u+Clearance*u, Length * u - Thickness * u+Clearance*u, Thickness *u-Thickness/4*u, diam,0.5) 
%withgreyscale 0.5;

%fill (0,0)--(100,0)--(100,100)--(0,100)--cycle withgreyscale 0.5;

endfig;