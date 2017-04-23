#include "colors.inc"
  camera {
    location <0, 1, -10>
    look_at 0
    angle 36
  }
  light_source { <500, 500, -1000> White }
  plane { y, -1.5
    pigment { checker Green White }
}
#declare Lens_With_Hole = difference {
    intersection {
      sphere { <0, 0, 0>, 1
        translate -0.5*x
      }
      sphere { <0, 0, 0>, 1
        translate 0.5*x
      }
      rotate 90*y
    }
    cylinder { <0, 0, -1> <0, 0, 1>, .35 }
  }
merge {
    object { Lens_With_Hole translate <-.65, .65, 0> }
    object { Lens_With_Hole translate <.65, .65, 0> }
    object { Lens_With_Hole translate <-.65, -.65, 0> }
    object { Lens_With_Hole translate <.65, -.65, 0> }
    pigment { Red filter 0.5 }
  }
