function [x,fval,exitflag,output,lambda]=cplexqcp(H, f, Aineq, bineq, Aeq, beq, l, Q, r, lb, ub, x0, options)
%%
% cplexqcp
% Solve quadratically constrained linear/quadratic programming problems.
%
% x = cplexqcp(H,f,Aineq,bineq) solves the quadratically constrained
% linear/quadratic programming problem min 1/2*x'*H*x + f*x subject to
% Aineq*x <= bineq. If no quadratic objective term exists, set H=[].
%
% x = cplexqcp(H,f,Aineq,bineq,Aeq,beq) solves the preceding problem while
% additionally satisfying the equality constraints Aeq*x = beq. If no
% inequalities exist, set Aineq=[] and bineq=[].
%
% x = cplexqcp(H,f,Aineq,bineq,Aeq,beq,l,Q,r) solves the preceding problem
% while additionally satisfying the quadratic inequality constraints
% l*x + x'*Q*x <= r. If no equalities exist, set Aeq=[] and beq=[].
%
% x = cplexqcp(H,f,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub) defines a set of lower
% and upper bounds on the design variables, x, so that the solution is in
% the range lb <= x <= ub. If no quadratic inequalities exist, set l=[],
% Q=[] and r=[].
%
% x = cplexqcp(H,f,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub,x0) sets the starting
% point to x0. If no bounds exist, set lb=[] and ub=[].
%
% x = cplexqcp(H,f,Aineq,bineq,Aeq,beq,l,Q,r,lb,ub,x0,options) minimizes
% with the default optimization options replaced by values in the structure
% options, which can be created using the function cplexoptimset. If you do
% not wish to give an initial point, set x0=[].
%
% x = cplexqcp(problem) where problem is a structure.
%
% [x,fval] = cplexqcp(...) returns the value of the objective function at
% the solution x: fval = 0.5*x'*H*x + f*x.
%
% [x,fval,exitflag] = cplexqcp(...) returns a value exitflag that describes
% the exit condition of cplexqcp.
%
% [x,fval,exitflag,output] = cplexqcp(...) returns a structure output that
% contains information about the optimization.
%
% [x,fval,exitflag,output,lambda] = cplexqcp(...) returns a structure
% lambda whose fields contain the Lagrange multipliers at the solution x.
%
%  See also cplexoptimset
%

% ---------------------------------------------------------------------------
% File: cplexqcp.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
   function out = isconsistent (H, f, qc, Aineq, bineq, Aeq, beq, lb, ub, x0, options)
      out = 1;
      cols = 0;
      
      if ~isempty (Aineq) && ~isempty (bineq)
         if ~isa (Aineq, 'numeric') || ndims (Aineq) ~= 2,
            error ('Error: Aineq not a valid constraint matrix');
         end
         [rows cols] = size (Aineq);
         if ~isa (bineq, 'numeric') || ndims (bineq) ~= 2,
            error ('Error: bineq not a valid constraint rhs vector');
         end
         
         if size (bineq, 1) ~= rows || size (bineq, 2) ~= 1,
            error ('Error: bineq has incompatible dimensions');
         end
      end
      
      if ~isempty (Aeq) && ~isempty (beq)
         if ~isa (Aeq, 'numeric') || ndims (Aeq) ~= 2,
            error ('Error: Aeq not a valid constraint matrix');
         end
         [eqrows eqcols] = size (Aeq);
         if eqcols ~= cols && cols ~= 0
            error ('Error: cols of Aeq and A are not equal');
         end
         
         if ~isa (beq, 'numeric') || ndims (beq) ~= 2,
            error ('Error: beq not a valid constraint rhs vector');
         end
         
         if size(beq, 1) ~= eqrows   || size(beq, 2) ~= 1,
            error ('Error: beq has incompatible dimensions');
         end
         if cols == 0
            cols = eqcols;
         end
      end
      
      if ~isa (f, 'numeric') || ndims (f) ~= 2,
         error ('Error: f not a valid objective vector');
      end
      
      if size (f, 1) ~= cols || size (f, 2) ~= 1,
         error ('Error: f has incompatible dimensions');
      end
      
      if ~isempty (H)
         if ~isa (H, 'numeric') || ...
            ndims (H) ~= 2      || ...
            size (H,2) ~= cols  || ...
            size (H, 1) ~= cols,
            error ('Error: H not a valid H matrix');
         end
      end
      
      if ~isempty (qc)
         if ~isa (qc, 'struct'),
            error ('Error: qc not a struct');
         end
         if ~isfield (qc, 'a')   || ...
            ~isfield (qc, 'rhs') || ...
            ~isfield (qc, 'Q')   || ...
            ~isfield (qc, 'sense'),
            error ('Error: qc not a valid  model qc');
         else
            for i = 1:size (qc, 2)
               if isempty (qc(i).sense) ||...
                  isempty(qc(i).rhs),
                  error ('Error: qc not a valid  model qc');
               end
               if  ~isa (qc(i).a, 'numeric') || ...
                   length (qc(i).a) ~= cols  || ...
                   ndims (qc(i).a) ~= 2      || ...
                   size (qc(i).a, 2) ~= 1,
                  error ('Error: qc not a valid  model qc.a.');
               end
               if ~isa (qc(i).Q, 'numeric') || ...
                  ndims (qc(i).Q) ~= 2      || ...
                  size (qc(i).Q, 2) ~= cols || ...
                  size (qc(i).Q, 1) ~= cols,
                  error ('Error: qc not a valid  model qc.Q');
               end
               if ~isa (qc(i).rhs, 'numeric')
                  error ('Error: qc not a valid  model qc.rhs');
               end
               if ~isequal (qc(i).sense, 'L') && ...
                  ~isequal (qc(i).sense, 'G')
                  error ('Error: qc not a valid  model qc.sense');
               end
            end
         end
      end
      
      if ( isempty (Aeq) && ~isempty (beq) ) ||...
         ( ~isempty (Aeq) && isempty (beq) ),
         error ('Error: Aeq or beq are not valid ');
      end
      if ~isempty (lb)
         if ~isa (lb, 'numeric') || ndims (lb) ~= 2,
            error ('Error: lb not a valid bound vector');
         end
         if size (lb, 1) ~= cols || size (lb, 2) ~= 1,
            error ('Error: lb has incompatible dimensions');
         end
      end
      if ~isempty(ub)
         if ~isa(ub, 'numeric') || ndims(ub) ~= 2,
            error ('Error: ub:not a valid  bound vector');
         end
         if size (ub, 1) ~= cols || size (ub, 2) ~= 1,
            error ('Error: ub has incompatible dimensions');
         end
      end
      
      if ~isempty (x0)
         if ~isa (x0, 'numeric') || ndims (x0) ~= 2,
            error ('Error: x0 not a valid start x vector');
         end
         
         if size (x0, 1) ~= cols || size (x0, 2) ~= 1,
            error ('Error: x0 has incompatible dimensions');
         end
      end
      if ~isempty (options)
         if ~isa (options, 'struct'),
            error ('Error: options not a struct');
         end
      end
   end
end
