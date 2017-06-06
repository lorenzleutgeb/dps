numTeachers(C,S,X) :- class(C,_), course(S), X = #count{ T : assigned(T,C,S,L), L > 0 }.

% g1'
% for every course in a class that, according to the curriculum of its grade,
% requires L > 0 lessons a week in that course, at least one teacher is assigned
% to teach L_2 (0 < L_2 <= L) lessons;
{ assigned(T,C,S,1..L) : teacher(T) } > 0 :- curriculum(G,S,L), L > 0, class(C,G).

% g2
% each class has exactly one form teacher, who is also teaching that class in some
% course;
{ formteacherOf(T,C) : teacher(T) } = 1 :- class(C,_).

-doesNotTeach(T,C) :- assigned(T,C,S), class(C,_), course(S).
doesNotTeach(T,C) :- not -doesNotTeach(T,C), formteacherOf(T,C).

:- doesNotTeach(T,C).

% g3
% for each extra-curricular activity requiring L > 0 hours of preparation per week,
% exactly one teacher is assigned.
{ responsibleFor(T,A) : teacher(T) } = 1 :- activity(A,L), L > 0.

% g4 In each class requiring L <= 3 lessons a week in a course, no more than one
% teacher is assigned to that course.
:- class(C,G), curriculum(G,S,L), L <= 3, numTeachers(C,S,X), X > 1.

% g5
% Whenever multiple teachers are assigned to a single course of a class, each of
% those teachers must be assigned for L >= 2 lessons a week to that course in
% the class
:- class(C,G), curriculum(G,S,L), numTeachers(C,S,X), X > 1, assigned(T,C,S,L), L = 1.

% g6
% To each course required in a class, a teacher can only be assigned once (i.e.,
% there should not be multiple assignments of the same teacher to the same class
% in the same course featuring different numbers of lessons)
:- assigned(T,C,S,L1), assigned(T,C,S,L2), L1 != L2.

% g7
% For each class and each course, the sum of lessons of the course taught by
% different teachers in that class must be equal to the required number of
% lessons, which is given by the curriculum for the grade of the class.
:- curriculum(G,S,X1), class(C,G), #sum{ L,T : assigned(T,C,S,L) } = X2, X1 != X2.
