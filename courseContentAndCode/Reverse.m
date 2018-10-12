function Selch=Reverse(Selch,D);
[row,col]=size(Selch);
Objv=Pathlength(D,Selch);
Selch1=Selch;
for i=1:row
    r1=randsrc(1,1,[1:col]);
    r2=randsrc(1,1,[1:col]);
    mininverse=min(r1,r2);
    maxinverse=max(r1,r2);
    Selch1(i,mininverse:maxinverse)=Selch1(i,maxinverse:-1:mininverse);
end
Objv1=Pathlength(D,Selch1);
Index=Objv1<Objv;
Selch(Index,:)=Selch1(Index,:);