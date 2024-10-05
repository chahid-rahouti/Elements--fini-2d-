// Définir les points du pavé
Point(1) = {0, 0, 0, 1.0};
Point(2) = {1, 0, 0, 1.0};
Point(3) = {1, 1, 0, 1.0};
Point(4) = {0, 1, 0, 1.0};

// Définir les lignes du pavé
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

// Définir le contour et la surface
Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

// Raffinement du maillage
Field[1] = Distance;
Field[1].NodesList = {1, 2, 3, 4}; // Raffiner autour des coins
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 0.01; // Taille minimale des éléments
Field[2].LcMax = 0.1;  // Taille maximale des éléments
Field[2].DistMin = 0.1;
Field[2].DistMax = 0.5;
Background Field = 2;







// GMSH project
h = 0.1;
SetFactory("Built-in");

// Définir les points
Point(1) = {0, 0, 0, h};
Point(2) = {0.5, 0, 0, h};
Point(3) = {1, 0, 0, h};
Point(4) = {1, 0.5, 0, h};
Point(5) = {1, 1, 0, h};
Point(6) = {0.5, 1, 0, h};
Point(7) = {0, 1, 0, h};
Point(8) = {0, 0.5, 0, h};
Point(9) = {0.5, 0.5, 0, h};

// Définir les lignes
// Ligne pour le premier sous-domaine
Line(1) = {1, 2}; // bas
Line(2) = {2, 9}; // droite
Line(3) = {9, 8}; // haut
Line(4) = {8, 1}; // gauche

// Ligne pour le deuxième sous-domaine
Line(5) = {2, 3}; // bas
Line(6) = {3, 4}; // droite
Line(7) = {4, 9}; // haut
Line(8) = {9, 2}; // gauche

// Ligne pour le troisième sous-domaine
Line(9) = {9, 4}; // bas
Line(10) = {4, 5}; // droite
Line(11) = {5, 6}; // haut
Line(12) = {6, 9}; // gauche

// Ligne pour le quatrième sous-domaine
Line(13) = {8, 9}; // bas
Line(14) = {9, 6}; // droite
Line(15) = {6, 7}; // haut
Line(16) = {7, 8}; // gauche

// Définir les boucles de courbes pour chaque sous-domaine
Curve Loop(1) = {1, 2, 3, 4}; // Premier sous-domaine
Curve Loop(2) = {5, 6, 7, -2}; // Deuxième sous-domaine (utiliser -2 pour inverser le sens du contour)
Curve Loop(3) = {7, -12, -11, -10}; // Troisième sous-domaine (utiliser les valeurs négatives pour inverser le sens du contour)
Curve Loop(4) = {3, -16, -15, 12}; // Quatrième sous-domaine (idem)

// Définir les surfaces pour chaque sous-domaine
Plane Surface(1) = {1}; // Premier sous-domaine
Plane Surface(2) = {2}; // Deuxième sous-domaine
Plane Surface(3) = {3}; // Troisième sous-domaine
Plane Surface(4) = {4}; // Quatrième sous-domaine

// Définir le maillage transfinis pour toutes les surfaces
Transfinite Curve {1, 2, 3, 4} = 8 Using Progression 1; // Maillage uniforme pour les bords du grand carré
Transfinite Curve {5, 6, 7, 8} = 8 Using Progression 1; // Maillage uniforme pour les bords du deuxième sous-domaine
Transfinite Curve {9, 10, 11, 12} = 8 Using Progression 1; // Maillage uniforme pour les bords du troisième sous-domaine
Transfinite Curve {13, 14, 15, 16} = 8 Using Progression 1; // Maillage uniforme pour les bords du quatrième sous-domaine

// Appliquer le maillage transfinis globalement pour toutes les surfaces avec des directions alternées
Transfinite Surface {1} Right;
Transfinite Surface {2} Left;
Transfinite Surface {3} Left;
Transfinite Surface {4} Right;







// Gmsh project
h=0.1;
SetFactory("Built-in");
Point(1) = {0, 0, 0, h};
Point(2) = {0.5, 0, 0, h};
Point(3) = {1, 0, 0, h};
Point(4) = {1, 0.5, 0, h};
Point(5) = {1, 1, 0, h};
Point(6) = {0.5, 1, 0, h};
Point(7) = {0, 1, 0, h};
Point(8) = {0, 0.5, 0, h};
Point(9) = {0.5, 0.5, 0, h};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 9};
//+
Line(3) = {9, 8};
//+
Line(4) = {8, 1};
Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};
//+
Transfinite Curve {1, 2, 3, 4} = 5 Using Progression 1;
//+
Transfinite Surface {1};//+
Transfinite Surface {1} Right;
//+
Line(5) = {2, 3};
//+
Line(6) = {3, 4};
//+
Line(7) = {4, 9};
//+
Line(8) = {9, 2};
Curve Loop(2) = {5, 6, 7, 8};
Plane Surface(2) = {2};
//+
Transfinite Curve {5, 6, 7, 8} = 5 Using Progression 1;
//+
Transfinite Surface {2};//+
Transfinite Surface {2} Left;

//+
Line(9) = {9, 4};
//+
Line(10) = {4, 5};
//+
Line(11) = {5, 6};
//+
Line(12) = {6, 9};
Curve Loop(3) = {9, 10, 11, 12};
Plane Surface(3) = {3};
//+
Transfinite Curve {9, 10, 11, 12} = 5 Using Progression 1;
//+
Transfinite Surface {3};//+
Transfinite Surface {3} Right;
//+
Line(13) = {8, 9};
//+
Line(14) = {9, 6};
//+
Line(15) = {6, 7};
//+
Line(16) = {7, 8};
Curve Loop(4) = {13, 14, 15, 16};
Plane Surface(4) = {4};
//+
Transfinite Curve {13, 14, 15, 16} = 5 Using Progression 1;
//+
Transfinite Surface {4};//+
Transfinite Surface {4} Left;














// Gmsh project
h=0.1;
SetFactory("Built-in");
Point(1) = {0, 0, 0, h};
Point(2) = {0.5, 0, 0, h};
Point(3) = {1, 0, 0, h};
Point(4) = {1, 0.5, 0, h};
Point(5) = {1, 1, 0, h};
Point(6) = {0.5, 1, 0, h};
Point(7) = {0, 1, 0, h};
Point(8) = {0, 0.5, 0, h};
Point(9) = {0.5, 0.5, 0, h};
// ligne 1
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 9};
//+
Line(3) = {9, 8};
//+
Line(4) = {8, 1};
// ligne 2
//+
Line(5) = {2, 3};
//+
Line(6) = {3, 4};
//+
Line(7) = {4, 9};
//+
Line(8) = {9, 2};
// ligne 3
//+
Line(9) = {9, 4};
//+
Line(10) = {4, 5};
//+
Line(11) = {5, 6};
//+
Line(12) = {6, 9};
// ligne 4

//+
Line(13) = {8, 9};
//+
Line(14) = {9, 6};
//+
Line(15) = {6, 7};
//+
Line(16) = {7, 8};

// total 



//+
Line(17) = {1, 3};
//+
Line(18) = {3, 5};
//+
Line(19) = {5, 7};
//+
Line(20) = {7, 1};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {5, 6, 7, -2};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {7, -12, -11, -10};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {3, -16, -15, 12};
//+
Plane Surface(4) = {4};
//+
Transfinite Surface {1, 2, 3, 4};//+
Transfinite Surface {1, 2, 3, 4} Right,Left,Right,Left;

