sendmore([S,E,N,D,M,O,R,Y,R1,R2,R3]) :-

fd_domain([E,N,D,O,R,Y],0,9),
fd_domain([S,M],1,9),
% fd_domain([R1,R2,R3],[0,1]),

fd_all_different([S,E,N,D,M,O,R,Y]),

% S*1000 + E*100 + N*10 + D + M*1000 + O*100 + R*10 + E #= M*10000 + O*1000 + N*100 + E*10 + Y,

D + E #= Y + R1*10
R1 + N + R #= E + R2*10
R2 + E + O #= N + R3*10
R3 + S + M #= O + M*10

fd_labeling([S,E,N,D,M,O,R,Y]).
