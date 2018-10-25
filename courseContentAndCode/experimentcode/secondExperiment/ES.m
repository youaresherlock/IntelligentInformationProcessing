clear
clc
N=10; % 初始种群规模
x1=15.1*rand(1,N)-3; 
x2=1.7*rand(1,N)+4.1;
X=[x1;x2]; % 生成初始种群矩阵，一列表示一个可行解
sigma=rand(2,N);
T=50; % 迭代次数
maxf=0; % 记录最大适应度
for t=1:T
       lamda=1;
       while lamda<=7*N
           pos=1+fix(rand(1,2)*(N-1)); % [1,9]范围的二元行向量 此处范围错误，应为[1, 10]
        % pa1、pa2分别是X中的一个随机解，可能相同
           pa1=X(:,pos(1));
           pa2=X(:,pos(2));
           % 随机选出x1
           if rand()<0.5
               o(1)=pa1(1); 
           else
               o(1)=pa2(1);
           end
           % 随机选出x2
           if rand()<0.5
               o(2)=pa1(2);
           else
               o(2)=pa2(2);
           end
           % 随机从sigma矩阵中选出两列，相加求平均,sigmal是一个二元列向量，范围(0,1)
           sigma1=0.5*(sigma(:,pos(1))+sigma(:,pos(2))); 
           % o是已知解x1, x2的随机组合，也是一组解[x1,x2]
           Y=o+sigma1.*randn(2,1);
           % Y这个解可能会超出范围 x1,x2
           if Y(1)>=-3 && Y(1)<=12.1 && Y(2)>=4.1 && Y(2)<=5.8
           	% 保存选择出来的个体，个体数目lamda+1
               offspring(:,lamda)=Y; % 保存选择出来的子代
               lamda=lamda+1; 
           end
       end
       U=[offspring]; %70个解组成的矩阵 这里是u,λ策略
       % μ+λ选择策略: 在原有的μ个个体和新生成的λ个体中选择
       % u,λ选择策略: 从新生成的λ个体中选择 ,建议λ/μ = 7
       % μ/λ是压力比，其越大选择压力越大。
       % u + λ策略改为U=[offspring, X]
       % size(U, 2) 为U向量的列数，也就是子代数目
       for i=1:size(U,2)
           temp = U(:,i);
           x1 = temp(1);
           x2 = temp(2);
           eva(i)=f2(x1, x2);
       end
       % m_eval是排序的适应度值，从小到大，I是对应的适应值原来的下标
       [m_eval,I]=sort(eva);
       I1=I(end-N+1:end); % end-(end-N+1)+1从7*N子代中选出最好的N个的适应度下标行向量
       X=U(:,I1); % 得到7*N中最好的N个个体
       % 比较最大适应度与maxf记录值，更新maxf,同时记录x1,x2值
       if m_eval(end)>maxf
           maxf=m_eval(end);
           opmx=U(:,end);
       end
       max_f(t)=maxf;
       mean_f(t)=mean(eva(I1)); % 计算每代平均适应度
end
plot(1:T,max_f,'b',1:T,mean_f,'g')
opmx
maxf

% result: x1 = 10.4391, x2 = 5.5460, maxf = 38.1892 