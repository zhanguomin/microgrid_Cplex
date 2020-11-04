function varargout=sort(varargin)
%SORT (overloaded)
%
% [t,loc] = sort(x)
%
% The variable t will be the sorted version of x.
%
% SORT is implemented in the nonlinear operator framework using a big-M
% model.

switch class(varargin{1})

    case 'double'
        error('Overloaded SDPVAR/SORT CALLED WITH DOUBLE. Report error')

    case 'sdpvar' % Overloaded operator for SDPVAR objects. Pass on args and save them.
        
        if min(size(varargin{1})) > 1
            [y,loc] = matrix_sdpvar_sort(varargin{:});
            varargout{1} = y;
            varargout{2} = loc;
            return
        end

        x = varargin{1};
        if nargin > 1 
            % trivial case
            dim = varargin{2};
            if size(x,2) == 1 && dim == 2
                varargout{1} = x;
                varargout{2} = ones(length(x),1);
                return
            elseif size(x,1) == 1 && dim == 1
                varargout{1} = x;
                varargout{2} = ones(1,length(x));
                return
            end
        end
      
        data.D = binvar(length(x),length(x),'full');
        data.V = sdpvar(length(x),length(x),'full');
        y = [];

        for i = 1:length(x)
            data.i = i;
            data.isthisloc = 0;
            y = [y;yalmip('define',mfilename,x,data)];%i,P,V)];
        end
        loc = [];
        for i = 1:length(x)
            data.i = i;
            data.isthisloc = 1;
            loc = [loc;yalmip('define',mfilename,x,data)];
        end
        [n,m] = size(x);
        varargout{1} = reshape(y,n,m);
        varargout{2} = reshape(loc,n,m);

    case 'char' % YALMIP send 'graph' when it wants the epigraph or hypograph

        t = varargin{2};
        X = varargin{3};
        data = varargin{4};

        % Call external to allow subsrefs in classs        
        [F,vars] = sort_internal(t,X,data);

        varargout{1} = F;
        varargout{2} = struct('convexity','none','monotonicity','none','definiteness','none','model','integer');
        varargout{3} = X;

        % Inofficial way to model several nonlinear variables in
        % one call
        varargout{2}.models = vars;
    otherwise
        error('Strange type on first argument in SDPVAR/SORT');
end
