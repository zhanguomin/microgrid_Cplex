function [x, fval, exitflag, output] = cplexbilp(f, Aineq, bineq, Aeq, beq, x0, options)
%%
% cplexbilp
% Solve binary integer programming problems.
%
% x = cplexbilp(f) solves the binary integer programming problem min f*x.
%
% x = cplexbilp(f, Aineq, bineq) solves the binary integer programming
% problem min f*x such that Aineq*x <= bineq.
%
% x = cplexbilp(f, Aineq, bineq, Aeq, beq) solves the preceding problem
% with the additional equality constraints Aeq*x = beq. If no inequalities
% exist, set Aineq=[] and bineq=[].
%
% x = cplexbilp(f, Aineq, bineq, Aeq, beq, x0) sets the starting point for
% the algorithm to x0. If no equalities exist, set Aeq=[] and beq=[].
%
% x = cplexbilp(f, Aineq, bineq, Aeq, beq, x0, options) minimizes with the
% default optimization options replaced by values in the structure options,
% which can be created using the function cplexoptimset. If you do not wish
% to give an initial point, set x0=[].
%
% x = cplexbilp(problem) where problem is a structure.
%
% [x,fval] = cplexbilp(...) returns the value of the objective function at
% the solution x: fval = f*x.
%
% [x,fval,exitflag] = cplexbilp(...) returns a value exitflag that
% describes the exit condition of cplexbilp.
%
% [x,fval,exitflag,output] = cplexbilp(...) returns a structure output that
% contains information about the optimization.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexbilp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
