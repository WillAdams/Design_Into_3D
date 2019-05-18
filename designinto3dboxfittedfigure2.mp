beginfig(2); 

rp(0,0,0,Width * u, Length * u, Thickness *u, diameter * u);

rp(Thickness/2 * u+halfclearance*u,Thickness/2 * u+halfclearance*u,0,Width * u - Thickness * u-Clearance*u, Length * u - Thickness * u-Clearance*u, Thickness *u-Thickness/4*u, diameter * u);

drawit :=0;
drawn :=0;
for i=0 upto dividerswidthwise:
for j=0 upto dividerslengthwise: 
if (j = 0) :
if (i mod 2) = 0 :
if (largecompartment = 2): 
rp(Thickness/2 * u+dividersthickness*u,Thickness/2 * u+dividersthickness*u+pclength*j*u+dividersthickness*j*u,0,intwidth* u, pclength  *u, Thickness *u-Thickness/2*u, diameter * u);
drawn :=1;
drawit :=0;
fi
fi
else:
drawit :=1;
fi


if (i mod 2) = 1 :
if (largecompartment = 1): 
drawit :=0;
if (j = 0) :
rp(Thickness/2 * u+dividersthickness*u+pcwidth*i*u+dividersthickness*i*u,Thickness/2 * u+dividersthickness*u+pclength*j*u+dividersthickness*j*u,0,pcwidth* u, intlength  *u, Thickness *u-Thickness/2*u, diameter * u);
drawn :=1;
fi
fi
else:
if (largecompartment = 1) :
drawit :=1;
fi
fi

if (largecompartment = 0) :
drawit :=1;
fi

if (drawit = 1) :
rp(Thickness/2 * u+dividersthickness*u+pcwidth*i*u+dividersthickness*i*u,Thickness/2 * u+dividersthickness*u+pclength*j*u+dividersthickness*j*u,0,pcwidth* u, pclength  *u, Thickness *u-Thickness/2*u, diameter * u);
fi
drawit :=0;
drawn :=0;
endfor;
drawn :=0;
drawit :=0;
endfor;

endfig;