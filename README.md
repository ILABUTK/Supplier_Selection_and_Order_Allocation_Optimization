# Source code for `An Order-Splitting Model for Supplier Selection and Order Allocation in a Multi-echelon Supply Chain`

## Cite
To cite this data, please cite the research article {`!link to be added`} and the data itself, using the following DOI.

Below is the BibTex for citing this version of the data.

  >
  ```
  @article{SSOA2021,
    author =        {Yulin Sun, Cong Guo, and Xueping Li},
    journal = {`TBD`}
    year =          {2021},
    doi =           {`TBD`},
    url =           {https://github.com/ILABUTK/Supplier_Selection_and_Order_Allocation_Optimization},
  } 
  ```
![Illustration of the supplier selection & order split problem](/images/ssoa.png)
![Illustration of the order split model for the warehouse](/images/warehouse.png)

## Abstract
We consider an integrated supplier selection and inventory control problem for a multi-echelon inventory system with an order-splitting policy. A buyer firm consisting of one warehouse and $N$ identical retailers procures a type of product from a group of potential suppliers; the acquisition of the warehouse takes place when the inventory level depletes to a reorder point $R$, and the order $Q$ is simultaneously split among $m$ selected suppliers. We develop an exact analytical model for the order-splitting problem in a multi-echelon system, and formulate the supplier selection problem in a Mixed Integer Nonlinear Programming (MINLP) model. This model determines the optimal inventory policy that coordinates stock levels between each echelon of the systems while properly allocating orders among selected suppliers to maximize the expected profit. For verification and validation of the proposed mathematical model, we conduct several numerical analyses and implement simulation models which helps us demonstrate the model's solvability and effectiveness.


## Source Code 

We implement the MINLP model using `Matlab` with the `Knitro` package. Main files  & folders:

- `MainRun.m`: the main entry of the program, the base case
- `IBCostSeven.m`: costs calculations 
- `ConNonIA.m`: nonlinear constraints
- `ObjfunSplit.m`: the objective function
- `knitro.opt`: Knitro settings
- Folder `Long distant supplier`: investigate the scenario where we have some long distant suppliers
- Folders `Run{x}`:  scenarios with different arrival rates {`lambda`}

### How to enable `active-set` algorithm
  > Sample code:
```
%----------------Ktrlink----------------------
Knitrooptions = optimset('Algorithm', 'active-set', 'Display','iter','MaxIter',1000,'TolX',1e-6,'TolFun',1e-6,'TolCon',1e-6);
[x,fval,exitflag,output,lambda]=knitromatlab_mip(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw,w),X0,A,bq,Aeq,beq,lb,ub,@(x)ConNonlA(x,BigM,N,Lambda,Lw),xType,'knitro.opt');
```

For more details on the `active-set` algorithm, please refer to the following paper.
>
```
@ARTICLE{Byrd2004,
    author={Byrd, {Richard H.} and Gould, {Nicholas I.M.} and Jorge Nocedal and Waltz, {Richard A.}},
    journal={Mathematical Programming},
    title={An algorithm for nonlinear optimization using linear programming and equality constrained subproblems},
    volume={100},
    year={2004},
    number={1},
    pages={27-48}
}
```

## `sqp` and `interior-point` options
One may explore the use of different options.
  > Sample code:
```
%------------------------NLP Fmincon Solvers------------------------
%fmincon use the SQP algorithm, also with the parallel computing
option1 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','sqp','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 2000);
%option2 = optimoptions('fmincon','UseParallel',true,'Display','iter','Algorithm','interior-point','TolFun', 1e-10, 'TolX', 1e-10, 'TolCon', 1e-10, 'MaxFunEvals', 4000);

[x,fval,exitflag,output,lambda] = fmincon(@(x)ObjfunSplit(x,k,h,b,N,Lambda,Lr,Lw,Or,Ow,Pw),XStart,A,[],Aeq,beq,lb,ub,@(x)ConNonl(x,SmallM,BigM),option1);
```

For more details on the `fmincon` solver, please visit the [official web site](https://www.mathworks.com/help/optim/ug/fmincon.html).
