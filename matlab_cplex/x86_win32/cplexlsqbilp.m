function [x,resnorm,residual,exitflag,output]=cplexlsqbilp(C,d,Aineq,bineq,Aeq,beq,lb,ub,x0,options)
%%
% cplexlsqbilp
% Solve constrained binary integer least squares problems.
%
% x = cplexlsqbilp(C,d,Aineq,bineq) solves the constrained binary integer
% least squares problem min norm(C*x-d)^2 such that Aineq*x <= bineq.
%
% x = cplexlsqbilp(C,d,Aineq,bineq,Aeq,beq) solves the preceding problem
% with the additional equality constraints Aeq*x = beq. If no inequalities
% exist, set Aineq=[] and bineq=[].
%
% x = cplexlsqbilp(C,d,Aineq,bineq,Aeq,beq,lb,ub)
% defines a set of lower and upper bounds on the design variables, x, so
% that the solution is always in the range lb <= x <= ub. The only 
% meaningful bounds to add are between 0 and 1; otherwise, the bounds will
% either not affect the problem or make the problem infeasible. If no 
% equalities exist, set Aeq=[] and beq=[].
%
% x =
% cplexlsqbilp(C,d,Aineq,bineq,Aeq,beq,lb,ub,x0) 
% sets the starting point for the algorithm to x0. If no bounds exist, set
% lb=[] and ub=[]. 
%
% x =
% cplexlsqbilp(C,d,Aineq,bineq,Aeq,beq,lb,ub,x0,options) 
% minimizes with the default optimization options replaced
% by values in the structure options, which can be created using the
% function cplexoptimset. If you do not wish to give an initial point, set
% x0=[].
%
% x = cplexlsqbilp(problem) where problem is a structure.
%
% [x,resnorm] = cplexlsqbilp(...) returns the value of the objective
% function at the solution x: resnorm = norm(C*x-d)^2.
%
% [x,resnorm,residual] = cplexlsqbilp(...) returns the residual at the
% solution: C*x-d.
%
% [x,resnorm,residual,exitflag] = cplexlsqbilp(...) returns a value
% exitflag that describes the exit condition of cplexlsqbilp.
%
% [x,resnorm,residual,exitflag,output] = cplexlsqbilp(...) returns a
% structure output that contains information about the optimization.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexlsqbilp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
