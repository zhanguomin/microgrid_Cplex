function F = binary_implies_linearnegativeconstraint(f,X,M,m,eps);
% Big-M for f<=0 iff X==1. Assumes f and X vectors of same size

if nargin < 3 || isempty(M)
    [M,m,infbound,lowerinf,upperinf] = derivebounds(f);
    if upperinf
        warning('You have unbounded variables in an implication leading to a lousy big-M relaxation.');
    end
end

if all(M == 0)
    F = [f <= 0];
elseif all(M == 1)
    F = [f <= (1-X)];
else
    F = [f <= M.*(1-X)];
end