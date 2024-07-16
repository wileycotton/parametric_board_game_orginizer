include <BOSL/constants.scad>
use <BOSL/joiners.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

$fa = 1;
$fs = 0.4;


module innerBoxMask(x, y, z , wallThickness)
{
    for(i=[
        [(x - wallThickness),0,0],
        [(x - wallThickness)*-1,0,0],
        [0,(y - wallThickness),0],
        [0,(y - wallThickness)*-1,0]]) 
    {
        translate(i)
        cuboid(size=[x,y,z], edges=EDGES_TOP, center=true);
    }
};

module lockingNotch(
    x, y, z,
    radius,
    lidOverlap)
{
    for(i=[-1:2:1]) 
    {
            ymove(i * (y/2)) zmove(z-(lidOverlap/2)) zmove(radius)
            zscale(-0.5)
        cyl(r=radius, 
            h=(x * 0.25),
            fillet=(radius * 0.5),
            orient=ORIENT_X,
            center=true);
    }
}

module boxShell(
        x, y, z,
        wallThickness,
        floorThickness,
        boxFillet,
        edges=EDGES_TOP + EDGES_Z_ALL + EDGES_BOTTOM,
        center=true )
{
    zmove(z/2) // move bottom to be at zero
    intersection() { // Creates shell (ineficient but fine, simple difference would be better)
        cuboid(size=[x,y,z], fillet=boxFillet, edges=edges, center=center);
        innerBoxMask(
            x=x,
            y=y,
            z=z,
            wallThickness=wallThickness);
    };
    // create floor
    zmove(floorThickness/2) cuboid(size=[x,y,floorThickness], fillet=boxFillet, edges=edges, center=true);
};


boxShell(
    x=10,
    y=10,
    z=10,
    wallThickness=0.5,
    floorThickness=2,
    boxFillet=1
    );


lockingNotch(
    x=10,
    y=10,
    z=10,
    radius=0.5,
    lidOverlap=4
);


/*
boxAndLid(
    x=10,
    y=10,
    z=10,
    boxFillet=2,
    lidFillet=2);
*/