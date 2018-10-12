function D=Distance(a);
row=size(a,1);
D=zeros(row);
for i=1:row
    for j=1:row
        D(i,j)=norm(a(i,:)-a(j,:));
        D(j,i)=D(i,j);
    end
end