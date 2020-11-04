%系数矩阵A
function Jacobidiedai(A)
[n,n]=size(A);
L=zeros(n,n);%下三角
D=zeros(n,n);%对角线
U=zeros(n,n);%上三角
for i=1:n
    for j=1:n
        if j<i
            L(i,j)=A(i,j);
        elseif i==j
            D(i,j)=A(i,j);
        else
            U(i,j)=A(i,j);
        end
    end
end
G=-inv(D)*(L+U);
r=eig(G);
m=size(r,1);
for k=1:m
    if abs(r(k))>1|abs(r(k))==1
        printf('不收敛');
    else
        printf('收敛');
    end
end
    

    
