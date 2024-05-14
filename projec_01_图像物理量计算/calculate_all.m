% 2022/7/12 yuShuai
% 功能：对全局分割图像进行相关物理指标计算
mask = imread('mask.png');
mask_binary = imbinarize(mask); %二值化mask结果
[B,conNum] = connectDomain(mask_binary);
figure
rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
imshow(rgb)
title('不同标签伪彩色显示')
% hold on
figure,imshow(mask_binary)
hold on
for i = 1:conNum % 遍历每个连通域求解
    tempImg = selecRegion(B,i);
    EUL = bweuler(tempImg); % 计算欧拉数 = 对象数-空洞数                           
    holeNums = 1-EUL;                                                      % √√ 空洞数
    STATS = regionprops(tempImg,'Centroid','MinorAxisLength','MajorAxisLength',...
        'Orientation','BoundingBox','ConvexHull','PixelList');
    center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
    area = sum(tempImg(:)==1);                                             % √√ 区域面积（除去空洞后）
    SkelImg = bwmorph(tempImg,'skel',Inf);
    [adj_cell,bifurPointsNum] = segment_extraction(SkelImg);               % √√ 分叉点数目
    L = size(adj_cell,2);
    cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
    c=cell2mat(cc);%定义显示颜色
    for ii = 1:size(adj_cell,2)
        plot(adj_cell{1,ii}(:,2),adj_cell{1,ii}(:,1),'.','color',c(ii,:));
    end
%     plot(center(1),center(2),'go','MarkerFaceColor','red');
%     text(center(1)+5,center(2)+5, num2str(holeNums),'Color',...
%         'white','FontSize',14,'FontWeight','bold');
end
% savename = 'D:\Matlab-code\Project\mitoDatasets\dataSave\test.png';
% savefigure2img(savename)
% % 可视化   
% figure,
% rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
% imshow(rgb)
% title('不同标签伪彩色显示')
