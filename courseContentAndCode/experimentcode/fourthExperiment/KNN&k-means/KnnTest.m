clear all;close all;clc;
load data; % 读取数据
Data = data;
% ?100个样本进行归?化处? min-max标准化方法[0,1]区间
% 缺点是当有新的数据加入时，max和min可能发生变化，需要重新定?
for i=1:100 
	for j=1:3
		Data(i,j)=(data(i,j)-min(data(:,j)))/(max(data(:,j))-min(data(:,j)));
	end
end
D1=Data(1:80,:);
D2=Data(81:100,:);
k=20; % 训练集是80个样本，测试集是20个样?
for i=1:20
	temp=D2(i,1:3)
	for j=1:80 % 计算每个测试样本到训练样本的距离向量
		distance(j)=norm(temp-D1(j,1:3));
	end
	[distance1,index]=sort(distance); %升序排列
	In=index(1:k); % 统计周围20个训练样本的类别情况
	l1=length(find(D1(In,4)==1));
	l2=length(find(D1(In,4)==2));
	l3=length(find(D1(In,4)==3));
	[maxl,class(i)]=max([l1,l2,l3]); % class(i)是每个样本所属类别的20行向?
end
class
ratio=length(find((class'-D2(:,4))==0))/20 % 统计正确率是%90