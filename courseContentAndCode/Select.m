 function Selch=Select(Chrom,Fitv,Ps)
Pop=size(Chrom,1);
N_select=max(floor(Pop*Ps+0.5),2); %选择的个体数
%交叉
[Nind,ansd]=size(Fitv);
cumfit=cumsum(Fitv);
trials=cumfit(Nind)/N_select*(rand+(0:N_select-1)');
Mf=cumfit(:,ones(1,N_select));
Mt=trials(:,ones(1,Nind))';
[NewIx,anss]=find(Mt<Mf & [zeros(1,N_select);Mf(1:Nind-1,:)]<Mt);
[anss,shuf]=sort(rand(N_select,1));
NewIx=NewIx(shuf);
Selch=Chrom(NewIx,:);

