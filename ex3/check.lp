prepTime(C,S,L) :- class(C,G), curriculum(G,S,L), G < 3.
prepTime(C,S,X) :- class(C,G), curriculum(G,S,L), G > 2, X = 2 * L.

teachingPrepTime(T,X) :- teacher(T), #sum{ L,C,S : assigned(T,C,S), prepTime(C,S,L) } = X.
activityPrepTime(T,X) :- teacher(T), #sum{ L,A : responsibleFor(T,A), activity(A,L) } = X.

totalPrepTime(T,Z) :- teachingPrepTime(T,X), activityPrepTime(T,Y), Z = X + Y.

% i1
% Only courses from the given set (course/1) are used to classify assignments,
% curricula, and teachers' qualifications to teach courses.
:- assigned(T,C,S), not course(S).
:- curriculum(G,S,L), not course(S).
:- qualified(T,S), not course(S).

% i2
% Classes can only be in grade 1 to 4 and not in more than one grade.
:- class(C,G), G < 1.
:- class(C,G), G > 4.
:- class(C,G1), class(C,G2), G1 != G2.

% i3
% If for some grade and some course no curriculum is given,
% 0 lessons are assumed to be required.
curriculum(G,S,0) :- class(C,G), course(S), #count{ L : curriculum(G,S,L), L > 0 } = 0.

% a1
% If a class does not require any lessons in some course, no teacher should be
% assigned to teach the course in that class.
:- assigned(T,C,S), teacher(T), class(C,G), L = 0, curriculum(G,S,L).

% a2
% Only teachers who are qualified for a course may teach it.
:- not qualified(T,S), assigned(T,C,S).

% a3
% Each class should be taught each course by at most one teacher.
:- class(C,G), curriculum(G,S,_), #count{ T : assigned(T,C,S) } > 1.

% a4
% No teacher has to be without any teaching assignment.
:- teacher(T), not assigned(T,_,_).

% a5
% No teacher should teach more than 4 different classes.
:- teacher(T), #count{ C : assigned(T,C,_) } > 4.

% a6
% A teacher may not teach a class he or she has a relative in, except when there
% is a relative in every class, to which he or she could teach at least one
% course. In that case, he or she may teach a single class with a relative in it
%(and any number of courses in that class).
:- teacher(T), teachesRelativeIn(T,C), not allowedToTeachRelative(T).
:- teachesRelativeIn(T,C1), teachesRelativeIn(T,C2), C1<>C2.

teachesRelativeIn(T,C) :- hasRelativeIn(T,C), assigned(T,C,S).

canTeach(T,C) :- class(C,G), curriculum(G,S,L), qualified(T,S), L > 0.

-allowedToTeachRelative(T) :- canTeach(T,C), not hasRelativeIn(T,C).
allowedToTeachRelative(T) :- not -allowedToTeachRelative(T), teacher(T).

%:- teacher(T), teachesRelativeIn(#count{ C : assigned(T,C,_), hasRelativeIn(T,C) } > 1, allowedToTeachRelatives(T).
%:- teacher(T), #count{ C : assigned(T,C,_), hasRelativeIn(T,C) } > 0, not allowedToTeachRelatives(T).
%canTeach(T,C) :- class(C,G), curriculum(G,S,_), qualified(T,S).
%allowedToTeachRelatives(T) :- teacher(T), #count{ C : canTeach(T,C), not hasRelativeIn(T,C) } = 0.

% a7
% No teacher should be required to spend more than 24 hours preparing lessons
% and extra-curricular activities in total every week, where each lesson for
% grades 1 and 2 accounts for 1 hour of preparation time and each lesson for
% grades 3 and 4 accounts for 2 hours of preparation time.
:- teacher(T), totalPrepTime(T,L), L > 24.

% f1
% A class must not have more than one form teacher.
:- formteacherOf(T1,C), formteacherOf(T2,C), T1 != T2.

% f2
% A class must be taught by its form teacher.
:- formteacherOf(T,C), not assigned(T,C,_).

% f3
% A teacher must not be form teacher at more than one class.
:- formteacherOf(T,C1), formteacherOf(T,C2), C1 != C2.

% e1
% An extra-curricular activity (activity/2) is led by exactly one teacher.
:- activity(A,L), #count{ T : responsibleFor(T,A) } != 1.

% e2
% No teacher should spend more time preparing extra-curricular activities than
% regular lessons.
:- teachingPrepTime(T,L1), activityPrepTime(T,L2), L1 < L2.
