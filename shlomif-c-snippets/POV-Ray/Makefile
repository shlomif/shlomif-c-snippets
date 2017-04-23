include include.mak

TGA_TARGETS = $(patsubst %.pov,%.png,$(POV_SOURCES))

POVRAY = povray

POVRAY_LIB_PATH = /usr/lib/povray-3.5

POVRAY_OPTIONS = -L$(POVRAY_LIB_PATH)/include -W640 -H480

all: demo

demo: $(TGA_TARGETS)
	gimv flip-thru-4th-dim-rev.png

$(TGA_TARGETS):: %.png : %.pov
	$(POVRAY) $(POVRAY_OPTIONS) $<

flip-thru-4th-dim.pov: flip-thru-4th-dim.pov.ttml flip-thru-base.ttml
	ttml -o $@ $<

flip-thru-4th-dim-rev.pov: flip-thru-4th-dim-rev.pov.ttml flip-thru-base.ttml
	ttml -o $@ $<

