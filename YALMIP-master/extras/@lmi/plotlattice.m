function varargout = plotlattice(varargin)
%PLOTLATTICE  Plots an integer lattice
%
% p = plotlattice(C,which,c,size,options)
%
% Note that only convex sets C in R^2 are supported.
%
% C    :  Constraint object
% which:  'inner' or 'outer'
% color:  color [double] ([r g b] format) or char from 'rymcgbk'
% size :  Size of marker
% options: options structure from sdpsettings
% Example
% sdpvar x1 x2
% plot(x1^2+x2^2 <= 1.5,'green');hold on
% plotlattice(x1^2+x2^2 <= 1.5,'outer','yellow');
% plotlattice(x1^2+x2^2 <= 1.5,'inner','black');

F = varargin{1};
if nargin > 1
    which = varargin{2};
else
    which = 'outer';
end
if nargin > 2
    color = varargin{3};
else
    color = 'yellow';
end
if nargin > 3
    size = varargin{4};
else
    size = 5;
end
if nargin > 4    
    ops = varargin{5};
    if ~isempty(ops)
        ops = sdpsettings(ops,'relax',2,'verbose',0);
    else
        ops = sdpsettings('relax',2,'verbose',0);    
    end
else
    ops = sdpsettings('relax',2,'verbose',0);
end

X = recover(depends(F));
[~,L,U] = boundingbox(F,ops);

x = floor(L(1)):ceil(U(1));
y = floor(L(2)):ceil(U(2));
ThreeD = length(L)>2;
if ThreeD
    z = floor(L(3)):ceil(U(3));
else
    z = 1;
end

for i = x
    for j = y
        for k = z
        switch which
            case 'outer'
                if ThreeD
                    l = plot3(i,j,k,'or','MarkerSize',size);
                else
                    l = plot(i,j,'or','MarkerSize',size);
                end
                set(l,'MarkerFaceColor',color);
            case 'inner'
                if ThreeD
                    assign(X,[i;j;k]);
                else
                    assign(X,[i;j]);
                end
                p = checkset(F);
                if min(p) >= 0
                    if ThreeD
                        l = plot3(i,j,k,'or','MarkerSize',size,'MarkerFaceColor','yellow');
                    else
                        l = plot(i,j,'or','MarkerSize',size,'MarkerFaceColor','yellow');
                    end
                    set(l,'MarkerFaceColor',color);
                end
            otherwise
                error
        end
        end
    end
end