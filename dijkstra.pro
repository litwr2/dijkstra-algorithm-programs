p(1,2,4).
p(1,3,11).
p(2,3,5).
p(2,4,2).
p(2,5,8).
p(2,6,7).
p(3,5,5).
p(3,6,3).
p(4,5,1).
p(4,6,10).
p(5,6,3).

max(3200000).       %this number is regarded as the max integer

:- dynamic(s/1, d/2, min_d/2, pd/3).

w(A,B) :-                                  %seeks the shortest path from A to B
  retractall(pd(_,_)), retractall(d(_,_)), fail;
  p(X,Y,L), assertz(pd(X,Y,L)), fail;
  pd(X,Y,_), retractall(s(X)), assertz(s(X)), retractall(s(Y)), assertz(s(Y)),fail;
  assertz(d(A,0)), retractall(s(A)), fail;
  s(X), max(M), assertz(d(X,M)), fail;
  pd(A,X,L), retractall(d(X,_)), assertz(d(X,L)), fail;
  w1(B), write(A), sw(A,B), nl, !.

w1(B) :- 
  retractall(min_d(_,_)), max(M), assertz(min_d(0,M)), fail;
  s(I), d(I,L), min_d(J,L1), L < L1, retract(min_d(J,L1)),
    assertz(min_d(I,L)), fail;
  min_d(J,L), retract(s(J)), J = B, write(L), nl, !;
  min_d(J,L), s(I), pd(J,I,L0), d(I,L1), L2 is L + L0, L2 < L1,
    retract(d(I,L1)), assertz(d(I,L2)), fail;
  w1(B).

sw(A,B) :-                                                   %prints route
  A = B, !;
  d(A,L1), pd(A,X,L2), d(X,L3), L3 is L1 + L2, write('-'),
    write(X), sw(X,B).

