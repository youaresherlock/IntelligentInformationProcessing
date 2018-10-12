function Selch=Mutate(Selch,Pm)
[Nsel,L]=size(Selch);
for i=1:Nsel
    if Pm>=rand
        R=randperm(L);
        Selch(i,R(1:2))=Selch(i,R(2:-1:1));
    end
end
