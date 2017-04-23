#include "colors.inc"
  background{White}
  camera {
    angle 20
    location <2, 10, -30>
    look_at <0, 1, 0>
  }
  light_source { <20, 20, -20> color White }
  prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    1, // ... up through here
    7, // the number of points making up the shape ...
    <3,5>, <-3,5>, <-5,0>, <-3,-5>, <3, -5>, <5,0>, <3,5>
    pigment { Green }
  }

