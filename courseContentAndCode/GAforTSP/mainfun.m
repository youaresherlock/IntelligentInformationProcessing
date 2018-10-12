clear
close all
clc
X=[16.47,96.10;16.47,94.44;20.09,92.54;22.39,93.37;25.23,97.24;22,96.05;20.47,97.02;17.20,96.29;16.3,97.38;14.05,98.12;16.53,97.38;21.52,95.59;19.41,97.13;20.09,92.55];
Pop=100;
Maxgen=100;
Pc=0.9;
Pm=0.05;
Ps=0.9;
D=Distance(X);
N=size(D,1);
Chrom=IniPop(Pop,N);
DrawPath(Chrom(1,:),X);
disp('初始种群一个随机解')
Outputpath(Chrom(1,:));
Rlength=Pathlength(D,Chrom(1,:))

gen=0;
Objv=Pathlength(D,Chrom);
preObjv=min(Objv);
while gen<Maxgen
    Objv=Pathlength(D,Chrom);
    preObjv=min(Objv);
    Fitv=Fitness(Objv);
%     line([gen-1,gen],[preObjv,min(Objv)]);
    Selch=Select(Chrom,Fitv,Ps);
    Selch=Recombin(Selch,Pc) ;
    Selch=Mutate(Selch,Pm);
    Selch=Reverse(Selch,D);
    Chrom=Reins(Chrom,Selch,Objv);
    gen=gen+1;
    f(gen)=preObjv;
end
Objv=Pathlength(D,Chrom);
[minObjv,minIx]=min(Objv);
DrawPath(Chrom(minIx(1),:),X);
disp('最优解');
Outputpath(Chrom(minIx(1),:));
Rlength=Pathlength(D,Chrom(minIx(1),:))
figure;
plot(f)

    
    
    
    
    
    
