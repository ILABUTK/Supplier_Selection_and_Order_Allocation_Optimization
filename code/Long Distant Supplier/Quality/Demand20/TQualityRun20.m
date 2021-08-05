%This starts the order splitting optimazation model for the supplier
%selection
%-------------------------------Initial Parameters-----------------
k=6;
h=1;
b=5;
N=20;
w=100;
Lambda=20;
Lr=1;
Lw=[2,3,3,4,6,7];
Ow=[1500,1000,2000,800,4000,4800];
Pw=[84,85.0,83,83.5,82.8,82.5];
%Pw=[84.0,84.5,83.2,83.5,82.8,82.5];
Or=500;
BigM=[180,160,150,190,180,210];
qw=[0.970,0.975,0.945,0.955,0.950,0.94];   %Perfect Rate
qr=0.95;                              %Target Perfect Rate

%--------------------------Optimization Parameters---------------
A1=[qr-qw,zeros(1,k+3)];     %linear constraint A
A2=[zeros(1,2*k+1),-1,-1];
A3=[-ones(1,k),zeros(1,k),-1,0,0];
A=[A1;A2;A3];
%A=[];
bq=[0;0;0];

Aeq = [];
beq = [];
lb = [zeros(1,2*k),0,0,-150];
ub = [500,500,500,500,500,500,1,1,1,1,1,1,500,500,500];
%ub = [];
XStart = [5,0,5,0,5,5,1,0,1,0,1,1,5,10,5];

X0=XStart;
%------------------------NLP Fmincon Solvers------------------------
%fmincon use the SQP algorithm, also with the parallel computing
%option1 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','sqp','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 2000);
%option2 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','interior-point','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 4000);

%[x1,fval1] = fmincon(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw,w),XStart,A,bq,Aeq,beq,lb,ub,@(x)ConNonlA(x,BigM,N,Lambda,Lw),option1);

%X0 = roundn(x1,-1);
%for j=k+1:2*k;
    %X0(j) = ceil(X0(j));
%end
%X0 = round(X0);
%y1= fval1;

%----------------------Knitro Solver----------------------
xType = [1,1,1,1,1,1,2,2,2,2,2,2,1,1,1];
objFnType = 2;
cineqFnType = [];
extendedFeatures = [];

%----------------Ktrlink----------------------
%option3 = optimoptions('ktrlink','UseParallel',true,'Display','iter','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 2000);
%[x,fval,exitflag,output,lambda] = ktrlink(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),XStart,A,[],[],[],lb,ub,@(x)ConNonl(x,SmallM,BigM));
Knitrooptions = optimset('Algorithm', 'active-set', 'Display','iter','MaxIter',1000,'TolX',1e-6,'TolFun',1e-6,'TolCon',1e-6);
[x,fval,exitflag,output,lambda]=knitromatlab_mip(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw,w),X0,A,bq,Aeq,beq,lb,ub,@(x)ConNonlA(x,BigM,N,Lambda,Lw),xType,'knitro.opt');



%------------------------NLP Fmincon Solvers------------------------
%fmincon use the SQP algorithm, also with the parallel computing
%option1 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','sqp','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 2000);
%option2 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','interior-point','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 4000);

%[x,fval,exitflag,output,lambda] = fmincon(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),XStart,A,[],Aeq,beq,lb,ub,@(x)ConNonl(x,SmallM,BigM),option1);

%X0 = roundn(x,-1);
%for j=k+1:2*k;
    %X0(j) = ceil(X0(j));
%end
%X0 = round(X0);
%y1= fval;

%----------------------NLP OPTI Solvers--------------------------
%OPTI Constraints
%cl1 = -inf(k,1);
%cl2 = zeros(k,1);
%cl = [cl1;cl2];
%cu = cl;
%nlrhs = zeros(2*k,1);
%nle = -ones(2*k,1); % -1 for <=, 0 for ==, +1 >=         
% Integer Constraints
%xtype = 'IIIIIIBBBBBBIII';

%---------------IPOPT-------------
% Options
%opts = optiset('solver','IPOPT','display','iter');
% Build OPTI Problem
%Opt = opti('fun',@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),'nlmix',@(x)ConNonOPTI(x,SmallM,BigM),nlrhs,nle,'bounds',lb,ub,'x0',XStart,'options',opts);

%----------------Nomad------------
%X0=XStart;
%opts = optiset('solver','Nomad','display','iter');
% Build OPTI Problem
%Opt = opti('fun',@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),'nlmix',@(x)ConNonOPTI(x,SmallM,BigM),nlrhs,nle,'bounds',lb,ub,'x0',X0,'xtype',xtype,'options',opts);

% Solve NLP
%[x,fval,exitflag,info] = solve(Opt,X0);



%------------GA Options-----------------------------------------------
%GA Options
%IntCon  = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
%nvars = 15;
%gaoptions = gaoptimset('StallGenLimit',50,'TolFun',1e-10,'Generations',1000,'PlotFcns',@gaplotbestfun,'Display','iter','UseParallel',true);

%[x,fval,exitflag] = ga(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),nvars,A,[],Aeq,beq,lb,ub,@(x)ConNonl(x,SmallM,BigM),IntCon,gaoptions);

