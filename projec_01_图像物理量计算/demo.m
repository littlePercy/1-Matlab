% img = imread('Wiener637-COS-7_1.7_pk mito deep red-TOM20-GFP_SIM01_IMAGER_20210408_6.png');
% gray = mat2gray(img);
% imwrite(gray,'original.bmp')
% grayImg = imread("original.bmp");
% mask = imread("mask.png");
% mask_binary = imbinarize(mask);
% %先闭运算 再开运算
% se=strel('disk',5);
% BWimg = imclose(mask,se);
% BWimg = imopen(BWimg,se);
% 分别单独保存一个标签的连通
% ========================================
% [row,col] = size(B);
% temp1 = zeros(row,col);
% for i=1:row
%     for j=1:col
%         if B(i,j)==23
%             temp1(i,j)=255;
%         else
%             temp1(i,j)=0;
%         end
%     end   
% end
% temp1 = imbinarize(temp1);
% imwrite(temp1,'temp1.png')
EUL = bweuler(img); % 计算欧拉数 = 对象数-空洞数
holeNums = 0-EUL;
stats = regionprops(img,'Area','Centroid','EulerNumber');
% test
I = imread('temp1_skl.png');
adj_cell=segment_extraction(I);
%% -------------定义显示-------------
figure,imshow(I)
title('中心线分段显示')
hold on
L = size(adj_cell,2);
cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
c=cell2mat(cc);%定义显示颜色
for ii = 1:size(adj_cell,2)
    plot(adj_cell{1,ii}(:,2),adj_cell{1,ii}(:,1),'.','color',c(ii,:));
end
