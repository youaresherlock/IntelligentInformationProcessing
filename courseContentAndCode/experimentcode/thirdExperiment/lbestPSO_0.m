clear
clc
%*********初始化
M=20;  % 种群规模
x1=rand(M,1); % 初始化例子位置
x2=rand(M,1);
%x3=rand(M,1);
%X=[x1,x2,x3]
X=[x1,x2];
c1=2;  % 学习因子
c2=2;
wmax=0.9; % 最大最小惯性权重
wmin=0.4;
Tmax=50; % 迭代次数
v=zeros(M,2); % 初始化速度
%*******全局最优粒子位置初始化
fmin=1000;
gb=X;
k=2; % 邻域规模
for i=1:M
    for in=i-k:i+k
        if in<1;
            in=in+M;%越界处理
        elseif in>M
            in=in-M;%越界处理
        else
            in=in;
        end
        if f(X(in,:))<f(gb(i,:))
            gb(i,:)=X(in,:);%个体的邻域最优
        end
    end
end
%********粒子个体历史最优位置初始化
pb=X; 
%********算法迭代
for t=1:Tmax
    t
    w=wmax-(wmax-wmin)*t/Tmax;  %线性下降惯性权重
    for i=1:M
       %******更新粒子速度 终于是局部最优
       v(i,:)=w*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb(i,:)-X(i,:));
       %*******更新粒子位置
       X(i,:)=X(i,:)+v(i,:);
    end
    %更新pbest和gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        for in=i-k:i+k
            if in<1;
                in=in+M;
            elseif in>M
                in=in-M;
            else
                in=in;
            end
            if f(X(in,:))<f(gb(i,:))
                gb(i,:)=X(in,:);%更新邻域最优
            end
        end
    end
    %保存最佳适应度
    ffmin=1000;
    for i=1:M
        if f(gb(i,:))<ffmin;
            ffmin=f(gb(i,:))
            re(t)=ffmin;
            ggb=gb(i,:);
        end
    end
end
figure(1)
plot(re)
xlabel('迭代次数')
ylabel('适应度函数')
ggb
figure(2)
%X=[1,3,4,5,6,7,8,9,10]; 
%Y=[10,5,4,2,1,1,2,3,4];
%Y1=gb(1)*X.^2+gb(2)*X+gb(3);
X=1:15;
Y=[352 211  197 160 142 106 104 60  56  38  36  32  21  19  15];
Y1=ggb(1)*exp(ggb(2).*X);
t=16;
y16=ggb(1)*exp(ggb(2).*t)
plot(X,Y,'o',X,Y1,':');
hold on
plot(t,y16,'ro')
hold off
 
% 最好适应度61.2860 指数函数参数a,b分别是400.0875 -0.2234 
% 二次函数参数拟合问题 a = -0.0963 b = 0.7585 c = 3.2129 最小适应度函数为8.5722