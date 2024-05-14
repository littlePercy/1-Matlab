%% ========== 根据连通域划分图像标签 ==========
A=imread('mask.png');
figure,imshow(A),title('二值图像')
[m,n]=size(A);
B=zeros(m,n);%标记矩阵
label=1; %不同连通域标记值
q=zeros(9999,2);%模拟队列
head=1;
tail=1;
neighbour=[-1,-1;-1,0;-1,1;0,-1;0,1;1,-1;1,0;1,1];  %与某像素点相加得到该像素点的邻域像素点
for j=1:n
    for i=1:m
        if A(i,j)~=0&&B(i,j)==0
            B(i,j)=label;
            q(tail,:)=[i,j]; %用元组模拟队列，当前坐标入列
            tail=tail+1;
            while head~=tail  %该循环由连通域中一像素点得到一整个连通域
                pix=q(head,:);
                for k=1:8
                    pix1=pix+neighbour(k,:);
                    if pix1(1)>=1&&pix1(1)<=m&&pix1(2)>=1&&pix1(2)<=n
                        if A(pix1(1),pix1(2))~=0&&B(pix1(1),pix1(2))==0
                            B(pix1(1),pix1(2))=label;
                            q(tail,:)=[pix1(1) pix1(2)];
                            tail=tail+1;
                        end
                    end
                end
                head=head+1;
            end
            label=label+1;
            head=1;
            tail=1;
        end
    end
end
% imshow(mat2gray(B));
% 不同标签伪彩色显示
figure,
rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
imshow(rgb)
title('不同标签伪彩色显示')
% 测试只显示一个标签的连通域
% [row,col] = size(B);
% for i=1:row
%     for j=1:col
%         if B(i,j)==1
%             B(i,j)=255;
%         else
%             B(i,j)=0;
%         end
%     end   
% end
%% ========== 确定并显示各标签连通域的形状边界 ==========
% 图形学结构元素构建，圆形
bw = A;
% se = strel('disk',8);
% % 关操作
% bw = imclose(bw,se);
% % 填充孔洞
% bw = imfill(bw,'holes');
% % 二值化图像显示
% figure;imshow(bw);title('填充后二值图像');
[B,L] = bwboundaries(bw,'noholes');
figure,imshow(label2rgb(L,@jet,[.5 .5 .5]));
hold on;
for k = 1:length(B)
boundary = B{k};
% 显示白色边界
plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
%% ========== 根据圆度阈值分类（棒状、网状、点状）==========
hold on;
% 确定圆形目标
stats = regionprops(L,'Area','Centroid');
% 设置求面积
threshold = 0.85;
for k = 1:length(B)
    boundary = B{k};
    delta_sq = diff(boundary).^2;
    % 求周长     
    perimeter = sum(sqrt(sum(delta_sq,2)));
    % 求面积     
    area = stats(k).Area;
    metric = 4*pi*area/perimeter^2;
    metric_string = sprintf('%2.2f',metric);
    % 根据阈值匹配
    if metric > threshold  
       centroid = stats(k).Centroid;
       plot(centroid(1),centroid(2),'ko');
       text(centroid(1)-2,centroid(2)-2, '这是圆形','Color',...
        'k','FontSize',14,'FontWeight','bold');
    end
       text(boundary(1,2)-10,boundary(1,1)-12, metric_string,'Color',...
        'k','FontSize',14,'FontWeight','bold');
end
title('图像形状识别')
