function [x,resnorm,residual,exitflag,output,lambda]=cplexlsqnonneglin(C,d,Aineq,bineq,Aeq,beq,x0,options)
%%
% cplexlsqnonneglin
% Solve nonnegative least squares problems.
%
% x = cplexlsqnonneglin(C,d) solves the least squares problem min
% norm(C*x-d)^2 such that x >= 0.
%
% x = cplexlsqnonneglin(C,d,Aineq,bineq) solves the preceding problem 
% with the additional inequality constraints Aineq*x <= bineq.
%
% x = cplexlsqnonneglin(C,d,Aineq,bineq,Aeq,beq) solves the preceding
% problem with the additional equality constraints Aeq*x = beq. If no 
% inequalities exist, set Aineq=[] and bineq=[]. 
%
% x = cplexlsqnonneglin(C,d,Aineq,bineq,Aeq,beq,x0) sets the starting point 
% for the algorithm to x0.  If no equalities exist, set Aeq=[] and beq=[].
%
% x = cplexlsqnonneglin(C,d,Aineq,bineq,Aeq,beq,x0,options) minimizes with 
% the default optimization options replaced by values in the structure 
% options, which can be created using the function cplexoptimset. 
% If you do not wish to give an initial point, set x0=[].
%
% x = cplexlsqnoneglin(problem) where problem is a structure.
%
% [x,resnorm] = cplexlsqnonneglin(...) returns the value of the objective
% function at the solution x: resnorm = norm(C*x-d)^2.
%
% [x,resnorm,residual] = cplexlsqnonneglin(...) returns the residual at the
% solution: C*x-d.
%
% [x,resnorm,residual,exitflag] = cplexlsqnonneglin(...) returns a value
% exitflag that describes the exit condition of cplexlsqnonneglin.
%
% [x,resnorm,residual,exitflag,output] = cplexlsqnonneglin(...) returns a
% structure output that contains information about the optimization.
%
% [x,resnorm,residual,exitflag,output,lambda] = cplexlsqnonneglin(...)
% returns a structure lambda whose fields contain the Lagrange multipliers
% at the solution x.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexlsqnonneglin.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
