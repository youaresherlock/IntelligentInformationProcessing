function Selch=Recombin(Selch,Pc) 
Nsel=size(Selch,1);
for i=1:2:Nsel-mod(Nsel,2);
    if Pc>=rand
        [Selch(i,:),Selch(i+1,:)]=intercross(Selch(i,:),Selch(i+1,:));
    end
end

function[a,b]=intercross(a,b)
L=length(a);
r1=randsrc(1,1,[1:L]);
r2=randsrc(1,1,[1:L]);
if r1~=r2
    a0=a;b0=b;
    s=min([r1,r2]);
    e=max([r1,r2]);
    for i=s:e
        a1=a;b1=b;
        a(i)=b0(i);
        b(i)=a0(i);
        x=find(a==a(i));
        y=find(b==b(i));
        i1=x(x~=i);
        i2=y(y~=i);
        if ~isempty(i1)
            a(i1)=a1(i);
        end
        if ~isempty(i2)
            b(i2)=b1(i);
        end
    end
end

        
    