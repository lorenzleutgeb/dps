#!/usr/bin/env python3

# Author: Lorenz Leutgeb <e1127842@student.tuwien.ac.at>

from sys import argv, exit

from itertools import product

def encode(xs, factors):
	result = 0
	for (x, factor) in zip(reversed(xs), reversed(factors)):
		assert x >= 0
		result = result * factor + x

	return result

# Check for input and parse it
if not len(argv) is 2:
	print("Exactly one argument (number of teams) expected.")
	exit(1)

N = -1

try:
	N = int(argv[1])
except ValueError:
	print("Unable to read argument as integer.")
	exit(2)

if N is 0:
	print("Number of teams must be greater than zero.")
	exit(3)

if N % 2 is not 0:	
	print("Number of teams must be even.")
	exit(4)

# Allocate domain
teams = range(0, N)
weeks = range(0, (2 * (N - 2)) - 1)
fields = range(0, int(N / 2))
positions = range(0, 2)
factors = (len(positions), len(fields), len(weeks), len(teams))

# Compute the number of propositional variables that
# will be needed for encoding
variables = 0

# Initialize empty list of clauses
clauses = []

def clause(*literals):
	global clauses
	clauses.append(literals)

# The play function encodes the proposition that that a given
# team plays on a given field in a given week at a given
# position into a propositional variable.
def play(position, team, field, week):
	global variables

	result = encode((position, field, week, team - position), factors) + 1

	# TODO: Compute variables beforehand.
	if result > variables:
		variables = result

	return result

# 2
# In each slot, one team plays against another team. These
# clauses together with the clauses in (4) ensure that one
# team plays exactly against another team every week.
for (week, field) in product(weeks, fields):
	clauses.append(
		[play(0, team, field, week) for team in teams[:-1]]
	)

	clauses.append(
		[play(1, team, field, week) for team in teams[1:]]
	)

# 3
# In each slot (p(1, t, f, w), p(2, t', f, w)) it holds that t < t'.
for (week, field, t1, t2) in product(weeks, fields, teams[:-1], teams[1:]):
	if t1 < t2:
		continue

	clause(
		-play(0, t1, field, week),
		-play(1, t2, field, week)
	)

# 4
# Every team plays one game in each week of the season.
for (week, team, f1, f2, r1, r2) in product(weeks, teams, fields, fields, positions, positions):
	if r1 is r2 and f1 is f2:
		continue

	rs = [r1, r2]
	if (0 in rs and team is N-1) or (1 in rs and team is 0):
		continue

	clause(
		-play(r1, team, f1, week),
		-play(r2, team, f2, week)
	)

# Every two teams play each other exactly twice.
#for (w1, w2, w3, f1, f2, f3, t1) in product(weeks, weeks, weeks, fields, fields, fields, teams):
#	if w1 == w2 or w2 == w3:
#		continue
#
#	for t2 in teams[t1+1:]:
#		clause(
#			-play(0, t1, f1, w1),
#			-play(1, t2, f1, w1),
#			-play(0, t1, f2, w2),
#			-play(1, t2, f2, w2),
#			-play(0, t1, f3, w3),
#			-play(1, t2, f3, w3)
#		)

# No team plays more than four times in the same
# field over the course of the season.
for (team, field, w1, r1, r2, r3, r4, r5) in product(teams, fields, weeks, positions, positions, positions, positions, positions):
	rs = [r1, r2, r3, r4, r5]
	if (0 in rs and team is N-1) or (1 in rs and team is 0):
		continue

	for w2 in weeks[w1+1:]:
		for w3 in weeks[w2+1:]:
			for w4 in weeks[w3+1:]:
				for w5 in weeks[w4+1:]:				
					clause(
						-play(r1, team, field, w1),
						-play(r2, team, field, w2),
						-play(r3, team, field, w3),
						-play(r4, team, field, w4),
						-play(r5, team, field, w5)
					)

# for each field i, and each week j, the two
# teams playing each other in this slot, must not play each other in field i and week
# j + n - 1 again (i.e., at most one of them may play in that slot).
for (t1, field, week) in product(teams, fields, weeks[:N]):
	for t2 in teams[t1+1:]:
		clause(
			+play(0, t1, field, week),
			+play(1, t2, field, week),
			-play(0, t1, field, week + (N - 1)),
			-play(1, t2, field, week + (N - 1))
		)

print("p cnf " + str(variables) + " " + str(len(clauses)))
print("\n".join([' '.join(map(str, literals)) + ' 0' for literals in clauses]))
