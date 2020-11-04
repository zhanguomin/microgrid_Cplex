%ϵ������A
function Jacobidiedai(A)
[n,n]=size(A);
L=zeros(n,n);%������
D=zeros(n,n);%�Խ���
U=zeros(n,n);%������
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
        printf('������');
    else
        printf('����');
    end
end
    

    
