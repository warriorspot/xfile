# Note: the next three lines are modified by the makefile-generator in xcow.x.
APP       = tearoff
LIBS      = xb.lib
START     =

!include <xbasic.mak>

all: $(APP).exe

$(APP).exe: $(APP).o
	$(LD) $(LDFLAGS) -out:$(APP).exe appstart.o $(APP).o $(RESOURCES) $(LIBS) $(STDLIBS)

$(APP).o: $(APP).s

$(APP).s: $(APP).x
	$(START) xb $(APP).x
