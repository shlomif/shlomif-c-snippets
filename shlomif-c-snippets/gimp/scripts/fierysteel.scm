; =====================================================================
; Fiery Steel - yet another silly script from WWWWolf
; =====================================================================
; Copyright (C) 9.5.1998 Urpo Lankinen.
; Greatly enhanced on 19.5.1998.
; Also added some tiny little enhancements on 29.5.1998
; More enhancements 18-19.7.1998
;  Distributed under GPL. Permission granted to distribute this script
;  with *anything* that has *something* to do with The GIMP.
; =====================================================================
;
; E-mail: <wwwwolf@iki.fi> Homepage: <URL:http://www.iki.fi/wwwwolf/>
;
; RCS: $Id: fierysteel.scm,v 1.5.1.0 2000/10/24 09:18:45 wwwwolf Exp wwwwolf $
;
; This script was inspired by "Terminator 2: Judgement Day"
; opening scene.
;
; The result: letters of steel (well, aluminium...) in hellfire.
; "You know, it was not really easy for a mere layman to figure out
; the flame-generation script"... but with a dragon around, it was
; much easier.
;
; For coolest results, Use Scott font from CorelDRAW!...
; (But Crillee/FreeFonts produces pretty kewl results, too.)
;
; I should make that Slab thing to make better "Terminator 2:
; Lookandfeeliation Day" effect...
;
; Terminator 2 fonts for free, anyone?
;

(define (script-fu-fiery-steel
     text font size grad perc txtbord darkentog
     ; slabtog
     fierytog sprd rndamt fulltog
     turbultog turbulence
;  turbdetail
;     sendtog ; Does not work, drats...
     )
  ; �ydx, that was a looooong feature list.
  (let* ((img (car (gimp-image-new 256 256 RGB)))
     (bg-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE
                        size PIXELS font)))
     (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE
                        size PIXELS font)))
     (width (car (gimp-drawable-width text-layer)))
     (height (car (gimp-drawable-height text-layer)))
     (text2-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE
                        size PIXELS font)))
     (brd-layer
      (car (gimp-layer-new img width height
                   GRAYA-IMAGE "border" 100 LAYER-MODE-OVERLAY-LEGACY)))

     (old-fg (car (gimp-context-get-foreground)))
     (old-bg (car (gimp-context-get-background))))

    (gimp-context-push)
    ; Previously it just jammed at merge-visible-layers, but when
    ; I added this, it somehow started working... Dunno why. =/
    (verbose 4)

    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer "Text")
    (gimp-drawable-set-name text2-layer "Text2")
    (gimp-drawable-set-name bg-layer "Bg")
    (gimp-image-resize img width height 0 0)

    ; �KS�N =========================================================

    ; Background

    (gimp-image-set-active-layer img bg-layer)
    (gimp-selection-all img)
    (gimp-context-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill bg-layer FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY 100 255 FALSE 1 1)
    (gimp-context-set-foreground old-fg)
    (gimp-selection-none img)

    ; Do the gradient
    (gimp-image-set-active-layer img text2-layer)
    (gimp-layer-set-preserve-trans text2-layer TRUE)     ; Preserve trans.
    (gimp-context-set-gradient grad)
    (gimp-edit-blend text2-layer
        BLEND-CUSTOM LAYER-MODE-NORMAL-LEGACY GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE 0 3 0.2 TRUE
        (/ width 2) 0 (/ width 2) height)
    (gimp-layer-set-preserve-trans text2-layer FALSE)
    ; and hide the bg and this new one
    (gimp-drawable-set-visible bg-layer FALSE)
    (gimp-drawable-set-visible text-layer TRUE)
    (gimp-drawable-set-visible text2-layer FALSE)

    ; Add white layer
    (let ((tmp-layer (car (gimp-layer-new img width height RGB-IMAGE "Temp" 100 LAYER-MODE-NORMAL-LEGACY))))
        (gimp-image-add-layer img tmp-layer 3)
        (gimp-image-set-active-layer img tmp-layer)
        (gimp-selection-all img)
        (gimp-context-set-foreground '(255 255 255))
        (gimp-edit-bucket-fill tmp-layer FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY 100 255 FALSE 1 1)
        (gimp-context-set-foreground old-fg)
        (gimp-selection-none img))

    ; Merge, blur, bump
    (let ((bump-layer (car (gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY))))
      (gimp-drawable-set-visible bg-layer TRUE)
      (plug-in-gauss-iir 1 img bump-layer txtbord TRUE TRUE)
      (gimp-drawable-set-visible bump-layer FALSE)
      (gimp-drawable-set-visible text2-layer TRUE)

      ; Twiddle the brightness a little
      (if (eq? darkentog TRUE)
      (gimp-brightness-contrast text2-layer -20 -20))

      ; Bumpmapping depends on do we need the flames or not...
      (plug-in-bump-map 1 img text2-layer bump-layer
              (if (eq? fierytog FALSE) 135.00 90.00)
              (if (eq? fierytog FALSE) 45.00 30.0)
              6 0 0 0 0 FALSE FALSE GRADIENT-LINEAR)

      (gimp-image-remove-layer img bump-layer))
;OK UNTIL HERE
    ; And that was the easy part. ::sigh::

    (if (eq? fierytog TRUE)
    (let* ((sheight (* height perc))
           (ycoord (- height sheight))
           ; Add a layer
           (fire1-layer (car (gimp-layer-new img
                                             width height
                                             RGBA-IMAGE "Fire 1"
                                             100 LAYER-MODE-NORMAL-LEGACY))))

      (gimp-image-add-layer img fire1-layer 0)
                    ; Clear it
      (gimp-selection-all img)
      (gimp-edit-clear fire1-layer)
                    ; Make lower part red
      (gimp-rect-select img 0 ycoord width sheight CHANNEL-OP-REPLACE FALSE 0)
      (gimp-context-set-foreground '(180 0 20))
      (gimp-edit-bucket-fill fire1-layer FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY
                100 255 FALSE 1 1)
      (gimp-selection-none img)

      ; Do nasty stuff to the lower fire layer
      (plug-in-ripple 1 img fire1-layer
              (/ width 8) (/ height 8) 1 0 1 FALSE FALSE)
      (plug-in-whirl-pinch 1 img fire1-layer
                   45 0 0.7)

      ; Copy the layer, make it yellow, shift down a bit
      (let ((fire2-layer (car (gimp-layer-copy fire1-layer TRUE))))
        (gimp-image-add-layer img fire2-layer 0) ; top
        (gimp-drawable-set-name fire2-layer "Fire 2")

        (gimp-image-set-active-layer img fire2-layer)
        (gimp-layer-set-preserve-trans fire2-layer TRUE)
        (gimp-context-set-foreground '(228 170 4)) ; Yellow
        (gimp-selection-all img)
        (gimp-edit-bucket-fill fire2-layer FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY
                  100 255 FALSE 1 1)
        (gimp-layer-set-preserve-trans fire2-layer FALSE)
        (gimp-selection-none img)

        (gimp-drawable-offset fire2-layer FALSE 1 0 (/ height 8))

        ; The third fire layer
        (let ((fire3-layer (car (gimp-layer-copy fire1-layer TRUE))))
          (gimp-image-add-layer img fire3-layer 0) ; top
          (gimp-drawable-set-name fire3-layer "Fire 3")
          (gimp-drawable-offset fire3-layer FALSE 1 0
                       (* 2.6 (/ height 8)))

          ; resize the said layer...
          (gimp-image-set-active-layer img fire3-layer)
          (gimp-selection-all img)
          (gimp-drawable-transform-scale-default fire3-layer 0
                  (* height 0.6) width height TRUE FALSE)

          ; spread, spindle, mutilate
          (plug-in-spread 1 img fire1-layer 0 (* 3 sprd))
          (plug-in-spread 1 img fire2-layer 0 (* 2 sprd))
          (plug-in-spread 1 img fire3-layer 0 (* 1.5 sprd))))

      ; Merge the layers
      (gimp-drawable-set-visible text2-layer FALSE)
      (gimp-drawable-set-visible bg-layer FALSE)

      (define fire-layer
        (car (gimp-image-merge-visible-layers
              img EXPAND-AS-NECESSARY)))
      (gimp-drawable-set-name fire-layer "Fire")

      (gimp-layer-set-preserve-trans fire-layer TRUE)
      (plug-in-gauss-rle 1 img fire-layer (* 2 sprd) TRUE TRUE)
      (gimp-layer-set-preserve-trans fire-layer FALSE)

      (gimp-drawable-set-visible text2-layer TRUE)
      (gimp-drawable-set-visible bg-layer TRUE)

      (plug-in-noisify 1 img fire-layer TRUE 0.2 0.2 0.2 0.2)
      (plug-in-noisify 1 img fire-layer TRUE 0.2 0.2 0.2 0.2)

      (plug-in-gauss-rle 1 img fire-layer (* 2 sprd) TRUE TRUE)

      ; Then, Let's nastyize it.
      (gimp-layer-set-preserve-trans fire-layer TRUE)
      (plug-in-randomize-pick 1 img fire-layer rndamt 80 10 6942)
      (gimp-layer-set-preserve-trans fire-layer FALSE)

      ; Here we use another kewl displacement thing... it really rules.
      ; Displacement was one of the coolest things I knew about back
      ; in 0.59 era.

      (if (eq? turbultog TRUE)
          (let ((turbul-layer (car (gimp-layer-new img
                                                   width height
                                                   RGBA-IMAGE "Turbul"
                                                   100 LAYER-MODE-NORMAL-LEGACY))))

        (gimp-image-add-layer img turbul-layer 0)


        ; We used Solid Noise here, but it didn't look very cool.
        ; This actually works.
        (plug-in-plasma 1 img turbul-layer 42 turbulence)
        (gimp-desaturate turbul-layer)
        (plug-in-c-astretch 1 img turbul-layer)


        ; Add more turbulence. Heavy magery follows. You are not
        ; expected to understand this. It was a result of all-night
        ; weaving of Spells of Technomancy. (In other words,
        ; dark magic follows, beware!)

        ; New layer
        (let ((turbul2-layer
              (car (gimp-layer-new img width height
                       RGBA-IMAGE "Turbul2"
                       100 LAYER-MODE-NORMAL-LEGACY))))
          (gimp-image-add-layer img turbul2-layer 0)
          (gimp-image-set-active-layer img turbul2-layer)
          ; Uh, great. Now more fun.

          ; First half
          (gimp-selection-none img)
          (gimp-rect-select img 0 (/ height 2) width (/ height 2)
                    0 FALSE 10)
          (gimp-context-set-foreground '(0 0 0)) ; Black
          (gimp-edit-bucket-fill turbul2-layer
                    FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY 100 255 FALSE 1 1)

          ; Second half
          (gimp-context-set-foreground '(255 255 255)) ; White
          (gimp-selection-invert img)
          (gimp-edit-bucket-fill turbul2-layer
                    FG-BUCKET-FILL LAYER-MODE-NORMAL-LEGACY 100 255 FALSE
                    (+ (/ height 2) 1) 1)
          (gimp-selection-none img)

          (plug-in-ripple 1 img turbul2-layer
                  (/ width 8) (/ height 4) 1 0 1 FALSE FALSE)

          (plug-in-spread 1 img turbul2-layer (/ width 12) (/ height 12))

          (plug-in-gauss-rle 1 img turbul2-layer (/ width 5) TRUE TRUE)

          ; Bleah
          (plug-in-oilify 1 img turbul2-layer 6 0)

          ; First displacement
          (plug-in-displace 1 img turbul-layer
                    (* 1.5 turbulence) (* 3 turbulence)
                    TRUE TRUE
                    turbul2-layer turbul2-layer 1) ; SMEAR
          (gimp-image-remove-layer img turbul2-layer))


        ; Second displacement
        (plug-in-displace 1 img fire-layer
                  (* 1.5 turbulence) (* 3 turbulence)
                  TRUE TRUE
                  turbul-layer turbul-layer 1) ; SMEAR
        (gimp-image-remove-layer img turbul-layer)

        ))
;OK UP TO HERE
      (plug-in-oilify 1 img fire-layer 3 0)

      ; Finally, make the flames burrrrrn...
      (gimp-layer-set-mode fire-layer LAYER-MODE-ADDITION-LEGACY)

      (if (eq? fulltog FALSE)
          (begin
        (gimp-drawable-set-visible bg-layer FALSE)
        (set! text2-layer
              (car (gimp-image-merge-visible-layers
                img EXPAND-AS-NECESSARY)))
        (gimp-drawable-set-visible bg-layer TRUE)))
      )) ; End of fiery stuff

    ; Okay, let's mail our flame. This is a complete redefinition of the
    ; word "flame". Heh...?

    (define sendtog FALSE) ; Disabled!

    (if (eq? sendtog TRUE)
    (begin
      (set! bg-layer (gimp-image-flatten img))
      (gimp-convert-indexed-palette img TRUE 2 0 "")
      ; Note: This step is interactive, *just in case*...
      ; This doesn't work. Drats...
      (plug-in-mail-image 0 img bg-layer
                  "bah.png" "no@where.so.there"
                  "Have you fscked your system today?"
                  "This is a comment, but you cannot see it" 1)
      ))


    ; End of Action(tm) =============================================
    (gimp-context-set-background old-bg)
    (gimp-context-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-context-pop)
    (gimp-display-new img)))

;
; Hajaa-ho!
;
(script-fu-register
 "script-fu-fiery-steel"
 "Fiery Steel..."
 (string-append
 "An effect inspired by the \"Terminator 2: Judgement Day\" "
 "opening titles. Metallic letters in hellfire. $Revision: 1.5.1.0 $")
 "Weyfour WWWWolf (Urpo Lankinen) <wwwwolf@iki.fi>"
 "Weyfour WWWWolf"
 "1998/05/09"
 ""
 SF-STRING     "Text String"           "RGRNCA"
 SF-FONT       "Font" "-freefont-crillee-normal-r-normal-*-140-*-*-*-p-*-*-*"
 SF-ADJUSTMENT "Font Size"             '(140 2 1000 1 10 0 1)
 SF-GRADIENT   "Gradient"              "Brushed Aluminium"
 SF-ADJUSTMENT "Engulfment percentage" '(.5 0 1 0.01 0.1 2 0)
 SF-ADJUSTMENT "Text border"           '(3.5 0 1000 1 10 0 1)

 SF-TOGGLE     "Darken?"               TRUE
 ; SF-TOGGLE "Slab?"                     FALSE
 SF-TOGGLE     "Fire effects?"         TRUE

 SF-ADJUSTMENT "Spread coefficient"    '(5 0 1000 1 10 0 1)
 SF-ADJUSTMENT "# of fire randomizes"  '(40 0 1000 1 10 0 1)

 SF-TOGGLE     "Fire over background"   FALSE

 SF-TOGGLE     "Add flame turbulence"   TRUE
 SF-ADJUSTMENT "Turbulence"             '(3 0 1000 1 10 0 1)
; SF-VALUE  "Turbulence detail"      "1"

; Does not work, drats...
; SF-TOGGLE "Send flame as E-mail"   FALSE
)

(script-fu-menu-register "script-fu-fiery-steel" "<Image>/Filters/Decor")



;(define (script-fu-fiery-steel
;     text font size grad perc txtbord darkentog
     ; slabtog
;     fierytog sprd rndamt fulltog
;     turbultog turbulence


; You can use GUMP (Mail plugin) to mail this image...
; ...a complete redefinition of "flame"!


; BTW, if you're wondering what "RGRNCA" means, surf to:
; <URL:http://www.iki.fi/wwwwolf/games/nethack/index.html>
