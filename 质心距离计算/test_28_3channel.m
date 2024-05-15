clear all; clc
close all
imgPath_488 = 'Kv4.2-ΔCT-GFPKv4.2-ΔCT-RFP-KChIP2-full-Halo-tag\7_488_Em525_Wiener_TIRFSIM-1_Kv4.2-CT-GFPKv4.2-CT-RFP-KChIP2-full-Halo-tag_01_240104.tif';
imgPath_561 = 'Kv4.2-ΔCT-GFPKv4.2-ΔCT-RFP-KChIP2-full-Halo-tag\7_561_Em609_Wiener_TIRFSIM-1_Kv4.2-CT-GFPKv4.2-CT-RFP-KChIP2-full-Halo-tag_01_240104.tif';
imgPath_638 = 'Kv4.2-ΔCT-GFPKv4.2-ΔCT-RFP-KChIP2-full-Halo-tag\7_638_Em667_Wiener_TIRFSIM-1_Kv4.2-CT-GFPKv4.2-CT-RFP-KChIP2-full-Halo-tag_01_240104.tif';
save_ = strsplit(imgPath_488,'\');
savefolder = save_{1};
savename =  save_{2}(1:2);
img_488 = any_to_8bit(imread(imgPath_488));
img_561 = any_to_8bit(imread(imgPath_561));
img_638 = any_to_8bit(imread(imgPath_638));
seg_488 = imbinarize(img_488);
seg_561 = imbinarize(img_561);
seg_638 = imbinarize(img_638);
mask_binary_488 = bwareaopen(seg_488, 5);       
mask_binary_561 = bwareaopen(seg_561, 5);   
mask_binary_638 = bwareaopen(seg_638, 5); 
[B_488,conNum_488] = connectDomain(mask_binary_488);
[B_561,conNum_561] = connectDomain(mask_binary_561);
[B_638,conNum_638] = connectDomain(mask_binary_638);
mask_merge = mask_binary_488.*mask_binary_561.*mask_binary_638;
[B_merge, conNum_merge] = connectDomain(mask_merge);
comb=cat(3,mask_binary_561,mask_binary_488,mask_binary_638);
figure,imshow(comb*255)
hold on
dis_list = [];
for i = 1:conNum_merge % 遍历每个连通域求解
    tempImg = selecRegion(B_merge,i);
    STATS = regionprops(tempImg,'Centroid','BoundingBox');
    center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
    text(center(1),center(2), num2str(i),'Color',...
        'm','FontSize',8,'FontWeight','bold');
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
