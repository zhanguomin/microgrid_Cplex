function [x, fval, exitflag, output, lambda] = cplexlp (f, Aineq, bineq, Aeq, beq, lb, ub, x0, options)
%%
% cplexlp
% Solve linear programming problems.
%
% x = cplexlp(f,Aineq,bineq) solves the linear programming problem min f*x
% such that Aineq*x <= bineq.
%
% x = cplexlp(f,Aineq,bineq,Aeq,beq) solves the preceding problem with the
% additional equality constraints Aeq*x = beq. If no inequalities exist,
% set Aineq=[] and bineq=[].
%
% x = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub) defines a set of lower and upper
% bounds on the design variables, x, so that the solution is always in the
% range lb <= x <= ub. If no equalities exist, set Aeq=[] and beq=[].
%
% x = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub,x0) sets the starting point for
% the algorithm to x0. If no bounds exist, set lb=[] and ub=[].
%
% x = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub,x0,options) minimizes with the
% default optimization options replaced by values in the structure options,
% which can be created using the function cplexoptimset. If you do not wish
% to give an initial point, set x0=[].
%
% x = cplexlp(problem) where problem is a structure.
%
% [x,fval] = cplexlp(...) returns the value of the objective function at
% the solution x: fval = f*x.
%
% [x,fval,exitflag] = cplexlp(...) returns a value exitflag that describes
% the exit condition of cplexlp.
%
% [x,fval,exitflag,output] = cplexlp(...) returns a structure output that
% contains information about the optimization.
%
% [x,fval,exitflag,output,lambda] = cplexlp(...) returns a structure lambda
% whose fields contain the Lagrange multipliers at the solution x.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexlp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
