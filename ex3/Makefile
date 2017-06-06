#
# 184.701 UE Declarative Problem Solving
#
# Exercise 3, Summer term 2017
#
# Please setup MNR.
#

MNR=1127842

.PHONY : all zip

.SUFFIXES:
.SUFFIXES: .dl .lp .facts


# source code and zip file

FACTS := \
	teachers1.facts teachers2.facts teachers3.facts teachers4.facts teachers5.facts teachers6.facts teachers7.facts teachers8.facts \
	classes1.facts classes2.facts classes3.facts classes4.facts classes5.facts classes6.facts classes7.facts classes8.facts \
	courses1.facts courses2.facts courses3.facts courses4.facts courses5.facts courses6.facts courses7.facts courses8.facts \
	activities1.facts activities2.facts activities3.facts activities4.facts activities5.facts activities6.facts activities7.facts activities8.facts

ASGN := asgn1.facts asgn2.facts asgn3.facts asgn4.facts asgn5.facts asgn6.facts asgn7.facts asgn8.facts

GUESS_POTASSCO := guess.lp

CHECK_POTASSCO := check.lp check-preferences.lp

OPT_POTASSCO := optimize.lp

SOURCES := $(OPT_POTASSCO) $(CHECK_POTASSCO) $(GUESS_POTASSCO) $(FACTS) $(ASGN)

ZIP = $(MNR)_ex3.zip

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
