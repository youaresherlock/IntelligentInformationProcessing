clear
clc
%*********初始化
M=20;  %种群规模
x1=rand(M,1); % 初始化粒子位置
x2=rand(M,1);
%x3=rand(M,1);
%X=[x1,x2,x3]
X=[x1,x2];
c1=2; % c1和c2是学习因子
c2=2;
wmax=0.9; % 最大最小惯性权重
wmin=0.4; % 线性减小惯性权重
Tmax=50; % 迭代次数
%v=zeros(M,3);
v=zeros(M,2); % 初始化速度
% v1m=0.1;  % 速度1约束
% v2m=1;% 速度2约束
%******* 全局最优粒子位置初始化
fmin=1000; 
for i=1:M
    fx = f(X(i,:));
    if fx<fmin
        fmin=fx;
        gb=X(i,:);
    end
end
%********粒子个体历史最优位置初始化
pb=X; 
%********算法迭代
for t=1:Tmax
    t % w是每代对应的惯性权重，正在逐渐减小
    w=wmax-(wmax-wmin)*t/Tmax;  % 线性下降惯性权重
    for i=1:M
       %******更新每个粒子的当前速度
       v(i,:)=w*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));
       %******速度约束
%        if v(i,1)>v1m; v(i,1)=v1m;end
%        if v(i,2)>v2m; v(i,2)=v2m; end  
%        if v(i,1)<-v1m;v(i,1)=-v1m;end
%        if v(i,2)<-v2m;v(i,2)=-v1m;end
       %*******更新每个粒子的当前位置
       X(i,:)=X(i,:)+v(i,:);
    end
    % 更新所有粒子的速度和位置之后更新pbest和gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        if f(X(i,:))<f(gb)
            gb=X(i,:);
        end
    end
    % 保存最佳适应度
    re(t)=f(gb);
end
figure(1)
plot(re)
xlabel('迭代次数')
ylabel('适应度函数')
gb
re(end)
figure(2)
% X=[1,3,4,5,6,7,8,9,10]; 
% Y=[10,5,4,2,1,1,2,3,4];
% Y1=gb(1)*X.^2+gb(2)*X+gb(3);
X=1:15;
Y=[352  211 197 160 142 106 104 60  56  38  36  32  21  19  15];
Y1=gb(1)*exp(gb(2).*X);

t=16;
y16=gb(1)*exp(gb(2).*t)
plot(X,Y,'o',X,Y1,':');
hold on
plot(t,y16,'ro')

% gb = [400.2029 -0.2241] 最好适应度61.2758 
