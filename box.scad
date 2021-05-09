thickness = 1.5;
layerLenght = 70;//层高
xLenght = 150;
yLenght = 150;
zLenght = layerLenght * 2 + thickness * 3;
cube([xLenght, yLenght, thickness]);
cube([xLenght, thickness, zLenght]);
cube([thickness, yLenght, zLenght]);

translate([0, 0, zLenght - thickness]) {
    cube([xLenght, yLenght, thickness]);
}
translate([0, yLenght - thickness, 0]) {
    cube([xLenght, thickness, zLenght]);
}

translate([0, 0, layerLenght + thickness]) {
    cube([xLenght, yLenght, thickness]);
}