clear all;close all; clc;
% 第一组数据
mul=[0,0]; % 均值
S1=[.1 0;0 .1]; % 协方差
data1=mvnrnd(mul, S1, 100); % 产生高斯分布数据
% 第二组数据
mu2=[1.25 1.25];
S2=[.1 0;0 .1];
data2=mvnrnd(mu2,S2,100);
% 第三组数据
mu3=[-1.25;1.25]
S3=[.1 0;0 .1]
data3=mvnrnd(mu3,S3,100)
% 显示数据
plot(data1(:,1),data1(:, 2),'b+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
plot(data3(:,1),data3(:,2),'g+');
grid on; % 在画图的时候添加网格
% 三类数据合成一个不带标号的数据类
data=[data1;data2;data3];
N=3; % 设置聚类数目k的值
[m,n]=size(data); % 300x2矩阵
pattern=zeros(m,n+1);
center=zeros(N,n); % 初始化聚类中心 3x2
pattern(:,1:n)=data(:,:);
for x=1:N
	center(x,:)=data(randi(300,1),:); % 第一次随机产生聚类中心
end
while 1
	distance=zeros(1,N);
	num=zeros(1,N);
	new_center=zeros(N,n);
	for x=1:m
		for y=1:N 
			% 这里使用的是欧氏距离
			distance(y)=norm(data(x,:)-center(y,:)); % 计算每个样本到每个类中心的距离 
		end
		% min函数有三种调用形式 
		% min(A): 返回一个行向量，是每列最小值
		% [Y, U]=min(A): 返回行向量Y和U, Y向量记录A的每列的最小值，U向量记录每列最小值的行号
		% min(A, dim): dim取1或2.dim取1时，该函数与max(A)完全相同;dim为2时，返回列向量，其第
		% i个元素是A矩阵的第i行上的最小值
		[~,temp]=min(distance);
		pattern(x,n+1)=temp;
	end
	k=0;
	for y=1:N
		% 遍历所有样本，找到属于第y类的样本,并重新计算簇中心
		for x=1:m
			if pattern(x,n+1)==y
				new_center(y,:)=new_center(y,:)+pattern(x,1:n)
				num(y)=num(y)+1 % 计算第y类的所属样本个数，便于求均值
			end
		end
		new_center(y,:)=new_center(y,:)/num(y);
		if norm(new_center(y,:)-center(y,:))<0.1
			k=k+1
		end
	end
	if k==N
		break;
	else
		center=new_center
	end
end
[m,n]=size(pattern) % m=300,n=3

% 显示聚类后的数据
figure;
hold on;
for i=1:m
	% 属于不同类别的样本画成不一样的r、b、g颜色的*状，最终的簇中心为黑色圆圈
	if pattern(i,n)==1
		plot(pattern(i,1),pattern(i,2),'r*');
		plot(center(1,1),center(1,2),'ko');
	elseif pattern(i,n)==2
		plot(pattern(i,1),pattern(i,2),'g*');
		plot(center(2,1),center(2,2),'ko');
	elseif pattern(i,n)==3
		plot(pattern(i,1),pattern(i,2),'b*');
		plot(center(3,1),center(3,2),'ko');
	end
end 
grid on;

