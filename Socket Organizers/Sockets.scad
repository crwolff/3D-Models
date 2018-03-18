//
// Configuration
//

// The vectors
Sets = [
// 1/4" Socket sets
    [ "Craftsman Metric 6 Point",
      1.04,
      [ 0.451, 0.452, 0.452, 0.453, 0.452, 0.500, 0.546, 0.607, 0.673, 0.728 ],
      [ 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250 ] ],

    [ "Taiwan Metric 6 Point",
      1.04,
      [ 0.474, 0.486, 0.475, 0.475, 0.460, 0.490, 0.494, 0.553, 0.556, 0.671 ],
      [ 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250 ] ],

// 3/8" Socket sets
    [ "Craftsman Metric 12 Point",
      1.03,
      [ 0.649, 0.658, 0.655, 0.678, 0.723, 0.775, 0.812, 0.862, 0.926, 0.952, 1.004 ],
      [ 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375 ] ],
    
    [ "Craftsman Metric 6 Point",
      1.04,
      [ 0.650, 0.655, 0.655, 0.676, 0.723, 0.774, 0.811, 0.916, 1.002 ],
      [ 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375 ] ],

    [ "Taiwan Metric 6 Point",
      1.04,
      [ 0.669, 0.671, 0.670, 0.670, 0.710, 0.788, 0.865, 0.945, 1.026 ],
      [ 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375 ] ],

// 1/2" Socket sets
    [ "Craftsman Metric 12 Point",
      1.04,
      [ 0.865, 0.869, 0.875, 0.935, 0.994, 1.027, 1.103, 1.137, 1.254, 1.312, 1.408, 1.645 ],
      [ 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500 ] ],
];

DeepSets = [
// 1/4" Socket sets
    [ "Craftsman Metric 6 Point",
      1.04,
      2.007, 
      0.750,
      [ 0.443, 0.444, 0.492, 0.538, 0.605, 0.678, 0.695, 0.780 ],
      [ 0.424, 0.444, 0.492, 0.538, 0.605, 0.678, 0.695, 0.780 ],
      [ 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250, 0.250 ] ],
];

// Extract set information
Name =      (Selector < 20) ? Sets[Selector][0] : DeepSets[Selector-20][0];
Shrinkage = (Selector < 20) ? Sets[Selector][1] : DeepSets[Selector-20][1];
Len_in =    (Selector < 20) ? 1                 : DeepSets[Selector-20][2]; // Overall length
Len2_in =   (Selector < 20) ? 1                 : DeepSets[Selector-20][3]; // Length of smaller OD
OD_in =     (Selector < 20) ? Sets[Selector][2] : DeepSets[Selector-20][4]; // Larger OD
OD2_in =    (Selector < 20) ? Sets[Selector][2] : DeepSets[Selector-20][5]; // Smaller OD
PinD_in =   (Selector < 20) ? Sets[Selector][3] : DeepSets[Selector-20][6];
