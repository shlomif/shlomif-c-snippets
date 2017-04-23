#include "colors.inc"
#include "stones.inc"
background { color Cyan }
camera {
    location <0, 2, -3>
    look_at  <0, 1,  2>
  }

sphere {
    <0, 1, 2>, 2
    texture {
      pigment { color Yellow }
    }
  }
plane { <0, 1, 0>, -1
    pigment {
      checker color Red, color Blue
    }
  }

light_source { <2, 4, -3> color White}

