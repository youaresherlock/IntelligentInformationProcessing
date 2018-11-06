close all
clear all
clc
I=imread('lenna256.bmp');
I=im2double(I);
J=zeros(size(I));
N=10;
[m,n]=size(I);
center=zeros(1,N);
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
    distence=zeros(1,N);
    for i=1:m
        for j=1:n
            for x=1:N
                distence(x)=abs(I(i,j)-center(1,x));
            end
            [~,temp]=min(distence);
            label(i,j)=temp;
        end
    end
    for i=1:m
        for j=1:n
            for x=1:N
                if(label(i,j)==x)
                    s(1,x)=s(1,x)+I(i,j);
                    num(1,x)=num(1,x)+1;
                end
            end
        end
    end
    for x=1:N
        newcenter(1,x)=s(1,x)/num(1,x);
    end
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
                    J(i,j)=center(x)*255;
                end
            end
        end
    end
figure,
subplot(121),imshow(I);
subplot(122),imshow(uint8(J));
                    
    
        
    
                    
                
            

                
    
                
                
            
            
       