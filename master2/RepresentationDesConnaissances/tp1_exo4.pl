monnaie(T,P,[E2,E1,C50,C20,C10],[XE2,XE1,XC50,XC20,XC10]):-

fd_domain(XE2,0,E2),
fd_domain(XE1,0,E1),
fd_domain(XC50,0,C50),
fd_domain(XC20,0,C20),
fd_domain(XC10,0,C10),

T - P #= XE2*200 + XE1*100 + XC50*50 + XC20*20 + XC10*10,

fd_labeling(T,P,[E2,E1,C50,C20,C10],[XE2,XE1,XC50,XC20,XC10]).
