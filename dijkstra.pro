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

:- dynamic(s/1, d/2, min_d/2, pd/3).

w(A,B) :-                                  %really seeks path from B to A
  retractall(pd(_,_)), retractall(d(_,_)), fail;
  p(X,Y,L), assertz(pd(X,Y,L)), assertz(pd(Y,X,L)), fail;
  pd(X,_,_), retractall(s(X)), assertz(s(X)), fail;
  assertz(d(B,0)), retractall(s(B)), fail;
  s(X), assertz(d(X,320000)), fail;        %320000 regarded as max integer
  pd(B,X,L), retractall(d(X,_)), assertz(d(X,L)), fail;
  w1(A), write(A), sw(A,B), nl, !.

w1(B) :- 
  retractall(min_d(_,_)), assertz(min_d(0,320000)), fail;
  s(I), d(I,L), min_d(I1,L1), L < L1, retractall(min_d(I1,L1)),
    assertz(min_d(I,L)), fail;
  min_d(J,L), retractall(s(J)), J = B, write(L), nl, !;
  min_d(J,L), s(I), pd(J,I,L0), d(I,L1), L2 is L + L0, L2 < L1,
    retractall(d(I,L1)), assertz(d(I,L2)), fail;
  w1(B).

sw(A,B) :-                                                   %prints route
  A = B;
  d(A,L1), pd(A,X,L2), d(X,L3), L1 is L3 + L2, write('-'),
    write(X), sw(X,B).
