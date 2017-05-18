% g1
% for each course requiring L > 0 lessons in the curriculum of the grade of a class,
% exactly one teacher is assigned to teach that course in that class;
{ assigned(T,C,S) : teacher(T) } = 1 :- curriculum(G,S,L), L > 0, class(C,G).

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
