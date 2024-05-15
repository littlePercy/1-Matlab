close all
clear all 
clc
file_path = '4';
file_488 = [file_path,'\','peroxisome'];
dir_file_488 = dir(file_488);
file_561 = [file_path,'\','mito'];
dir_file_561 = dir(file_561);
save_folder_fig = [file_path, '\', 'result_fig'];
save_folder_txt = [file_path, '\', 'result_txt'];
if exist(save_folder_fig)==0   %判断文件夹是否存在
    mkdir(save_folder_fig);    %不存在时候，创建文件夹
end
if exist(save_folder_txt)==0
    mkdir(save_folder_txt);   
end
for n = 3:length(dir_file_488)
    close all
    img_name = dir_file_488(n).name;
    mask_488_binary = imbinarize(imread([file_488, '\', img_name]));   
    mask_561_binary = imbinarize(imread([file_561, '\', img_name]));  
    %% 叠加显示 红色线粒体 绿色过氧化物酶体
    img3=zeros(size(mask_488_binary,1),size(mask_488_binary,2));
    comb=cat(3,mask_561_binary,mask_488_binary,img3);
    figure,imshow(comb*255)
    hold on
    %% 找出重叠部分 作为独立连通域计数
    [B,conNum] = connectDomain(mask_488_binary);
    [r, c] = find(mask_488_binary==1);
    all_lis = [r c];
    overlap_lis = [];
    for i = 1:length(r)
        if mask_561_binary(r(i), c(i)) == 1
            overlap_lis = [overlap_lis; r(i), c(i)];
        end
    end
    %% 找出边缘相接部分
    [lia, loc] = ismember(overlap_lis, all_lis, 'rows');
    all_lis_copy = all_lis;
    all_lis_copy(loc,:) = [];
    edges_lis = func_edges_meet(all_lis_copy, mask_561_binary);
    plot(edges_lis(:, 2), edges_lis(:, 1),'o','MarkerFaceColor','blue');
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
    %% TXT统计
    saveName = [save_folder_txt, '\', img_name(1:end-4)];
    fid = fopen([saveName,'.txt'],'w');
    fprintf(fid,'%s \t %s \t %s\n','编号', '重叠', '相接');
    for j = 1:length(num_lis)
        ID = num2str(j);
        over_num = over_lis(j);
        edge_num = edge_lis(j);
        fprintf(fid,'%s \t %d \t %d\n',ID,over_num,edge_num);
    end
    fclose(fid);
    savefig(gcf, [save_folder_fig, '\', img_name(1:end-4), '.fig']);
end
