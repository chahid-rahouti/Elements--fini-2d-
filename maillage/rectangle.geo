// Gmsh project
h=0.05;
SetFactory("Built-in");
Point(1) = {0, 0, 0, h};
Point(2) = {2, 0, 0, h};
Point(3) = {2, 1, 0, h};
Point(4) = {0, 1, 0, h};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

//Mesh.MshFileVersion = 2.2;
//Mesh 2;//+
SetFactory("Built-in");
//+
Transfinite Curve {1, 2, 3, 4} = 17 Using Progression 1;
//+
Transfinite Surface {1};