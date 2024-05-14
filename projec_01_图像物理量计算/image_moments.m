
%% 图像各阶矩的求解即长短轴方向可视化
% ref- https://zhuanlan.zhihu.com/p/424903693
bin_img = imread('temp1.png');
% [m00,m01,m10,m11,m20,m02,m21,m12] = deal(0);
% [height, width] = size(bin_img);
% for y = 1:height
%     for x = 1:width
%         m00 = m00 + bin_img(y, x);
%         m10 = m10 + x * bin_img(y, x);
%         m01 = m01 + y * bin_img(y, x);
%         m11 = m11 + x * y * bin_img(y, x);
%         m20 = m20 + x * x * bin_img(y, x);
%         m02 = m02 + y * y * bin_img(y, x);
%         m21 = m21 + x * x * y * bin_img(y, x);
%         m12 = m12 + x * y * y * bin_img(y, x);
%     end
% end
% % 质心位置(cx,cy) 
% % 与stats = regionprops(bin_img,'Centroid','Orientation','MajorAxisLength','MinorAxisLength');算出值相同；
% cx = m10/m00;
% cy = m01/m00;
% figure,imshow(bin_img)
% hold on
% plot(cx,cy,'ro','MarkerFaceColor','r');
% % 计算长轴角度 正负问题
% mu00 = m00;
% mu11 = m11 - cx*m01;
% mu20 = m20 - cx*m10;
% mu02 = m02 - cy*m01;
% theta = 1/2*atan(2*mu11/(mu20 - mu02));
%%
STATS=regionprops(bin_img,'MinorAxisLength','MajorAxisLength','Area','Centroid','BoundingBox','ConvexHull');
figure,imshow(bin_img);
hold on
plot(STATS.Centroid(1),STATS.Centroid(2),'ko-','MarkerFaceColor','r')
plot(STATS.ConvexHull(:,1),STATS.ConvexHull(:,2),'m','LineWidth',2)
rectangle('Position',STATS.BoundingBox,'EdgeColor','g')
rectangle('Position',[STATS.Centroid(1)-1.5*(STATS.MajorAxisLength/2),STATS.Centroid(2)- ...
    1.5*(STATS.MajorAxisLength/2),1.5*STATS.MajorAxisLength,1.5*STATS.MajorAxisLength],'Curvature',[1,1],'EdgeColor','c','LineWidth',2)
%text(STATS.Centroid(1)+1*(STATS.MajorAxisLength/2),STATS.Centroid(2),'1.5R','FontSize',10,'Color','c','FontWeight', 'bold')
rectangle('Position',[STATS.Centroid(1)-2*(STATS.MajorAxisLength/2),STATS.Centroid(2)- ...
    2*(STATS.MajorAxisLength/2),2*STATS.MajorAxisLength,2*STATS.MajorAxisLength],'Curvature',[1,1],'EdgeColor','g','LineWidth',2)
%text(STATS.Centroid(1)+2*(STATS.MajorAxisLength/2),STATS.Centroid(2),'2R','FontSize',16,'Color','g','FontWeight', 'bold')
rectangle('Position',[STATS.Centroid(1)-2.5*(STATS.MajorAxisLength/2),STATS.Centroid(2)- ...
    2.5*(STATS.MajorAxisLength/2),2.5*STATS.MajorAxisLength,2.5*STATS.MajorAxisLength],'Curvature',[1,1],'EdgeColor','y','LineWidth',2)
%text(STATS.Centroid(1)+3*(STATS.MajorAxisLength/2),STATS.Centroid(2),'3R','FontSize',18,'Color','y','FontWeight', 'bold')
rectangle('Position',[STATS.Centroid(1)-3*(STATS.MajorAxisLength/2),STATS.Centroid(2)- ...
    3*(STATS.MajorAxisLength/2),3*STATS.MajorAxisLength,3*STATS.MajorAxisLength],'Curvature',[1,1],'EdgeColor','w','LineWidth',2)
plot(STATS.Centroid(1),STATS.Centroid(2),'ko-','MarkerFaceColor','r')
plot(STATS.ConvexHull(:,1),STATS.ConvexHull(:,2),'m','LineWidth',2)


