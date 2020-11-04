function [x,resnorm,residual,exitflag,output]=cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub,x0,options)
%%
% cplexlsqqcp
% Solve quadratically constrained least squares problems.
%
% x = cplexlsqqcp(C,d,Aineq,bineq) solves the constrained least squares
% problem min norm(C*x-d)^2 such that Aineq*x <= bineq.
%
% x = cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq) solves the preceding problem
% with the additional equality constraints Aeq*x = beq. If no inequalities
% exist, set Aineq=[] and bineq=[].
%
% x = cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r) solves the preceding
% problem while additionally satisfying the quadratic inequality
% constraints l*x + x'*Q*x <= r. If no equalities exist, set Aeq=[] 
% and beq=[].
%
% x = cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub)
% defines a set of lower and upper bounds on the design variables, x, so
% that the solution is always in the range lb <= x <= ub.  If no quadratic
% inequalities exist, set l=[], Q=[] and r=[].
%
% x =
% cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub,x0) 
% sets the starting point for the algorithm to x0. If no bounds exist, set
% lb=[] and ub=[]. 
%
% x =
% cplexlsqqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub,x0,options) 
% minimizes with the default optimization options replaced
% by values in the structure options, which can be created using the
% function cplexoptimset. If you do not wish to give an initial point, set
% x0=[].
%
% x = cplexlsqqcp(problem) where problem is a structure.
%
% [x,resnorm] = cplexlsqqcp(...) returns the value of the objective
% function at the solution x: resnorm = norm(C*x-d)^2.
%
% [x,resnorm,residual] = cplexlsqqcp(...) returns the residual at the
% solution: C*x-d.
%
% [x,resnorm,residual,exitflag] = cplexlsqqcp(...) returns a value
% exitflag that describes the exit condition of cplexlsqqcp.
%
% [x,resnorm,residual,exitflag,output] = cplexlsqqcp(...) returns a
% structure output that contains information about the optimization.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexlsqqcp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
