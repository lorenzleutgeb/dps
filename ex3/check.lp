prepTime(C,S,L) :- class(C,G), curriculum(G,S,L), G < 3.
prepTime(C,S,X) :- class(C,G), curriculum(G,S,L), G > 2, X = 2 * L.

teachingPrepTime(T,X) :- teacher(T), #sum{ L,C,S : assigned(T,C,S,_), prepTime(C,S,L) } = X.
activityPrepTime(T,X) :- teacher(T), #sum{ L,A : responsibleFor(T,A), activity(A,L) } = X.

totalPrepTime(T,Z) :- teachingPrepTime(T,X), activityPrepTime(T,Y), Z = X + Y.

teachingTime(T,X) :- teacher(T), #sum{ L,C,S : assigned(T,C,S,L) } = X.

% i1
% Only courses from the given set (course/1) are used to classify assignments,
% curricula, and teachers' qualifications to teach courses.
:- assigned(T,C,S,_), not course(S).
:- curriculum(G,S,L), not course(S).
:- qualified(T,S), not course(S).

% i2
% Classes can only be in grade 1 to 4 and not in more than one grade.
:- class(C,G), G < 1.
:- class(C,G), G > 4.
:- class(C,G1), class(C,G2), G1 != G2.

% i3
% If for some grade and some course no curriculum is given, 0 lessons are
% assumed to be required.
curriculum(G,S,0) :- class(C,G), course(S), #count{ L : curriculum(G,S,L), L > 0 } = 0.

% a1
% If a class does not require any lessons in some course, no teacher should be
% assigned to teach the course in that class.
:- assigned(T,C,S,L), L != 0, teacher(T), class(C,G), curriculum(G,S,0).

% a2
% Only teachers who are qualified for a course may teach it.
:- not qualified(T,S), assigned(T,C,S,_).

% a4
% No teacher has to be without any teaching assignment.
:- teacher(T), not assigned(T,_,_,_).

% a5
% No teacher should teach more than 4 different classes.
:- teacher(T), #count{ C : assigned(T,C,_,_) } > 4.

% a6
% A teacher may not teach a class he or she has a relative in, except when there
% is a relative in every class, to which he or she could teach at least one
% course. In that case, he or she may teach a single class with a relative in it
% (and any number of courses in that class).
:- teacher(T), teachesRelativeIn(T,C), not allowedToTeachRelative(T).
:- teachesRelativeIn(T,C1), teachesRelativeIn(T,C2), C1<>C2.

teachesRelativeIn(T,C) :- hasRelativeIn(T,C), assigned(T,C,S,_).

canTeach(T,C) :- class(C,G), curriculum(G,S,L), qualified(T,S), L > 0.

-allowedToTeachRelative(T) :- canTeach(T,C), not hasRelativeIn(T,C).
allowedToTeachRelative(T) :- not -allowedToTeachRelative(T), teacher(T).

% a8 No teacher is assigned to teach more than 20 lessons a week.
:- teacher(T), teachingTime(T,L), L > 20.

% f1
% A class must not have more than one form teacher.
:- formteacherOf(T1,C), formteacherOf(T2,C), T1 != T2.

% f2
% A class must be taught by its form teacher.
:- formteacherOf(T,C), not assigned(T,C,_,_).

% f3
% A teacher must not be form teacher at more than one class.
:- formteacherOf(T,C1), formteacherOf(T,C2), C1 != C2.

% e1
% An extra-curricular activity (activity/2) is led by exactly one teacher.
:- activity(A,L), responsibleFor(T1,A), responsibleFor(T2,A), T1 != T2.

% e3
% No teacher is assigned to spend more than 10 hours a week for extra-curricular
% activities.
:- teacher(T), activityPrepTime(T,L), L > 10.

% e4
% Each teacher should spend at most as much time preparing extra-curricular
% activities as teaching lessons.
:- teacher(T), activityPrepTime(T,X), teachingTime(T,Y), X > Y.
