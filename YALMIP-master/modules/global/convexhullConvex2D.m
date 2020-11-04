function [Ax,Ay,b,K] = convexhullConvex2D(x1,f1,df1,x2,f2,df2,x3,f3,df3,x4,f4,df4,x5,f5,df5)

% Lower bounds from tangents
% z > f(x1) + (x-x1)*df(x1)
% z > f(x2) + (x-x2)*df(x2)
% z > f(x3) + (x-x3)*df(x3)
% z > f(x4) + (x-x4)*df(x4)
% z > f(x5) + (x-x5)*df(x5)

% Possible upper bound from creatin hyperplane from three points

f = [f1 f2 f3 f4];
X = [x1 x2 x3 x4];
[~,loc] = sort(f);
Z = [X;f];
[n1,d1] = ceiling(Z(:,1),Z(:,2),Z(:,3));
[n2,d2] = ceiling(Z(:,2),Z(:,3),Z(:,4));
[n3,d3] = ceiling(Z(:,3),Z(:,4),Z(:,1));
[n4,d4] = ceiling(Z(:,4),Z(:,3),Z(:,2));
b = [x1'*df1-f1;
     x2'*df2-f2;
     x3'*df3-f3;
     x4'*df4-f4;
     x5'*df5-f5];   
Ax = [df1';df2';df3';df4';df5'];
Ay = [-1;-1;-1;-1;-1];

d1 = max(n1'*Z);
d2 = max(n2'*Z);
d3 = max(n3'*Z);
d4 = max(n4'*Z);
if all(n1'*Z - d1 <= 0)
    b = [b;d1];
    Ax = [Ax;n1(1:2)'];
    Ay = [Ay;n1(3)];
end
if all(n2'*Z - d2 <= 0)
    b = [b;d2];
    Ax = [Ax;n2(1:2)'];
    Ay = [Ay;n2(3)];
end
if all(n3'*Z - d3 <= 0)
    b = [b;d3];
    Ax = [Ax;n3(1:2)'];
    Ay = [Ay;n3(3)];
end
if all(n4'*Z - d4 <= 0)
    b = [b;d4];
    Ax = [Ax;n4(1:2)'];
    Ay = [Ay;n4(3)];
end

if 0
    sdpvar x(2,1) z
    box=[min([x1 x2 x3 x4],[],2) <= x <= max([x1 x2 x3 x4],[],2),-50 <=z <= max([f1 f2 f3 f4])]
    P = [n3'*[x;z] <= d3,
        z >= f1 + (x-x1)'*df1,
        z >= f2 + (x-x2)'*df2,
        z >= f3 + (x-x3)'*df3,
        z >= f4 + (x-x4)'*df4,
        z >= f5 + (x-x5)'*df5,
        box]
    plot([Ax*x + Ay*z <= b])
    plot(P,[x;z],[],1000)
end

function [n,d] = ceiling(p1,p2,p3);
n = cross(p1 - p2, p1 - p3);
n = n/sign(n(3));
d = p1'*n;