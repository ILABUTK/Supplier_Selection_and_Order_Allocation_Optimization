%x[1:6] --> Qw1~Qw6; x(k+1): Rw;   x(k+2): Qr;     x(k+3): Rr
%define the objective function

function Obj = ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw,w)

WSet = 0;
WPrice = 0;
P=0;
[BCostW,ICostW,BCostR,ICostR] = IBCostSeven(x,k,N,Lambda,Lr,Lw);

for j = 1:k;
    P = N*Lambda/sum(x(1:k))*Ow(j)*x(k+j)/x(2*k+2);
    WSet = WSet + P;
    P = N*Lambda/sum(x(1:k))*x(j)*Pw(j);
    WPrice = WPrice + P;
end

Obj = -N*Lambda*w + WPrice + h*(N*ICostR+x(2*k+2)*ICostW)+b*(N*BCostR+x(2*k+2)*BCostW)+N*Lambda*Or/x(2*k+2)+WSet;