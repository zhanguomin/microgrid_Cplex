classdef CpxInfo < handle

% CpxInfo - The CpxInfo object will be passed to the CPLEX(R) callback
   %           during MIP optimization. The callback function is called
   %           with such an object as parameter.
   %           Its properties are initialized to represent the current
   %           solution/progress of the solve and can be queried by the
   %           callback function.

% ---------------------------------------------------------------------------
% File: CpxInfo.m
% ---------------------------------------------------------------------------
% Licensed Materials - Property of IBM
% 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
% Copyright IBM Corporation 2008, 2011. All Rights Reserved.
%
% US Government Users Restricted Rights - Use, duplication or
% disclosure restricted by GSA ADP Schedule Contract with
% IBM Corp.
% ---------------------------------------------------------------------------
   properties (Hidden=true)
      Cpx;                % Cplex object calling CpxInfo
      IsOpen = false;     % if properties can be set
      IsStop = false;     % if stop has been returned before
      CbHandle;           % cbhandle passed to C++ callback() handle function
   end%end of properties
   properties
      % NumNodes
      %  Total number of nodes solved.
      NumNodes;
      % NumIters
      %  Total number of MIP iterations.
     NumIters;
      % Cutoff
      %  Updated cutoff value.
      Cutoff;
      % BestObj
      %  Objective value of best remaining node.
      BestObj;
      % IncObj
      %  Objective value of best integer solution.
      IncObj;
      % IncX
      %  x value of best integer solution.
      IncX;
      % MipGap
      %  Value of relative gap in a MIP.
      MipGap
      Ncliques;
      % Ncliques
      %  number of clique cuts added.
      Ncovers;
      % Ncovers
      %  number of cover cuts added.
      NflowCovers;
      % NflowCovers
      %  number of flowCover cuts added.
      NflowPaths;
      % NflowPaths
      %  number of flowPath cuts added.
      NGUBcovers;
      % NGUBcovers
      %  number of GUBcover cuts added.
      NfractionalCuts;
      % NfractionalCuts
      %  number of fractional cuts added.
      NdisjunctiveCuts;
      % NdisjunctiveCuts
      %  number of disjunctive cuts added.
      NMIRs;
      % NMIRs
      %  number of MIR cuts added.
      NimpliedBounds;
      % NimpliedBounds
      %  number of impliedBounds cuts added.
      NzeroHalfCuts;
      % NzeroHalfCuts
      %  number of zeroHalf cuts added.
      NMCFCuts;
      % NMCFCuts
      %  number of MCF cuts added.
   end%end of properties
      function obj = set.NumNodes(obj,value) %#ok<MCHV2>
         % Set NumNodes
         % See also CpxInfo.
      end%end of function
      function obj = set.NumIters(obj,value)
         % Set NumIters
         % See also CpxInfo.
      end%end of function
      function obj = set.Cutoff(obj,value)
         % Set Cutoff
         % See also CpxInfo.
      end%end of function
      function obj = set.BestObj(obj,value)
         % Set BestObj
         % See also CpxInfo.
      end%end of function
      function obj = set.IncObj(obj,value)
         % Set IncObj
         % See also CpxInfo.
      end%end of function
      function obj = set.IncX(obj,value)
         % Set IncX
         % See also CpxInfo.
      end%end of function
      function obj = set.MipGap(obj,value)
         % Set MipGap
         % See also CpxInfo.
      end%end of function
      function obj = set.Ncliques(obj,value)
         % Set Ncliques
         % See also CpxInfo.
      end%end of function
      function obj = set.Ncovers(obj,value)
         % Set Ncovers
         % See also CpxInfo.
      end%end of function
      function obj = set.NflowCovers(obj,value)
         % Set NflowCovers
         % See also CpxInfo.
      end%end of function
      function obj = set.NflowPaths(obj,value)
         % Set NflowPaths
         % See also CpxInfo.
      end%end of function
      function obj = set.NGUBcovers(obj,value)
         % Set NGUBcovers
         % See also CpxInfo.
      end%end of function
      function obj = set.NfractionalCuts(obj,value)
         % Set NfractionalCuts
         % See also CpxInfo.
      end%end of function
      function obj = set.NdisjunctiveCuts(obj,value)
         % Set NdisjunctiveCuts
         % See also CpxInfo.
      end%end of function
      function obj = set.NMIRs(obj,value)
         % Set NMIRs
         % See also CpxInfo.
      end%end of function
      function obj = set.NimpliedBounds(obj,value)
         % Set NimpliedBounds
         % See also CpxInfo.
      end%end of function
      function obj = set.NzeroHalfCuts(obj,value)
         % Set NzeroHalfCuts
         % See also CpxInfo.
      end%end of function
      function obj = set.NMCFCuts(obj,value)
         % Set NMCFCuts
         % See also CpxInfo.
      end%end of function
      function val = get.NumNodes(obj)
         % Get NumNodes
         % See also CpxInfo.
      end%end of function
      function val = get.NumIters(obj)
         % Get NumIters
         % See also CpxInfo.
      end%end of function
      function val = get.Cutoff(obj)
         % Get Cutoff
         % See also CpxInfo.
      end%end of function
      function val = get.BestObj(obj)
         % Get BestObj
         % See also CpxInfo.
      end%end of function
      function val = get.IncObj(obj)
         % Get IncObj
         % See also CpxInfo.
      end%end of function
      function val = get.IncX(obj)
         % Get IncX
         % See also CpxInfo.
      end%end of function
      function val = get.MipGap(obj)
         % Get MipGap
         % See also CpxInfo.
      end%end of function
      function val = get.Ncliques(obj)
         % Get Ncliques
         % See also CpxInfo.
      end%end of function
      function val = get.Ncovers(obj)
         % Get Ncovers
         % See also CpxInfo.
      end%end of function
      function val = get.NflowCovers(obj)
         % Get NflowCovers
         % See also CpxInfo.
      end%end of function
      function val = get.NflowPaths(obj)
         % Get NflowPaths
         % See also CpxInfo.
      end%end of function
      function val = get.NGUBcovers(obj)
         % Get NGUBcovers
         % See also CpxInfo.
      end%end of function
      function val = get.NfractionalCuts(obj)
         % Get NfractionalCuts
         % See also CpxInfo.
      end%end of function
      function val = get.NdisjunctiveCuts(obj)
         % Get NdisjunctiveCuts
         % See also CpxInfo.
      end%end of function
      function val = get.NMIRs(obj)
         % Get NMIRs
         % See also CpxInfo.
      end%end of function
      function val = get.NimpliedBounds(obj)
         % Get NimpliedBounds
         % See also CpxInfo.
      end%end of function
      function val = get.NzeroHalfCuts(obj)
         % Get NzeroHalfCuts
         % See also CpxInfo.
      end%end of function
      function val = get.NMCFCuts(obj)
         % Get NMCFCuts
         % See also CpxInfo.
      end%end of function
   end%end of methods
      function info = CpxInfo(cplex)
         % Constructor
         % See also CpxInfo.
      end%end of function
      function ret = open(obj)
         % Open callback
         % See also CpxInfo.
      end%end of function
      function ret = close(obj)
         % Close callback
         % See also CpxInfo.
      end%end of function
      function stop = callback(obj, nn, ni, co, bo, io, mp, cuts)
         % Call callback
         % See also CpxInfo.
      end%end of function
   end%end of methods
end%end of class
