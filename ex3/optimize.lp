prepTime(C,S,L) :- class(C,G), curriculum(G,S,L), G < 3.
prepTime(C,S,X) :- class(C,G), curriculum(G,S,L), G > 2, X = 2 * L.

teachingPrepTime(T,X) :- teacher(T), #sum{ L,C,S : assigned(T,C,S,_), prepTime(C,S,L) } = X.
activityPrepTime(T,X) :- teacher(T), #sum{ L,A : responsibleFor(T,A), activity(A,L) } = X.

totalPrepTime(T,Z) :- teachingPrepTime(T,X), activityPrepTime(T,Y), Z = X + Y.

teachingTime(T,X) :- teacher(T), #sum{ L,C,S : assigned(T,C,S,L) } = X.

rating(T,C,Z) :- teacher(T), X = #sum{ V*L : preference(T,S,V), assigned(T,C,S,L) }, preference(C,T,Y), Z = X * Y.

% o1
% Minimize the deviation of the number of weekly hours spent (for teaching
% lessons and preparing extra-curricular activities) by any teacher from the
% average.

averageHours(A) :- C = #count{ T : teacher(T) }, S = #sum{ X,T : teachingTime(T,X) }, A = S / C.

rating(T,C,V) :- teacher(T), V1 = #sum{ X,A,S : assigned(T,A,S,L), preference(T,A,Y), X = Y * L }, preference(C,T,V2), V = V1 * V2.
deviation(T,D) :- teacher(T), teachingTime(T,S), averageHours(A), D = |A - S|.

#show deviation/2.

#minimize { D@3,T : teacher(T), deviation(T,D) }.

% o2
% Optimize the choice of paired teachers and classes by maximizing the
% cumulative value of rating/3.

ratings(S) :- S = #sum{ V,C,T : rating(T,C,V) }.

#show ratings/1.
#maximize { S@2 : ratings(S) }.

% o3
% Maximize teachers’ number of weekly lessons at their main classes.

-noFormteacher(T) :- formteacherOf(T,C).
noFormteacher(T) :- teacher(T), not -noFormteacher(T).

-highestGrade(T,C1) :- teacher(T), class(C1,G1), class(C2,G2), G2 > G1, assigned(T,C1,_,_), assigned(T,C2,_,_).
-highestGrade(T,C1) :- teacher(T), class(C1,G), class(C2,G), C2 > C1, assigned(T,C1,_,_), assigned(T,C2,_,_).

highestGrade(T,C) :- teacher(T), class(C,_), assigned(T,C,_,_), not -highestGrade(T,C).

mainClass(T,C) :- -noFormteacher(T), formteacherOf(T,C).
mainClass(T,C) :- noFormteacher(T), highestGrade(T,C).

#show lessonsNotInMain/2.
lessonsNotInMain(T,S) :- teacher(T), mainClass(T,M), S = #sum{ L : assigned(T,C,_,L), C != M }.

#minimize { S@1,T : lessonsNotInMain(T,S) }.
