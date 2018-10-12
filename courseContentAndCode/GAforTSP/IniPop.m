function Chrom=IniPop(Pop,L)
Chrom=zeros(Pop,L);
for i=1:Pop
    Chrom(i,:)=randperm(L);
end
    
