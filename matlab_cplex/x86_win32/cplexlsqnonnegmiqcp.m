function [x,resnorm,residual,exitflag,output]=cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,sostype,sosind,soswt,ctype,x0,options)
%%
% cplexlsqnonnegmiqcp
% Solve nonnegative, quadratically constrained mixed integer least squares
% problems.
%
% x = cplexlsqnonnegmiqcp(C,d) solves the mixed integer least squares
% problem min norm(C*x-d)^2 such that x >= 0.
%
% x = cplexlsqnonnegmiqcp(C,d,Aineq,bineq) solves the preceding problem
% with the additional inequality constraints Aineq*x <= bineq.
%
% x = cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq) solves the preceding
% problem with the additional equality constraints Aeq*x = beq. If no
% inequalities exist, set Aineq=[] and bineq=[].
%
% x = cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r) solves the
% preceding problem while additionally satisfying the quadratic inequality
% constraints l*x + x'*Q*x <= r. If no equalities exist, set Aeq=[] and
% beq=[].
%
% x =
% cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,sostype,sosind,soswt)
% solves the preceding problem with the additional requirement that the SOS
% constraints are satisfied. If no quadratic inequalities exist, set l=[],
% Q=[] and r=[].
%
% x =
% cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,sostype,sosind,soswt,ct
% ype) defines the types for each of the design variables. If no SOS
% constraints exist, set sostype=[],sosind=[] and soswt=[].
%
% x =
% cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,sostype,sosind,soswt,ct
% ype,x0) sets the starting point for the algorithm to x0. If all design
% variables are continuous, set ctype=[].
%
% x =
% cplexlsqnonnegmiqcp(C,d,Aineq,bineq,Aeq,beq,l,Q,r,sostype,sosind,soswt,ct
% ype,x0,options) minimizes with the default optimization options replaced
% by values in the structure options, which can be created using the
% function cplexoptimset. If you do not wish to give an initial point, set
% x0=[].
%
% x = cplexlsqnonnegmiqcp(problem) where problem is a structure.
%
% [x,resnorm] = cplexlsqnonnegmiqcp(...) returns the value of the objective
% function at the solution x: resnorm = norm(C*x-d)^2.
%
% [x,resnorm,residual] = cplexlsqnonnegmiqcp(...) returns the residual at
% the solution: C*x-d.
%
% [x,resnorm,residual,exitflag] = cplexlsqnonnegmiqcp(...) returns a value
% exitflag that describes the exit condition of cplexlsqnonnegmiqcp.
%
% [x,resnorm,residual,exitflag,output] = cplexlsqnonnegmiqcp(...) returns a
% structure output that contains information about the optimization.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexlsqnonnegmiqcp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
% ---------------------------------------------------------------------------
