var data = require('./designinto3dboxfitted.json');


//https://stackoverflow.com/questions/21450227/how-would-you-import-a-json-file-into-javascript
//var mydata = JSON.parse(data);
//alert(mydata[0].DividerHeight);

$Boxshape = (data.parameterSets.export.Boxshape);
$Clearance = (data.parameterSets.export.Clearance);
$Height = (data.parameterSets.export.Height);
$Length = (data.parameterSets.export.Length);
$PARTNO = (data.parameterSets.export.PARTNO);
$Thickness = (data.parameterSets.export.Thickness);
$Width = (data.parameterSets.export.Width);
$depth = (data.parameterSets.export.depth);
$diameter = (data.parameterSets.export.diameter);
$dividers_lengthwise = (data.parameterSets.export.dividers_lengthwise);
$dividers_thickness = (data.parameterSets.export.dividers_thickness);
$dividers_widthwise = (data.parameterSets.export.dividers_widthwise);
$endmillshape = (data.parameterSets.export.endmillshape);
$largecompartment = (data.parameterSets.export.largecompartment);
$partspacing = (data.parameterSets.export.partspacing);

$feedrate = 400;
$dpp=2.25;
$cd=0;
$safeheight = 5;

feed($feedrate);     // Set the feed rate to 400 millimeters per minute
tool(201);       // Select tool 251

$tr = 1.5875;

rapid({z: $safeheight}); // Move to a safe height
rapid({x: -$tr, y: -$tr});  // Go to start position
speed(2000);   // Spin at 2000 RPM in the clockwise direction

cut({z: -$Thickness});  // Cut down to depth
cut({x: -$Width});  // Cut to second corner
cut({y: -$Length});  // Cut to second corner


//cut({y: -$Length});  



// Cut to third corner
//cut({y: -$Length});  // Cut to third corner
cut({x: -$tr});   // Cut to fourth corner
cut({y: -$tr});   // Cut back to begining

rapid({z: $safeheight}); // Move back to safe position

speed(0);      // Stop spinning
