close all
clear all
clc
I=imread('lenna256.bmp'); % 从指定的文件名(这里是相对目录，即当前程序所在目录)读取图像
I=im2double(I); % 把灰度图像的数据类型转换成双精度浮点数类型
J=zeros(size(I)); % 256*256 8位的灰度图
N=4; % 聚类成N类
[m,n]=size(I); % m=256,n=256
center=zeros(1,N);
% 下面初始化簇中心，有N个簇中心
for i=1:N
	mrand1=randi(m);
	nrand1=randi(n);
	center(1,i)=I(mrand1,nrand1);
end
label=zeros(m,n);
s=zeros(1,N);
num=zeros(1,N);
newcenter=zeros(1,N);
th=0.01;
while 1
    distance=zeros(1,N);
    for i=1:m
        for j=1:n
            for x=1:N
                distance(x)=abs(I(i,j)-center(1,x));% 一维距离，直接相差取绝对值
            end
            [~,temp]=min(distance);
            label(i,j)=temp; % 第i行j列的样本属于temp类别
        end
    end
    for i=1:m
        for j=1:n
        	% 求第i,j个样本到N个簇中心的平均距离
            for x=1:N
                if(label(i,j)==x)
                    s(1,x)=s(1,x)+I(i,j);
                    num(1,x)=num(1,x)+1; % 计算每个类别的样本数量
                end
            end
        end
    end
    % 计算新的N个簇的中心
    for x=1:N
        newcenter(1,x)=s(1,x)/num(1,x);
    end
    % 当簇中心变化很小时收敛
    if(abs(min(newcenter)-min(center))<th)
        break;
    else
        center=newcenter;
    end
end
for i=1:m
        for j=1:n
            for x=1:N
                if(label(i,j)==x)
                    J(i,j)=center(x)*255; % 将样本划分到所属类别中
                end
            end
        end
    end
figure,
subplot(1,2,1),imshow(I); % 将图像窗口分成1行2列，并在第一个子窗口显示图像img
subplot(1,2,2),imshow(uint8(J)); % 同上，只不过换成在第二个子窗口显示img
% 注意:
% subplot(1,2,2),imshow(J); 会得到白色图像
% 可以使用subplot(1,2,2),imshow(J/255);
%
                    
        
    
                    
                
            

                
    
                
                
            
            
       