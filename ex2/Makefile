#
# 184.701 UE Declarative Problem Solving
#
# Exercise 2, 2017-04-19
#
# Please setup MNR.
#

#TODO: insert your student-id here:
MNR=XXXXXXX


.PHONY : all zip

.SUFFIXES:
.SUFFIXES: .dl .lp .facts


# source code and zip file

CHECK_DLV := check.dl

FACTS := \
	teachers1.facts teachers2.facts teachers3.facts teachers4.facts teachers5.facts \
	classes1.facts classes2.facts classes3.facts classes4.facts classes5.facts \
	courses1.facts courses2.facts courses3.facts courses4.facts courses5.facts

ASGN := asgn1.facts asgn2.facts asgn3.facts asgn4.facts asgn5.facts

GUESS_DLV := guess.dl

SOURCES := $(CHECK_DLV) $(GUESS_DLV) $(FACTS) $(ASGN)

ZIP = $(MNR)_ex2.zip

# standard targets

all: $(SOURCES)

zip: $(ZIP)

$(ZIP): Makefile $(SOURCES)
	mkdir $(MNR) ; cd $(MNR) && for f in $^; do ln -sv ../$$f; done
	zip -r $@ $(MNR)
	rm -r $(MNR)

### Local Variables:
### mode: makefile
### End:
