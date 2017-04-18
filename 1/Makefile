#
# 184.701 UE Declarative Problem Solving
#
# Exercise 1
#
# Please setup MNR, LANGUAGE, and optionally PERL and PYTHON
#

MNR=1127842

LANGUAGE=python

#interpreter for perl (please ensure that you use version 5.24.1)
PERL = perl

#interpreter for python (please ensure that you use version 3.6.0)
#TODO: Change this back to "python"
PYTHON = python3

#picosat solver (please ensure that you use version 965)
PICOSAT = picosat

.PHONY : all clean run_task1 run_task2 run_task3 run_task4 zip

.SUFFIXES:
.SUFFIXES: .pl .py


# source code and run specification

SOURCES = roundrobin_to_sat sat_to_text roundrobin_to_sat_2nd_leg

%.sat: %.cnf
	( $(PICOSAT) $^ ; case "$$?" in 10|20) exit 0;; *) exit 1;; esac ) > $@
#$(PICOSAT) $< -o $@


ifeq ($(LANGUAGE),perl)

all: $(addsuffix .pl,$(SOURCES))

roundrobin_$(NO_TEAMS).cnf: roundrobin_to_sat.pl
	$(PERL) $< $(NO_TEAMS) > $@

roundrobin_2nd_leg_$(NO_TEAMS).cnf: roundrobin_to_sat_2nd_leg.pl
	$(PERL) $< $(NO_TEAMS) > $@

%.sol: sat_to_text.pl %.sat
	$(PERL) $< $(lastword $^) > $@

else

all: $(addsuffix .py,$(SOURCES))

roundrobin_$(NO_TEAMS).cnf: roundrobin_to_sat.py
	$(PYTHON) $< $(NO_TEAMS) > $@

roundrobin_2nd_leg_$(NO_TEAMS).cnf: roundrobin_to_sat_2nd_leg.py
	$(PYTHON) $< $(NO_TEAMS) > $@

%.sol: sat_to_text.py %.sat
	$(PYTHON) $< $(lastword $^) > $@

endif


# standard targets

clean:
	rm -f *.cnf *.sol *.sat

zip: $(MNR)_ex1.zip

$(MNR)_ex1.zip: Makefile $(addsuffix $(if $(findstring perl, $(LANGUAGE)),.pl,.py),$(SOURCES)) documentation.pdf
	mkdir $(MNR)
	cd $(MNR) && for f in $^; do ln -sv ../$$f; done
	zip -r $(MNR).zip $(MNR)
	rm -r $(MNR)

run_task1: roundrobin_$(NO_TEAMS).cnf

run_task2: roundrobin_$(NO_TEAMS).sol

run_task3: roundrobin_2nd_leg_$(NO_TEAMS).cnf

run_task4: roundrobin_2nd_leg_$(NO_TEAMS).sol

### Local Variables:
### mode: makefile
### End:
