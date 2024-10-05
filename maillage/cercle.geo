h=0.1;
//+
SetFactory("Built-in");
//+
Point(1) = {0, -1, 0, h};
//+
Point(2) = {0, 0, 0, h};
//+
Point(3) = {0, 1, 0, h};
//+
Circle(1) = {1, 2, 3};
//+
Circle(2) = {3, 2, 1};
//+
Curve Loop(1) = {2, 1};
//+
Plane Surface(1) = {1};


SetFactory("OpenCASCADE");
//Circle(1) = {0, 0, 0, 1, 0, 2*Pi};
//+
//Curve Loop(1) = {1};
//+
//Plane Surface(1) = {1};