#
# Makefile for CompOrg Experiment 1 - sum
#

#
# Location of the processing programs
#
RASM  = /home/fac/wrc/bin/rasm
RLINK = /home/fac/wrc/bin/rlink
RSIM  = /home/fac/wrc/bin/rsim

#
# Suffixes to be used or created
#
.SUFFIXES:	.asm .obj .lst .out

#
# Transformation rule: .asm into .obj
#
.asm.obj:
	$(RASM) -l $*.asm > $*.lst

#
# Transformation rule: .obj into .out
#
.obj.out:
	$(RLINK) -m -o $*.out $*.obj >$*.map

#
# Main target
#
sum.out:	sum.obj


run:	sum.obj
	- $(RSIM) sum.out

debug:	sum.obj
	- $(RSIM) -d sum.out
	
clean:
	rm *.obj *.lst *.out
