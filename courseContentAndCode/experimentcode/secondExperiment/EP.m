clear
clc
N=20; % 初始种群数量
x1=15.1*rand(1,N)-3;
x2=1.7*rand(1,N)+4.1;
X=[x1;x2];
sigma=[3;3]; 
gen=1; % 代数
maxf=0; % 记录种群中最大适应度
while gen<100
       i=0;
       while i<N
           if sigma(1)<0
              sigma(1)=0.001;
           else
              sigma(1)=sigma(1)+sqrt(sigma(1))*randn(1);
           end
           if sigma(2)<0
              sigma(2)=0.001;
           else
              sigma(2)=sigma(2)+sqrt(sigma(2))*randn(1);
           end
              X0=X(:,i+1)+sigma*randn(1); %对每个个体周围进行探索
              % 判断是否探索越界
              if  X0(1)>=-3 && X0(1)<=12.1 && X0(2)>=4.1 && X0(2)<=5.8
              	Y(:,i+1)=X0; % Y保存下一代
              	i=i+1;
              end
       end
       Temp=[X,Y]; % 父母代和子代2N数量
       W=zeros(1,2*N);
       % p是随机选择的，优良个体进入下一代的机会会大些，但是也有较差的个体会进入，建议p=0.9μ
       % 随机型p竞争法 
       % (1) 从μ个父代和μ个子代中，依此选出一个个体i
       % (2) 从2μ个个体中，随机选择p个个体
       % (3) 比较个体i与p个个体适应度的优劣，记录个体i的适应度优于或者等于p个体的次数
       %     作为i的得分Wi
       % (4) 依次评价完2μ个个体
       % (5) 对W进行排序，选出前μ个个体作为下一代
       for j=1:2*N
           p=0;
           while p<N/2
           	% 随机从种群中选出一个个体比较适应度
               k=1+fix((2*N-1)*rand()); % k属于2*N-1
               if k~=j
                   p=p+1;
                   if f1(Temp(:,j))>f1(Temp(:,k))
                       W(j)=W(j)+1; % 如果大于就累加1
                   end
               end
           end
       end
       [W1,In]=sort(W); % 将适应度累加值从小到大排序
       I1=In(N+1:2*N); % 选出最大适应度累加值的个体索引
       X=Temp(:,I1); % 选出来的N个比较好的个体
       gen=gen+1; % 迭代次数+1
       maxW=f1(X)
       % 更新maxf,及最优解
       if  maxW>maxf
           maxf=maxW;
           opmx=Temp(:,In(end)); % 选出此代适应度最优解
       end
       mean_f(gen)=mean(W(I1)); % 此代平均适应度累加值
       fit(gen)=maxf;
end
opmx
maxf
plot(1:gen,fit,1:gen,mean_f)

% result: x1 = 11.6253, x2 = 5.7250, maxf = 38.8485