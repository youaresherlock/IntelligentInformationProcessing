clear all
tic
%     N: 初始种群数量
%     pc: 交叉概率
%     pm: 变异概率
%     per: 要求精度10^4 * (b-a)
N=10;pc=0.95;pm=0.1; 
per=4;
a=-2;b=1; % x范围在[-2, 1]
L=ceil(log2((b-a)*10^per)); % L为编码长度 

%     四种取整函数用法:
%     fix(x): 截尾取整
%     floor(x): 向下取整
%     ceil(x): 向上取整
%     round(x): 四舍五入取整
s=round(rand(N,L)); % N行L列矩阵，表示N个个体
maxf=0;

% 由于y在循环中是动态扩容数组，解释器提示会影响性能，因此提前分配
y = zeros(1, N);
s2 = s;
max_f = y;
mean_f = y;

% 遍历种群找适应度最大个体对应的maxf和适应度向量y
for i=1:N
    
    % num2str()函数将第i行所有列拼接成字符串
    % x为第i个个体binary string转换成的整数
    x=a+bin2dec(num2str(s(i,:)))*(b-a)/(2^L-1);
    y(i)=f1(x); % 计算适应度 y向量表示每个个体适应度
    if y(i)>maxf
        maxf=y(i);
        opmx=x; % f(x)取最大适应度的x值
    end
end

T=1000; % T迭代次数.
for t=1:T
    %select 选择
    % 选择方法: 赌轮选择法
    p=y/sum(y); % p向量表示每个染色体选择的概率
    q=cumsum(p); % q向量表示每个染色体的累积概率
    % for循环从新生成N个个体
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp); % Ind(1)为q向量中累计概率第一个大于temp的染色体
        s2(i,:)=s(Ind(1),:);
    end

    % 选择方法: 随机普遍采样法
%     p = y/sum(y);
%     q=cumsum(p);
%     temp=rand(1)/N;
%     i=1;
%     j=1;
%     for i=1:N
%         while(temp<q(i))
%             s2(j,:)=s(i,:);
%             j=j+1;
%             temp=temp+1/N;
%         end
%     end
    
  % crossover 交叉
    % 单点交叉
    for i=1:N
        if rand(1)<pc
            I=1+fix((N-1)*rand(1)); 
            J=1+fix((N-1)*rand(1));
            if I~=J
                k=round((L-1)*rand(1)); % k范围[0, L-1]
                temp1=s2(I,k+1:end);
                temp2=s2(J,k+1:end);
                s2(I,k+1:end)= temp2;
                s2(J,k+1:end)= temp1;
            end
        end
    end

    % 两点交叉
%     for i=1:N
%         if rand(1)<pc
%             I=1+fix((N-1)*rand(1)); 
%             J=1+fix((N-1)*rand(1));
%             if I~=J
%                 k=round((L-1)*rand(1)); % k范围[0,L-1]
%                 l=round((L-1)*rand(1)); % L范围[0,L-1]
%                 if k<=L
%                     temp1=s2(I,k+1:l+1);
%                     temp2=s2(J,k+1:l+1);
%                     s2(I,k+1:l+1)= temp2;
%                     s2(J,k+1:l+1)= temp1;
%                 else
%                     temp1=s2(I,l+1:k+1);
%                     temp2=s2(J,l+1:k+1);
%                     s2(I,l+1:k+1)= temp2;
%                     s2(J,l+1:k+1)= temp1;
%                 end
%             end
%         end
%     end
    
    % 均匀交叉
%     px = 0.5; % 均匀交叉位交换概率
%     for i=1:N
%         if rand(1)<pc
%             I=1+fix((N-1)*rand(1)); 
%             J=1+fix((N-1)*rand(1));
%             if I~=J
%                 for j=1:L
%                     if rand(1)<=px
%                         temp1=s2(I,j);
%                         temp2=s2(J,j);
%                         s2(I,j)= temp2;
%                         s2(J,j)= temp1;
%                     end
%                 end
%             end
%         end
%     end
    
    %mututation 变异
    for i=1:N
        if rand(1)<pm
            I=1+fix((N-1)*rand(1));
            k=1+fix((L-1)*rand(1));
            s2(I,k)=1-s2(I,k); % 单点变异位置k取反
        end
    end

    s=s2;
    % 计算每个个体适应度值,记录最大maxf适应度以及对应x的值
    for i=1:N
        x=a+bin2dec(num2str(s(i,:)))*(b-a)/(2^L-1);
        y(i)=f1(x);
        if y(i)>maxf
            maxf=y(i);
            opmx=x;
        end
    end

    max_f(t)=maxf; % max_f最终是100列的向量，记录每次迭代最大适应度
    mean_f(t)=mean(y); % 种群平均适应度
end
plot(1:T,max_f,'r',1:T,mean_f,'g');
hold on;
legend("pc=" + num2str(pc), "pm=" + num2str(pm));
xlabel('种群代数');
ylabel('适应度');
title("GA一元函数实验: " + "种群数量: " + num2str(N) +   " 代数:" + num2str(T) + " 时间:" + num2str(toc) + " seconds");
maxf
opmx