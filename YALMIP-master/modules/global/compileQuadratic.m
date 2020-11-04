function [Q,c] = compileQuadratic(c,p);
Q = spalloc(length(c),length(c),0);
%c = p.c;
for i = 1:size(p.bilinears,1)
    if c(p.bilinears(i,1))
        Q(p.bilinears(i,2),p.bilinears(i,3)) = c(p.bilinears(i,1))/2;
        Q(p.bilinears(i,3),p.bilinears(i,2)) = Q(p.bilinears(i,3),p.bilinears(i,2))+c(p.bilinears(i,1))/2;
        c(p.bilinears(i,1)) = 0;
    end
end