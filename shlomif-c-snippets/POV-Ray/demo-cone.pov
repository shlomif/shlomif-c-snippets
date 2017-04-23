#include "colors.inc"
#include "stones.inc"
background { color Cyan }
camera {
    location <0, 2, -3>
    look_at  <0, 1,  2>
  }
cone {
    <0, 1, 0>, 0.3    // Center and radius of one end
    <1, 2, 3>, 1.0    // Center and radius of other end
    texture { T_Stone25 scale 4 }
  }

light_source { <2, 4, -3> color White}

