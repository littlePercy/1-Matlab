function [connectedImg,conNum] = connectDomain(Input_mask)
% ===============================================
% 2022/7/14 yuShuai                                    
% 功能根据连通域划分mask为独立的连通域区域          
% 输入二值化mask图像 or灰度图也可以其实
% 输出连通域划分结果图像connectedImg，像素值相同的区域为同一个连通域
% ===============================================
A = Input_mask;
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
connectedImg = B;
conNum = label-1;
% %% 可视化操作
% figure,
% rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
% imshow(rgb)
% title('不同标签伪彩色显示')
