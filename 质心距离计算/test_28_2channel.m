clear all; clc
close all
imgPath_488 = 'Kv4.2-ΔCT-GFP-Kv4.2-ΔCT-RFP\5_488_Em525_Wiener_TIRFSIM-1_Kv4.2-CT-GFP-Kv4.2-CT-RFP_01_240104.tif';
imgPath_561 = 'Kv4.2-ΔCT-GFP-Kv4.2-ΔCT-RFP\5_561_Em609_Wiener_TIRFSIM-1_Kv4.2-CT-GFP-Kv4.2-CT-RFP_01_240104.tif';
save_ = strsplit(imgPath_488,'\');
savefolder = save_{1};
savename =  save_{2}(1:2);
img_488 = any_to_8bit(imread(imgPath_488));
img_561 = any_to_8bit(imread(imgPath_561));
seg_488 = imbinarize(img_488);
seg_561 = imbinarize(img_561);
% figure,imshow(seg_488)
% figure,imshow(seg_561)
mask_binary_488 = bwareaopen(seg_488, 5);       
mask_binary_561 = bwareaopen(seg_561, 5);   
% figure,imshow(mask_binary_488)
% figure,imshow(mask_binary_561)
[B_488,conNum_488] = connectDomain(mask_binary_488);
% figure,imshow(mask_binary_488)
% hold on
% for i = 1:conNum_488
%     [row, col] = find(B_488==i);
%     cc=mat2cell(0+.75*rand(conNum_488,3),ones(1,conNum_488),3 );
%     c=cell2mat(cc);%定义显示颜色
%     plot(col,row,'.','color',c(i,:));
% end
[B_561,conNum_561] = connectDomain(mask_binary_561);
mask_merge = mask_binary_488.*mask_binary_561;
% figure,imshow(mask_merge)
[B_merge, conNum_merge] = connectDomain(mask_merge);
img3=zeros(size(mask_binary_488,1),size(mask_binary_488,2));
comb=cat(3,mask_binary_561,mask_binary_488,img3);
figure,imshow(comb*255)
hold on
dis_list = [];
for i = 1:conNum_merge % 遍历每个连通域求解
    tempImg = selecRegion(B_merge,i);
    STATS = regionprops(tempImg,'Centroid','BoundingBox');
    center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
    text(center(1),center(2), num2str(i),'Color',...
        'm','FontSize',8,'FontWeight','bold');
%     plot(center(1),center(2),'o','MarkerFaceColor','m','MarkerSize',2);
%     rectangle('Position',STATS.BoundingBox,'EdgeColor','m',...     
%         'LineWidth',1)
    % 任取一个merge像素位置
    [r, c] = find(tempImg~=0);
    r1 = r(1);
    c1 = c(1);
    % 找到488通道对应ID 以及区域质心
    ID_488 = B_488(r1, c1);
    tempImg_488 = selecRegion(B_488,ID_488);
    STATS_488 = regionprops(tempImg_488,'Centroid');
    center_488 = STATS_488.Centroid;  
    % 找到561通道对应ID 以及区域质心
    ID_561 = B_561(r1, c1);
    tempImg_561 = selecRegion(B_561,ID_561);
    STATS_561 = regionprops(tempImg_561,'Centroid');
    center_561 = STATS_561.Centroid;  
    % 计算质心距离
    dis = distance(center_488, center_561);
    dis_list = [dis_list; dis];
end
%% TXT统计
saveName = [savefolder, '\', savename];
fid = fopen([saveName,'.txt'],'w');
fprintf(fid,'%s \t %s\n','编号', '距离');
for j = 1:length(dis_list)
    ID = num2str(j);
    dis_ = dis_list(j);
    fprintf(fid,'%s \t %.4f\n', ID, dis_);
end
fclose(fid);
%% 保存标记图窗
savefig(gcf, [savefolder, '\', savename, '.fig']);
