close all
clear all 
clc
img_488 = imread('4-488-test.tif');
img_488_seg = imbinarize(img_488,0.1);
% figure,imshow(img_seg)
mask_488_binary = bwareaopen(img_488_seg, 10);   
% figure,imshow(mask_binary)
% imwrite(uint8(mask_binary*255),'4-488-test-seg.tif')
img_561 = imread('4-561-test.tif');
img_561_seg = imbinarize(img_561,0.06);
% figure,imshow(img_561_seg)
mask_561_binary = bwareaopen(img_561_seg, 15);   
% figure,imshow(mask_561_binary)
% imwrite(uint8(mask_561_binary*255),'4-561-test-seg.tif')
%% 叠加显示 红色线粒体 绿色过氧化物酶体
% figure,imshow(mask_binary)
% hold on
% for i = 1:conNum
%     [row, col] = find(B==i);
%     cc=mat2cell(0+.75*rand(conNum,3),ones(1,conNum),3 );
%     c=cell2mat(cc);%定义显示颜色
%     plot(col,row,'.','color',c(i,:));
% end
img3=zeros(size(mask_488_binary,1),size(mask_488_binary,2));
comb=cat(3,mask_561_binary,mask_488_binary,img3);
figure,imshow(comb*255)
hold on
%% 找出重叠部分 作为独立连通域计数
[B,conNum] = connectDomain(mask_488_binary);
[r, c] = find(mask_488_binary==1);
all_lis = [r c];
overlap_lis = [];
% overlap_map = zeros(size(mask_488_binary,1),size(mask_488_binary,2));
for i = 1:length(r)
    if mask_561_binary(r(i), c(i)) == 1
        overlap_lis = [overlap_lis; r(i), c(i)];
%         overlap_map(r(i), c(i))=1;
%         plot(c(i),r(i),'o','MarkerFaceColor','blue');
    end
end
% overlap_map = imbinarize(overlap_map);
% [B_1,conNum_1] = connectDomain(overlap_map);
% figure,imshow(overlap_map)
% hold on
% for i = 1:conNum_1
%     [row, col] = find(B_1==i);
%     plot(col,row,'.','color',[1 1 0]);
% end
%% 找出边缘相接部分
[lia, loc] = ismember(overlap_lis, all_lis, 'rows');
all_lis_copy = all_lis;
all_lis_copy(loc,:) = [];
edges_lis = func_edges_meet(all_lis_copy, mask_561_binary);
for i = 1:size(edges_lis, 1)
    plot(edges_lis(i, 2), edges_lis(i, 1),'o','MarkerFaceColor','blue');
end
%% 按连通域遍历每个蛋白
%  -----将含有overlap_lis和edges_lis的蛋白都标记为发生互作的蛋白
num_lis = [];
over_lis = [];
edge_lis = [];
num = 0;
for i = 1:conNum
    tempImg = selecRegion(B,i);
    STATS = regionprops(tempImg,'Centroid');
    center = STATS.Centroid;
    [rr, cc] = find(B==i);
    C_over = intersect([rr, cc], overlap_lis, 'rows');
    C_edge = intersect([rr, cc], edges_lis, 'rows');
    if size(C_over,1)>0 || size(C_edge,1)>0
        num = num+1;
%         plot(center(1),center(2),'ro','MarkerFaceColor','red');
        text(center(1),center(2), num2str(num),'Color',...
            'white','FontSize',14,'FontWeight','bold');
        num_lis = [num_lis; i];
        if size(C_over,1)>0
            over_lis = [over_lis; size(C_over,1)];
        else
            over_lis = [over_lis; 0];
        end
        if size(C_edge,1)>0
            edge_lis = [edge_lis;size(C_edge,1)];
        else
            edge_lis = [edge_lis; 0];
        end
    end
end
saveas(gcf,'test.png');
