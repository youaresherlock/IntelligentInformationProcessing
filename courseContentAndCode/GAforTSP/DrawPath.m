 function Drawpath(Chrom,X);
R=[Chrom(1,:),Chrom(1,1)];
figure
hold on
plot(X(:,1),X(:,2),'o','color',[0.5,0.5,0.5]);
plot(X(Chrom(1,1),1),X(Chrom(1,1),2),'rv','Markersize',20);
for i=1:size(X,1)
    text(X(i,1)+0.05,X(i,2)+0.05,num2str(i),'color',[1,0,0]);
end
A=X(R,:);
row=size(A,1);
for  i=2:row
  plot(A(i-1:i,1),A(i-1:i,2));
end
hold off
box on;
