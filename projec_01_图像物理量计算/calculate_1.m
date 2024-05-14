%% ==========以temp1.png单个连通域为例==========
img=imread('temp1.png');
EUL = bweuler(img); % 计算欧拉数 = 对象数-空洞数
holeNums = 1-EUL;                                                          % √ 得到单个对象空洞数
pixelNums = sum(img(:)==1);                                                % √ 区域面积（除去空洞后）
STATS = regionprops(img,'Centroid','MinorAxisLength','MajorAxisLength',...
    'Orientation','BoundingBox','ConvexHull','PixelList');
center = STATS.Centroid;                                                   % √ 区域质心坐标（图像坐标系）
% 图形学结构元素构建，圆形
bw = img;
B = bwboundaries(bw,'noholes');
boundary = B{1};
% 显示单个边界
figure,imshow(img);
hold on
rectangle('Position',STATS.BoundingBox,'EdgeColor','g')
plot(STATS.ConvexHull(:,1),STATS.ConvexHull(:,2),'m','LineWidth',2)
plot(boundary(:,2),boundary(:,1),'r','LineWidth',3)
plot(center(1),center(2),'ro','MarkerFaceColor','cyan');
% 求周长，利用一阶差分，即相邻像素距离累加
delta_sq = diff(boundary).^2;
perimeter = sum(sqrt(sum(delta_sq,2)));                                    % √ 区域周长
% 空洞填充 这里针对holeNums>1的情况
se = strel('disk',8);
% 关操作
bw_ = imclose(bw,se);
% 填充孔洞
bw_ = imfill(bw_,'holes');
% 二值化图像显示
figure;imshow(bw_);title('填充后二值图像');
pixelNums_ = sum(bw_(:)==1); 
roundness = 4*pi*pixelNums_/perimeter^2;                                   % √ 区域圆度
SkelImg = bwmorph(bw,'skel',Inf);
% figure,imshow(imadd(0.5*double(bw),double(SkelImg)))
[adj_cell,bifurPointsNum] = segment_extraction(SkelImg);                   % √√ 分叉点数目
L = size(adj_cell,2);
cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
c=cell2mat(cc);%定义显示颜色
for ii = 1:size(adj_cell,2)
    plot(adj_cell{1,ii}(:,2),adj_cell{1,ii}(:,1),'.','color',c(ii,:));
end
%% ==========求分叉角度==========
img=imread('temp1.png');
bw = img;
SkelImg = bwmorph(bw,'skel',Inf);
[adj_cell,bifurPointsNum,bifurPoints_mean,endPoints,deleteImg] = segment_extraction(SkelImg); 
add_num = 0;
for ii = 1:size(adj_cell,2)
    if length(adj_cell{1,ii})>=5
        adj_cell_delete{1,add_num+1} = adj_cell{1,ii};
        adj_cell_delete{2,add_num+1} = adj_cell{2,ii};
        add_num = add_num+1;
    end
end
endPoints_ = segIndex(endPoints,adj_cell_delete);% 排除小于5个像素点的分支
% 遍历每个分叉点，求分叉角
b = endPoints_(all(~isnan(endPoints_),2),:);%删除含有NAN的行
[endNeighbors,final_neighbors] = endNeighbor(bifurPoints_mean,b,5);
final_neighbors_ = angleVector(final_neighbors,adj_cell);
%% ==========可视化一个效果=========
% 可视化分叉点和端点
figure,imshow(SkelImg)
hold on
plot(bifurPoints_mean(:,2),bifurPoints_mean(:,1),'o','MarkerFaceColor','cyan');
plot(endPoints(:,2),endPoints(:,1),'o','MarkerFaceColor','red');
