#include "colors.inc"
  camera {
    location <0, .1, -25>
    look_at 0
    angle 30
  }
  background { color Gray50 }
  light_source{ <300, 300, -1000> White }
#declare Chain_Gold = texture {
    pigment { BrightGold }
    finish {
      ambient .1
      diffuse .4
      reflection .25
      specular 1
      metallic
    }
  }

  #declare Half_Torus = difference {
    torus {
      4,1
      sturm
      rotate x*-90  // so we can see it from the top
    }
    box { <-5, -5, -1>, <5, 0, 1> }
    texture { Chain_Gold}
  }
  #declare Flip_It_Over = x*180;
  #declare Torus_Translate = 8;
  #declare Chain_Segment = cylinder {
    <0, 4, 0>, <0, -4, 0>, 1
    texture { Chain_Gold}
  }
  #declare Link = union {
    object {
      Half_Torus
      translate y*Torus_Translate/2
    }
    object {
      Half_Torus
      rotate Flip_It_Over
      translate -y*Torus_Translate/2
    }
    object {
      Chain_Segment
      translate x*Torus_Translate/2
    }
    object {
      Chain_Segment
      translate -x*Torus_Translate/2
    }
    texture { Chain_Gold }
  }
#declare Link_Translate = Torus_Translate*2-2*y;

#declare Link_Pair =
  union {
    object { Link }
    object { Link translate y*Link_Translate rotate y*90 }
  }
 #declare Chain = union {
    object { Link_Pair}
    object { Link_Pair translate  y*Link_Translate*2 }
    object { Link_Pair translate  y*Link_Translate*4 }
    object { Link_Pair translate  y*Link_Translate*6 }
    object { Link_Pair translate -y*Link_Translate*2 }
    object { Link_Pair translate -y*Link_Translate*4 }
    object { Link_Pair translate -y*Link_Translate*6 }
  }
object { Chain scale .1 rotate <0, 45, -45> }





