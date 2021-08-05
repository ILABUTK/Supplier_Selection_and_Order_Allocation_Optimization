%Update Version 7; Use the simple expressions

% Order-Splitting Model:
% This function returns the calculation for Inventory and Backorder Level,
% k number of suppliers = 6;
% x[1:k] --> Qw1~Qw6; x[k+1:2k] --> y1~y6;  x(2*k+1): Rw;   x(2*k+2): Qr;     x(2*k+3): Rr
% x = [37,21,47,3]
% [BCostW,ICostW,BCostR,ICostR] = IBCost(x,20,10,1,7,2)

function [BCostW,ICostW,BCostR,ICostR] = IBCostEight(x,k,N,Lambda,Lr,Lw)
%Initial variables
Lambda_W = N.*Lambda./x(2*k+2);
CycleT = sum(x(1:k))./Lambda_W;
Diff = 0;
Bw = zeros((k+1),1);
%Iw2 = zeros(k,1);
%Edw = zeros(k,1); 
%Vdw = zeros(k,1);
%BAw = zeros(k,1);
%IAw = zeros(k,1);
%BBw = zeros(k,1);
%IBw = zeros(k,1);
%Iw1 = zeros(k,1);
%Bw1 = zeros(k,1);

%Warehouse expected backorder level
%for j = 1:k
    %Edw(j) = Lambda_W.*Lw(j);
    %Vdw(j) = sqrt(Edw(j));
    %BAw(j) = quadgk(@(z)(z-(x(2*k+1)+sum(x(1:j)))).*normpdf(z,Edw(j),Vdw(j)), x(2*k+1)+sum(x(1:j)), Inf);
    %Verification by using function Integral
    %BAw(j) = integral(@(z)(z-(x(2*k+1)+sum(x(1:j)))).*1./sqrt(2.*pi.*Lambda_W.*Lw(j)).*exp(-0.5./Lambda_W./Lw(j).*(z-Lambda_W.*Lw(j)).^2), x(2*k+1)+sum(x(1:j)), Inf);
%end
%BBw(1) = quadgk(@(z)(z-x(2*k+1)).*normpdf(z,Edw(1),Vdw(1)),x(2*k+1),Inf);
%Bw1(k) = 1/2.*BBw(1).*BBw(1)./Lambda_W;
for j = 2:k
    %Backorder1 linear approximated 
    %BBw(j) = quadgk(@(z)(z-(x(2*k+1)+sum(x(1:j-1)))).*normpdf(z,Edw(j),Vdw(j)),x(2*k+1)+sum(x(1:j-1)),Inf);
    %Bw1(j-1) = (BAw(j-1)+BBw(j))./2.*(BBw(j)-BAw(j-1))./Lambda_W;
    %Bw1(j-1) = 1/2.*BBw(j-1).*BBw(j-1)./Lambda_W;
 
    %Backorder2 function by time t
    %Bt = @(z,t) (z-(x(2*k+1)+sum(x(1:j-1)))).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t));   
    %Bt = @(z,t) (z-(x(2*k+1)+sum(x(1:j-1)))).*1./sqrt(2.*pi.*Lambda_W.*t).*exp(-0.5./Lambda_W./t.*(z-Lambda_W.*t).^2);
    %Bw(j-1) = mydblquad(Bt, x(2*k+1)+sum(x(1:j-1)), inf, Lw(j-1),Lw(j));
    %Bw(j-1) = integral2(@(z,t) (z-(x(2*k+1)+sum(x(1:j-1)))).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t)), x(2*k+1)+sum(x(1:j-1)), inf, Lw(j-1),Lw(j));
    Bw(j-1) = quadgk(@(t) (Lambda_W.*t-(x(2*k+1)+sum(x(1:j-1)))).*normcdf((Lambda_W.*t-(x(2*k+1)+sum(x(1:j-1))))./sqrt(Lambda_W.*t))+sqrt(Lambda_W.*t).*normpdf(((x(2*k+1)+sum(x(1:j-1)))-Lambda_W.*t)./sqrt(Lambda_W.*t)),Lw(j-1)*x(k+j-1),Lw(j)*x(k+j));
end

%Bt = @(z,t) (z-(x(2*k+1))).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t));
%Bw(k) = integral2(@(z,t) (z-(x(2*k+1))).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t)), x(2*k+1), inf, 0, Lw(1));
Bw(k) = quadgk(@(t) (Lambda_W.*t-(x(2*k+1))).*normcdf((Lambda_W.*t-(x(2*k+1)))./sqrt(Lambda_W.*t))+sqrt(Lambda_W.*t).*normpdf(((x(2*k+1))-Lambda_W.*t)./sqrt(Lambda_W.*t)),0,Lw(1));
%Bw(k+1) = integral2(@(z,t) (z-(x(2*k+1)+sum(x(1:k)))).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t)), x(2*k+1)+sum(x(1:k)), inf, Lw(k), CycleT);
%Bw(k+1) = quadgk(@(t) (Lambda_W.*t-(x(2*k+1)+sum(x(1:k)))).*normcdf((Lambda_W.*t-(x(2*k+1)+sum(x(1:k))))./sqrt(Lambda_W.*t))+sqrt(Lambda_W.*t).*normpdf(((x(2*k+1)+sum(x(1:k)))-Lambda_W.*t)./sqrt(Lambda_W.*t)),Lw(k), CycleT);
%BCostW1 = sum(Bw1)./CycleT;
BCostW = sum(Bw).*N.*Lambda/sum(x(1:k))./x(2*k+2);

%Warehouse expected on-hand inventory level
%IAw(k) = x(2*k+1)+sum(x(1:k))+BAw(k)-Edw(k);
%IBw(1) = x(2*k+1)+BBw(1)-Edw(1);
%Iw1(k) = (IAw(k)+IBw(1))./2.*(IAw(k)-IBw(1))./Lambda_W;
%for j = 2:k
    %IAw(j-1) = x(2*k+1)+sum(x(1:j-1))+BAw(j-1)-Edw(j-1);
    %IBw(j) = x(2*k+1)+sum(x(1:j-1))+BBw(j)-Edw(j);
    %Iw1(j-1) = (IAw(j-1)+IBw(j))./2.*(IAw(j-1)-IBw(j))./Lambda_W;
    %Iw1(j-1) = (IAw(j-1)+IBw(j))./2.*(Lw(j)-Lw(j-1));
    
    %Inventory 2 function by time t
    %It = @(z,t) (x(2*k+1)+sum(x(1:j-1))-z).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t));
    %Iw2(j-1) = integral2(It, -inf, x(2*k+1)+sum(x(1:j-1)), Lw(j-1), Lw(j));
%end
%It = @(z,t) (x(2*k+1)+sum(x(1:k))-z).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t));
%It0 = @(z,t) (x(2*k+1)-z).*normpdf(z,Lambda_W.*t,sqrt(Lambda_W.*t));
%Iw2(k) = integral2(It0, -inf, x(2*k+1), 0, Lw(1)) + integral2(It, -inf, x(2*k+1)+sum(x(1:k)), Lw(6), CycleT);  
%ICostW1 = sum(Iw1)./CycleT;
%ICostW2 = sum(Iw2).*N.*Lambda/sum(x(1:k))./x(2*k+2);

%Warehouse on-hand inventory = net inventory plus outstanding backorders
%Calculate the difference of net inventory value between the normal (Q,R)
%model and order-splitting model
for j = 1:k-1
    Diff = Diff + sum(x(1:j)).*(Lw(j+1)-Lw(j));
end
ICostW = Diff.*N.*Lambda/sum(x(1:k))./x(2*k+2) + (sum(x(1:k))+1)/2 + x(2*k+1) - N.*Lambda./x(2*k+2).*Lw(k) + BCostW;

%Retailer expected backorder and on-hand inventory level
Edr = Lambda.*Lr + x(2*k+2).*BCostW./N;
Vdr = sqrt(Edr);
Zrr = (x(2*k+3)-Edr)./Vdr;
ZrQr = (x(2*k+3)+x(2*k+2)-Edr)./Vdr;
brr = Vdr.^2./2.*((Zrr.^2+1)*(1-normcdf(Zrr))-Zrr.*normpdf(Zrr));
brQr = Vdr.^2./2.*((ZrQr.^2+1)*(1-normcdf(ZrQr))-Zrr.*normpdf(ZrQr));
BCostR = 1./x(2*k+2).*(brr-brQr);
ICostR = (x(2*k+2)+1)./2+x(2*k+3)+BCostR-Edr;

return
