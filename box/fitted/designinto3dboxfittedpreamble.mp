input designinto3dboxfitted;

input pockets;

intwidth = Width - Thickness * 2;
intlength = Length - Thickness * 2;

diam = diameter * u;

pcwidth = (intwidth - dividersthickness * dividerswidthwise) / (dividerswidthwise + 1);
pclength = (intlength - dividersthickness * dividerslengthwise) / (dividerslengthwise + 1);
halfclearance = Clearance / 2;

u=1mm; 