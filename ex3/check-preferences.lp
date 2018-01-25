% 1 “I do not like to teach that course” / “We do not like to be taught by that teacher.”
% 2 “I am / We are indifferent about this course / teacher.”
% 3 “I would like to teach that course” / “We would like to be taught by that teacher.”

% Actual preferences will be given as facts of the predicate preference(A,B,V),
% where A and B are either a teacher and a course or a class and a teacher, and V is an
% element of 1, 2, 3. For instance, a teacher t might be in favor of teaching a course s,
% which would be expressed as preference(t,s,3). The same predicate is used
% for classes’ dispositions towards teachers, e.g., a class c might dislike a teacher t, in
% which case the respective fact would be preference(c,t,1).

% p1
% No teacher gives more than one preference for a course. The value of that
% preference must be 1, 2 or 3.
:- preference(T,S,V1), preference(T,S,V2), V1 != V2, teacher(T), course(S).
:- preference(T,S,V), V < 1, teacher(T), course(S).
:- preference(T,S,V), V > 3, teacher(T), course(S).

% p2
% No class gives more than one preference for a teacher. The value of that
% preference must be 1, 2 or 3.
:- preference(C,T,V1), preference(C,T,V2), V1 != V2, teacher(T), class(C,_).
:- preference(C,T,V), V < 1, teacher(T), class(C,_).
:- preference(C,T,V), V > 3, teacher(T), class(C,_).

% p3
% When a teacher or class A does not give her disposition towards a course or
% teacher B, respectively, assume it to be neutral (i.e., preference(A,B,2)
% must be present in all answer sets).
preference(T,S,2) :- teacher(T), course(S), not preference(T,S,1), not preference(T,S,3).
preference(C,T,2) :- teacher(T), class(C,_), not preference(C,T,1), not preference(C,T,3).

% p4
% No teacher should give negative preferences for more than half of all courses.
% That is, in case there are n different courses, each teacher may give negative
% preferences for at most floor(n / 2) different courses.
:- teacher(T), N = #count{ S : course(S), preference(T,S,1) }, M = #count{ S : course(S)}, X = M / 2, N > X.

% p5
% No class gives more negative preferences as it gives positive preferences to a
% teacher.
:- class(C,_), P = #count{ T : preference(C,T,3) }, N = #count{ T : preference(C,T,1) }, N > P.

% p6
% In order to determine the degree of compatibility of each teacher T paired
% with each class C, we deduce facts of predicate rating(T,C,V) for each such
% pair. V is the result of
%  * the sum of the products of lessons L for each course S that teacher T has
%    been assigned to in class C multiplied by teacher T’s disposition towards
%    that course (informally speaking: the lessons a week a teacher has been
%    assigned in all courses in a class, weighted by the teacher’s preference
%    for each such course)
%  * multiplied by class C’s disposition towards teacher T.
rating(T,C,Z) :- teacher(T), X = #sum{ V*L : preference(T,S,V), assigned(T,C,S,L) }, preference(C,T,Y), Z = X * Y.
