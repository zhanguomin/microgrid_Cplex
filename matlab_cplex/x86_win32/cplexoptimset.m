function options = cplexoptimset (varargin)
%%
% cplexoptimset
% Create or edit optimization options structure.
%
% Description
% options = cplexoptimset('param1',value1,'param2',value2,...) creates an
% optimization options structure called options, in which the specified
% options (param) have specified values. The specified options can 
% correspond to the options in the MATLAB(R) Optimization Toolbox. Or, 
% they can correspond to other CPLEX parameters, using the same syntax as 
% cplexoptimset('cplex') to identify parameters. Any unspecified 
% options are set to [] (options with value [] indicate that the default 
% value for that option should be used when options is passed to the 
% optimization function).
%
% cplexoptimset with no input or output arguments displays a complete list
% of options with their valid values.
%
% options = cplexoptimset (with no input arguments) creates an option
% structure options where all fields are set to [], which instructs
% CPLEX(R) to use all default parameter values. 
%
% options = cplexoptimset ('cplex') creates a structure options, which 
% contains all of the CPLEX parameters.  Use this method when you need to 
% set parameters that do not correspond to the options in the MATLAB 
% Optimization Toolbox.
%
% options = cplexoptimset(oldopts,'param1',value1,...) creates a copy of
% oldopts, modifying the specified options with the specified values.
%
% options = cplexoptimset(oldopts,newopts) combines an existing options
% structure, oldopts, with a new options structure, newopts. Any options in
% newopts with nonempty values overwrite the corresponding old options in
% oldopts.
%
%  See also cplexoptimget
%

% ---------------------------------------------------------------------------
% File: cplexoptimset.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
