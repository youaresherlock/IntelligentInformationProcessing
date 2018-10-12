function Chrom=Reins(Chrom,Selch,Objv);
N=size(Chrom,1);
NN=size(Selch,1);
[T,In]=sort(Objv);
Chrom=[Chrom(In(1:N-NN),:);Selch];