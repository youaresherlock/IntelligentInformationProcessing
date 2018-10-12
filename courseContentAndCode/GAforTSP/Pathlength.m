function len=Pathlength(D,Chrom);
[row,col]=size(D);
Nind=size(Chrom,1);
len=zeros(Nind,1);
for i=1:Nind
    p=[Chrom(i,:) Chrom(i,1)];
    i1=p(1:end-1);
    i2=p(2:end);
    len(i,1)=sum(D((i1-1)*col+i2));
end
