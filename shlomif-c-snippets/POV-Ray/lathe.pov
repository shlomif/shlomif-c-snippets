#include "colors.inc"
  background{White}
  camera {
    angle 10
    location <1, 9, -50>
    look_at <0, 2, 0>
  }
  light_source {
    <20, 20, -20> color White
  }
  lathe {
    linear_spline
    6,
    <0,0>, <1,1>, <3,2>, <2,3>, <2,4>, <0,4>
    pigment { Blue }
    finish {
      ambient .3
      phong .75
    }
  }

