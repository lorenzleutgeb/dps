#!/usr/bin/env python3

"""
Problem statement.

Given n (even),

1. There are n teams and every two teams play each other exactly once.
2. The season lasts n - 1 weeks.
3. Every team plays one game in each week of the season.
4. There are n / 2 fields and, each week, every field is scheduled for one game.
5. No team plays more than twice in the same field over the course of the season.

Notions:

 1. A slot is a particular field in a particular week.
 2. The meeting between two teams is called a game and takes place in a slot.
 3. Teams are named 1, . . . , n.
 4. An n-team round robin timetable contains n(n − 1)/2 slots and slots are
    filled in with games.
 5. A game is represented by a pair of teams (t_1, t_2) s.t. t_1 < n and t_1 < t_2.

"""

def p1(k, i, j):
    if i < 1 or i > n / 2 or j > 1 or k > n - 1:
        return None

    return 1000 + k * 100 + i * 10 + j

def p2(k, i, j):
    if i < 1 or i > n / 2 or j < 1 or j > n - 1 or k < 2 or k > n:
        return None

    return 2000 + k * 100 + i * 10 + j


def generate(n=3):

def main():

if __name__ == "__main__":
    print("two.py is being run directly")
