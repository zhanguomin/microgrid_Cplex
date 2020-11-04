function varargout = pexp(varargin)
%PEXP
%
% y = PEXP(x)
%
% Computes perspective exp, x(1)*exp(x(2)/x(1)) on x>0
%
% Implemented as evalutation based nonlinear operator. Hence, the convexity
% of this function is exploited to perform convexity analysis and rigorous
% modelling.

switch class(varargin{1})
    
    case 'double'
        
        if nargin == 2
            varargin{1} = [varargin{1};varargin{2}];
        end
        if nargin == 1 && ~isequal(prod(size(varargin{1})),2)
            error('PEXP only defined for 2x1 arguments');
        end
        x = varargin{1};
        
        varargout{1} = x(1)*exp(x(2)/x(1));


    case 'sdpvar'

        if nargin == 2
            varargin{1} = [varargin{1};varargin{2}];
        end               
        if ~isequal(prod(size(varargin{1})),2)
            error('PEXP only defined for 2x1 arguments');
        else
            varargout{1} = yalmip('define',mfilename,varargin{1});
        end

    case 'char'

        X = varargin{3};

        operator = struct('convexity','convex','monotonicity','none','definiteness','positive','model','callback');
        operator.range = [0 inf];
        operator.domain = [0 inf];    
        operator.derivative = @derivative;
        operator.convexhull = @convexhull;
        operator.bounds = @bounds;
        
        varargout{1} = [];
        varargout{2} = operator;
        varargout{3} = X;

    otherwise
        error('SDPVAR/PEXP called with CHAR argument?');
end

function [L,U] = bounds(xL,xU)
x1 = [xL(1);xL(2)];
x2 = [xU(1);xL(2)];
x3 = [xL(1);xU(2)];
x4 = [xU(1);xU(2)];
L = -inf;
U = max([pexp(x1) pexp(x2) pexp(x3) pexp(x4)]);

function dp = derivative(x)
z = x(2)/x(1);
dp = [exp(z)-z*exp(z);exp(z)];

function [Ax,Ay,b] = convexhull(xL,xU)
x1 = [xL(1);xL(2)];
x2 = [xU(1);xL(2)];
x3 = [xL(1);xU(2)];
x4 = [xU(1);xU(2)];
x5 = (xL+xU)/2;
f1 = pexp(x1);
f2 = pexp(x2);
f3 = pexp(x3);
f4 = pexp(x4);
f5 = pexp(x5);
df1 = derivative(x1);
df2 = derivative(x2);
df3 = derivative(x3);
df4 = derivative(x4);
df5 = derivative(x5);
[Ax,Ay,b] = convexhullConvex2D(x1,f1,df1,x2,f2,df2,x3,f3,df3,x4,f4,df4,x5,f5,df5);