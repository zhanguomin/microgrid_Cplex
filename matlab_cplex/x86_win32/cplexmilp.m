function [x,fval,exitflag,output]=cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype,x0,options)
%%
% cplexmilp
% Solve mixed integer linear programming problems.
%
% x = cplexmilp(f,Aineq,bineq) solves the mixed integer programming problem
% min f*x such that Aineq*x <= bineq.
%
% x = cplexmilp(f,Aineq,bineq,Aeq,beq) solves the preceding problem with
% the additional equality constraints Aeq*x = beq. If no inequalities
% exist, set Aineq=[] and bineq=[].
%
% x = cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt) solves the
% preceding problem with the additional requirement that the SOS
% constraints are satisfied. If no equalities exist, set Aeq=[] and beq=[].
%
% x = cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub) defines a
% set of lower and upper bounds on the design variables, x, so that the
% solution is in the range lb <= x <= ub. If no SOS constraints exist, set
% sostype=[], sosind=[] and soswt=[].
%
% x = cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype)
% defines the types for each of the design variables. If no bounds exist,
% set lb=[] and ub=[].
%
% x = cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype,x0)
% sets the starting point to x0. If all design variables are continuous,
% set ctype=[].
%
% x =
% cplexmilp(f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype,x0,optio
% ns) minimizes with the default optimization options replaced by values in
% the structure options, which can be created using the function
% cplexoptimset. If you do not wish to give an initial point, set x0=[].
%
% x = cplexmilp(problem) where problem is a structure.
%
% [x,fval] = cplexmilp(...) returns the value of the objective function at
% the solution x: fval = f*x.
%
% [x,fval,exitflag] = cplexmilp(...) returns a value exitflag that
% describes the exit condition of cplexmilp.
%
% [x,fval,exitflag,output] = cplexmilp(...) returns a structure output that
% contains information about the optimization.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexmilp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
