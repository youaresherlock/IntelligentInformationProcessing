clear all
tic
%     N: 初始种群数量
%     pc: 交叉概率
%     pm: 变异概率
%     per: 要求精度10^4 * (b-a)
N=10;pc=0.95;pm=0.1;
per=4;

% x1∈[-3, 12.1] 编码长度L1
a1=-3;b1=12.1;
L1=ceil(log2((b1-a1)*10^per));
a2=4.1;b2=5.8;
% x2∈[4.1, 5.8] 编码长度L2
L2=ceil(log2((b2-a2)*10^per));
% L为二进制串基因总编码长度
L=L1+L2;
s=round(rand(N,L)); % 初始种群

maxf=0;
% 由于y在循环中是动态扩容数组，解释器提示会影响性能，因此提前分配
y = zeros(1, N);
s2 = s;
max_f = y;
mean_f = y;

for i=1:N
    x1=a1+bin2dec(num2str(s(i,1:L1)))*(b1-a1)/(2^L1-1);
    x2=a2+bin2dec(num2str(s(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1);
    y(i)=f2(x1,x2);
    if y(i)>maxf
        maxf=y(i);
        opmx=[x1,x2]; % f(x1, x2)取最大适应度x1,x2组成的行向量
    end
end

T=1000; % 种群代数(iteration count constants)
for t=1:T
    %select 选择

    p=y/sum(y);
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);
        s2(i,:)=s(Ind(1),:);
    end

    %crossover 交叉
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
    %mututation 变异
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
       y(i)=f2(x1,x2);
       if y(i)>maxf
            maxf=y(i);
            opmx=[x1,x2];
        end
    end
    max_f(t)=maxf;
    mean_f(t)=mean(y);
end
plot(1:T,max_f,'b',1:T,mean_f,'g')
hold on;
legend("pc=" + num2str(pc), "pm=" + num2str(pm));
xlabel('种群代数');
ylabel('适应度');
title("GA二元函数实验: " + "种群数量: " + num2str(N) +   " 代数:" + num2str(T) + " 时间:" + num2str(toc) + " seconds");
maxf
opmx
