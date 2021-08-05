%define nonlinear constraints
% k number of suppliers = 6;
% x[1:k] --> Qw1~Qw6; x[k+1:2k] --> y1~y6;  x(2*k+1): Rw;   x(2*k+2): Qr;     x(2*k+3): Rr

function [c,ceq] = ConNonlA(x,BigM,N,Lambda,Lw)

k = length(BigM);
c = zeros((k),1);
for j=1:k
c(j) = N*Lambda./sum(x(1:k)).*x(j) - BigM(j)*x(k+j);
end
%c(k+1) = Lw(k)- sum(x(1:k)).*x(2*k+2)./N./Lambda;
ceq = [];
