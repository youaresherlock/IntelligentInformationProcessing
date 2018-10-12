clear all
N=10;pc=0.95;pm=0.1;
per=4;

a1=-3;b1=12.1;
L1=ceil(log2((b1-a1)*10^per));
a2=4.1;b2=5.8;
L2=ceil(log2((b2-a2)*10^per));
L=L1+L2;
s=round(rand(N,L));

maxf=0;
for i=1:N
    x1=a1+bin2dec(num2str(s(i,1:L1)))*(b1-a1)/(2^L1-1);
    x2=a2+bin2dec(num2str(s(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1);
    y(i)=f1(x1,x2);
    if y(i)>maxf
        maxf=y(i);
        opmx=[x1,x2];
    end
end
T=1000;
for t=1:T
    %select
    p=y/sum(y);
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);
        s2(i,:)=s(Ind(1),:);
    end
    %crossover
    for i=1:N
        if rand(1)<pc
            I=1+fix((N-1)*rand(1));
            J=1+fix((N-1)*rand(1));
            if I~=J
                k=round((L-1)*rand(1));
                temp1=s2(I,k+1:end);
                temp2=s2(J,k+1:end);
                s2(I,k+1:end)= temp2;
                s2(J,k+1:end)= temp1;
            end
        end
    end
    %mututation
    for i=1:N
        if rand(1)<pm
            I=1+fix((N-1)*rand(1));
            k=1+fix((L-1)*rand(1));
            s2(I,k)=1-s2(I,k);
        end
    end
    s=s2;
    for i=1:N
       x1=a1+bin2dec(num2str(s(i,1:L1)))*(b1-a1)/(2^L1-1);
       x2=a2+bin2dec(num2str(s(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1);
       y(i)=f1(x1,x2);
       if y(i)>maxf
            maxf=y(i);
            opmx=[x1,x2];
        end
    end
    max_f(t)=maxf;
    mean_f(t)=mean(y);
end
plot(1:T,max_f,'b',1:T,mean_f,'g')
maxf
opmx