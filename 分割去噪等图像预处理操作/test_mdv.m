%% ========================================================================
% close all
clear all
clc
imgPath = '11\img';
segPath = '11\mask';
img_dir = dir(imgPath);
seg_dir = dir(segPath);
for n = 3:length(img_dir)
    segPath_ = [segPath,'\',seg_dir(n).name];
    imgPath_ = [imgPath,'\',img_dir(n).name];
    imgSeg = imread(segPath_);
    mask_binary = imbinarize(imgSeg);
    [B,conNum] = connectDomain(mask_binary);
    %% ========================================================================
    imgMerge = imread(imgPath_);
    figure,imshow(imgMerge)
    hold on
    area_point_lis = [];
    area_rod_lis = [];
    length_point_lis = [];
    length_rod_lis = [];
    %% TXT统计
    saveName = img_dir(n).name(1:end-4);
    fid = fopen([saveName,'.txt'],'w');
    fprintf(fid,'%s \t %s\n','编号', '长度');
    for i = 1:conNum % 遍历每个连通域求解
        tempImg = selecRegion(B,i);
        STATS = regionprops(tempImg,'Centroid','MinorAxisLength','MajorAxisLength',...
            'Orientation','BoundingBox','ConvexHull','PixelList');
        center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
        text(center(1),center(2), num2str(i),'Color',...
            'white','FontSize',10,'FontWeight','bold');
        ratio = STATS.MinorAxisLength/STATS.MajorAxisLength;
        ID = num2str(i);
        if ratio > 0.7
            rectangle('Position',STATS.BoundingBox,'EdgeColor','cyan',...  % 点状结构
                'LineWidth',2)

            diameters = mean([STATS.MajorAxisLength STATS.MinorAxisLength],2);
            length_point_lis = [length_point_lis; diameters];
            fprintf(fid,'%s \t %.4f\n', ID, diameters*0.0325);

        else
            rectangle('Position',STATS.BoundingBox,'EdgeColor','m',...     % 棒状结构
                'LineWidth',2)
            length_rod_lis = [length_rod_lis; STATS.MajorAxisLength];
            fprintf(fid,'%s \t %.4f\n', ID, STATS.MajorAxisLength*0.0325);
        end
    end
    mean_point_length = sum(length_point_lis)/length(length_point_lis);
    mean_rod_length = sum(length_rod_lis)/length(length_rod_lis);
    point_mean = mean_point_length*0.0325;
    rod_mean = mean_rod_length*0.0325;
    fprintf(fid,'%s \t %.4f\n', '点状平均长度:', point_mean);
    fprintf(fid,'%s \t %.4f\n', '棒状平均长度:', rod_mean);
    %% 保存标记图窗
    savefig(gcf, [saveName,'.fig']);
    fclose(fid);
end
