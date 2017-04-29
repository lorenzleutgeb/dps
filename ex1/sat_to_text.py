#!/usr/bin/env python3

# Author: Lorenz Leutgeb <e1127842@student.tuwien.ac.at>

from os.path import basename
from re import search
from sys import argv, exit

def decode(x, factors):
	result = []
	for factor in factors:
		(x, a) = divmod(x, factor)
		result.append(a)

	return tuple(result)

# I am too lazy to solve n * (n - 1) ** 2 for n ...
#n = {}
#for i in range(2, 21):
#	if i % 2 == 0:
#		n[i * (i - 1) ** 2] = i
#print(n)

n = {
	2:     2,
	36:    4,
	150:   6,
	392:   8,
	810:  10,
	1452: 12,
	2366: 14,
	3600: 16,
	5202: 18,
	7220: 20
}

fname = argv[1]

assignment = []

with open(fname, 'r') as f:
	for line in f:
		tokens = line.strip().split(' ')
		if len(tokens) >= 2 and tokens[0] == 's' and tokens[1] == "UNSATISFIABLE":
			exit(1)

		if len(tokens) < 1:
			continue

		if tokens[0] == 'c':
			continue

		if tokens[0] == 'v':
			assignment = assignment + [int(literal) for literal in tokens[1:] if int(literal) != 0]	

fname = basename(fname)
match = search('roundrobin_2nd_leg_(?P<n>\d+).sat', fname)

N = 0
weeks = None

if match: # 2nd leg
	N = int(match.group('n'))
	weeks = range(0, (2 * N) - 2)
else:
	match = search('roundrobin_(?P<n>\d+).sat', fname)

	if match: # regular
		N = int(match.group('n'))
		assert len(assignment) == N * (N - 1) ** 2
	else: # guess
		N = n[len(assignment)]
		variables = len(assignment)

	weeks = range(0, N - 1)

teams = range(0, N)
fields = range(0, int(N / 2))
positions = range(0, 2)
factors = (len(positions), len(fields), len(weeks), len(teams))

def play(atom):
	result = list(decode(atom - 1, factors))
	result[3] += result[0]
	return tuple(result)

games = [[['#', '#'] for week in weeks] for field in fields]

for (position, field, week, team) in [play(literal) for literal in assignment if literal > 0]:
	assert team >= 0
	games[field][week][position] = team + 1

print('\n'.join(['\t'.join([':'.join([str(team) for team in game]) for game in field]) for field in games]))
