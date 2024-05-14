clc; clear all
close all
img = imread('MIP_sparse/Sparse_20221213 tak1-spine 100x-3x summary.lif - 596# 100x-2 zoom3x-1.tif');
figure,subplot(231),imshow(img),title('显示原图')
img_bw = imbinarize(imread('MIP_seg/Sparse_20221213 tak1-spine 100x-3x summary.lif - 596# 100x-2 zoom3x-1.tif'));
% img_bw = imbinarize(img);
img_fill = imfill(img_bw, 'holes');                                        % 填充孔洞
mask_binary = bwareaopen(img_fill, 30);                                    % 开操作去除小面积区域
subplot(232),imshow(mask_binary),title('显示分割图像')
[B,conNum] = connectDomain(mask_binary);
rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
subplot(233),imshow(rgb),title('不同标签伪彩色显示')
selectedImg = deleteRegion(B, conNum);
subplot(234),imshow(selectedImg),title('保留最大连通域')
point_list = remainRegion(B, conNum);
%%
% SkelImg = bwmorph(selectedImg,'skel',Inf);
BW2=bwmorph(selectedImg,'thin',Inf);
subplot(235),imshow(BW2),title('显示骨架化图像');
BW3=BW2;                                                                   % ========== 去毛刺(消除噪声) ==========  
% BW3=bwmorph(BW2,'spur',5);
bifurPoints = bifurFind(BW3);
neighbors = neighborFind(bifurPoints,3);                                   % 在所有分叉点列表中找到属于同一个分叉的点的索引
bifurPoints_mean = neighborMean(neighbors,bifurPoints);                    % 用其中一个点代替一个分叉点群
subplot(236),imshow(BW3),title('显示合并分叉点');                           % ========== 可视化中心分叉点 ========== 
hold on
plot(bifurPoints_mean(:,2),bifurPoints_mean(:,1),'o','MarkerFaceColor','green');
%%
% % ========== 可视化神经元位置 ==========
% figure,imshow(img)
% hold on
% plot(point_list(:,1), point_list(:,2), 'ro', 'MarkerFaceColor', 'red');
% plot(bifurPoints_mean(:,2),bifurPoints_mean(:,1),'bo','MarkerFaceColor','cyan');
% ========== print text ==========
% for kk = 1:length(point_list(:,1))
%     plot(point_list(kk,1), point_list(kk,2), 'bo', 'MarkerFaceColor', 'red');
%     text(point_list(kk,1)+5, point_list(kk,2)+5, num2str(kk), 'Color',  ...
%         'green','FontSize',10,'FontWeight','bold');
% end
% hold on
% for kkk = 1:length(bifurPoints_mean(:,1))
%     plot(bifurPoints_mean(kkk,2),bifurPoints_mean(kkk,1), 'o', 'MarkerFaceColor', 'cyan');
%     text(bifurPoints_mean(kkk,2)+5, bifurPoints_mean(kkk,1)+5, num2str(kkk+length(point_list(:,1))), 'Color',  ...
%         'green','FontSize',10,'FontWeight','bold');
% end
%%
num_all = length(point_list(:,1)) + length(bifurPoints_mean(:,1));         % 离散神经元 + 粘连神经元
%% 可视化分叉点和端点
deleteImg = bifur_delete(BW3,bifurPoints);                                 % 去除所有分叉点，得到分段骨架
endPoints_all = endFind(deleteImg);                                        % 分段骨架图像的所有端点
[bif_Points, end_Points]= points2Find(BW3, endPoints_all);
figure,imshow(deleteImg)
hold on
plot(bif_Points(:,2), bif_Points(:,1), 'o', 'MarkerFaceColor', 'cyan');
plot(end_Points(:,2), end_Points(:,1), 'o', 'MarkerFaceColor', 'red');
plot(bifurPoints(:,2), bifurPoints(:,1), 'o', 'MarkerFaceColor', 'yellow');

%%
[B1,conNum1] = connectDomain(deleteImg);
% rgb1 = ind2rgb(gray2ind(mat2gray(B1),255),turbo(255));
% figure,imshow(rgb1)
%%
% ---------- 1. 记录神经段编号和所有点坐标 ----------
[H,W] = size(BW3);
for kk = 1:conNum1
    [r, c] = find(B1==kk);
    point_list = [r,c];
    cell_1{1, kk} = kk;
    % ----------将顺序改为两个端点之间
    new_list = [];
    for nn = 1:size(point_list,1)
        if ismember(point_list(nn,:), bif_Points, 'rows') || ismember(point_list(nn,:), end_Points, 'rows')
            start_p = point_list(nn,:);
            if start_p(1)~=H && start_p(2)~=W
                point_X = start_p(1); point_Y = start_p(2);              % 当前搜索点
                break;
            end
        end
    end
    new_list = [new_list; point_X point_Y];
    neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];
    neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
    while size(new_list,1)~=size(point_list,1)
        searchPoints = [point_X+neiBlock_row;point_Y+neiBlock_col]';
        for n=1:8
            searchPoint = searchPoints(n,:);
            if (searchPoints(n,1)>0 && searchPoints(n,1)<=H) &&...      % 注意：可能临域索引超出图像边框
                    (searchPoints(n,2)>0 && searchPoints(n,2)<=W)
                [lia, loc] = ismember(searchPoint, point_list, 'rows');
                if lia == 1 && (ismember(searchPoint, new_list, 'rows')==0)
                    point_X = point_list(loc,1); point_Y = point_list(loc,2);
                    new_list = [new_list; point_X point_Y];
                end
            end
        end
    end
    cell_1{2, kk} = new_list;
end
% ---------- 2. 记录所有分支点和端点所属神经段 ----------
bif_1 = [];
for kk = 1:length(bif_Points)
    bif_index = B1(bif_Points(kk,1), bif_Points(kk,2));
    bif_1 = [bif_1; bif_index];                                            % 分叉点
end
bif_Points_seg = [bif_Points, bif_1];
end_1 = [];
for kk = 1:length(end_Points)
    end_index = B1(end_Points(kk,1), end_Points(kk,2));
    end_1 = [end_1; end_index];                                            % 端点
end
end_Points_seg = [end_Points, end_1];
% ---------- 3. 记录分支簇对应分段编号 ----------
[H,W] = size(BW3);
neiBlock_row = [-1, -1, -1,  0, 0, 1, 1, 1];                          
neiBlock_col = [-1,  0,  1, -1, 1,-1, 0, 1];
for kkk = 1:length(neighbors)
    neighbor_lis = bifurPoints(neighbors{kkk},:);
    neighbor_lis_new = [];
    for mmm = 1:size(neighbor_lis, 1)
        pointX = neighbor_lis(mmm, 1); pointY = neighbor_lis(mmm, 2);      % 当前搜索点
        searchPoints = [pointX+neiBlock_row;pointY+neiBlock_col]';
        for n=1:8
            searchPoint = searchPoints(n,:);
            if (searchPoints(n,1)>0 && searchPoints(n,1)<H) &&... % 注意：可能临域索引超出图像边框
                    (searchPoints(n,2)>0 && searchPoints(n,2)<W)
                [lia, loc] = ismember(searchPoint, bif_Points, 'rows');
                if lia == 1
                    seg_index = bif_Points_seg(loc,3);
                    neighbor_lis_new = [neighbor_lis_new; [searchPoint, seg_index]];
                end
            end
        end
    end
    cell_2{kkk} = neighbor_lis_new;                                        % 存放分段后每个分支seg簇
end
% ---------- 4. 找出一个主方向 ----------
major_seg_lis = [];
num = 1;
while num
    branch = cell_2{num};
    if length(branch) == 3
        branch_index = num;
        num = 0;
    end
end
vectors=[];
angles=[];
for i = 1:length(branch)
    indexList = cell_1{2, branch(i, 3)};
    indexPoint = branch(i, 1:2);
    nextPoint = func_find_another_point(indexPoint, indexList, 10);
    vec_ = [nextPoint(2)-indexPoint(2),-(nextPoint(1)-indexPoint(1))];     % 图像坐标系和计算坐标系之间的转换需要注意
    vectors = [vectors;vec_];
    angle = 360-(atan2(vec_(2),vec_(1))*180/pi);
    angles = [angles;angle];
end
[~,index]=sort(angles);
sigmas=[];
for jj=1:length(index)
    if jj~=length(index)
        sigma=180*(acos(dot(vectors(index(jj),:),vectors(index(jj+1),:))...
            /(norm(vectors(index(jj),:))*norm(vectors(index(jj+1),:)))))/pi;
    else
        sigma=180*(acos(dot(vectors(index(jj),:),vectors(index(1),:))...
            /(norm(vectors(index(jj),:))*norm(vectors(index(1),:)))))/pi;
    end
    sigmas=[sigmas;sigma];
end
branch_ori = branch(:,3);  
branch_sort = branch_ori(index);
[a, b] = max(sigmas);
major_index_1 = branch_sort(b);
major_point_1 = branch(find(branch(:,3)==major_index_1),1:2);
if b == length(branch)
    major_index_2 = branch_sort(1);
else
    major_index_2 = branch_sort(b+1);
end
major_point_2 = branch(find(branch(:,3)==major_index_2),1:2);
major_seg_lis = [major_index_1 major_point_1; major_index_2 major_point_2];% 将所有主干上的seg放入

% ---------- 5. 遍历索引直到遇到端点停止 ---------
% for i in major_seg_lis
% ----- 标记簇 -----
cluster = [];
for i= 1:length(cell_2)
    clus = cell_2{i};
    clus(:,4) = i;                                                         % 第4列标记属于同一分叉簇索引，第三列标记属于哪个血管段
    cluster = [cluster; clus];
end
for ii = 1:2
segNum = ii;
segIndex = major_seg_lis(segNum,1);
m_start_point = major_seg_lis(segNum,2:3);
segWhole = cell_1{2, segIndex};
if m_start_point == segWhole(1,:)
    m_end_point = segWhole(end,:);
else
    m_end_point = segWhole(1,:);
end
% ---------- 进入循环 ----------
[lia, loc] = ismember(m_end_point, end_Points, 'rows');                    % lia == 1时终止搜索，否则在分叉点中继续搜索
% [lia, loc] = ismember(m_end_point, bif_Points, 'rows');
while ~lia
    [~, loc_] = ismember(m_end_point, cluster(:,1:2), 'rows');
    clus_index = cluster(loc_, 4);
    clusPoints = cluster(find(cluster(:,4)==clus_index),:);
    new_clusPoint = m_end_point;
    vec_others = [];
    % ----- 求主方向
    % ----- 求每个分支方向
    for j = 1:size(clusPoints,1)
        indexList = cell_1{2, clusPoints(j, 3)};
        indexPoint = clusPoints(j,1:2);
        if new_clusPoint == clusPoints(j,1:2)                                  % 求主方向向量
            nextPoint = func_find_another_point(indexPoint, indexList, 10);
            vec_major = [nextPoint(2)-indexPoint(2),-(nextPoint(1)-indexPoint(1)),j];
        else                                                                   % 求其它方向向量
            nextPoint = func_find_another_point(indexPoint, indexList, 15);
            vec_other = [nextPoint(2)-indexPoint(2),-(nextPoint(1)-indexPoint(1)),j];
            vec_others = [vec_others; vec_other];
        end
    end
    % ----- 求主方向和分支方向最接近的为下一个主方向
    sigmas_=[];
    for k = 1:size(vec_others,1)
        sigma=180*(acos(dot(vec_major(1,1:2),vec_others(k,1:2))...
            /(norm(vec_major(1,1:2))*norm(vec_others(k,1:2)))))/pi;
        sigmas_=[sigmas_;sigma];
    end
    for kk = 1:length(sigmas_)
        sigmas_(kk,2) = abs(abs(sigmas_(kk))-180);
    end
    [~, vec_index] = sortrows(sigmas_,2);
    next_major_seg = clusPoints(vec_others(vec_index(1),3),3);
    next_major_point = clusPoints(vec_others(vec_index(1),3),1:2);
    m_end_point = func_find_another_endpoint(next_major_point, next_major_seg, cell_1);
    % 附加约束 1：XXXXXXXXXX
    [lia_, ~] = ismember(m_end_point, end_Points, 'rows');                 % lia == 1时终止搜索，否则在分叉点中继续搜索
    if lia_ ==1
        % -----把vec_others中其它seg的其它another end point找出来-----
        next_other_segs = clusPoints(vec_others(vec_index(2:end),3),3);
        next_other_points = clusPoints(vec_others(vec_index(2:end),3),1:2);
        for jj = 1:length(next_other_segs)
            m_start_point = next_other_points(jj,:);
            segIndex = next_other_segs(jj);
            another_endpoint =  func_find_another_endpoint(m_start_point, segIndex, cell_1);
            if ismember(another_endpoint, bif_Points, 'rows')==1
                next_major_seg = clusPoints(vec_others(vec_index(jj+1),3),3); % 注意这里的+1 因为跳过了第一个
                next_major_point = clusPoints(vec_others(vec_index(jj+1),3),1:2); 
                m_start_point = next_major_point;
                m_end_point = func_find_another_endpoint(m_start_point, segIndex, cell_1);
                break
            end
        end
    end
    % 附加约束 2：当前两个分叉角小于一定角度时，启用第二个约束判据

    major_seg_lis = [major_seg_lis; next_major_seg next_major_point];      % 将所有主干上的seg放入
    [lia, loc] = ismember(m_end_point, end_Points, 'rows');                % lia == 1时终止搜索，否则在分叉点中继续搜索
end
end
%% 可视化
% seg_lis = [1 ,3, 5, 7, 8, 11, 13, 14];
seg_lis = major_seg_lis(:,1)';
cc=mat2cell(0+.75*rand(length(seg_lis),3),ones(1,length(seg_lis)),3 );
c=cell2mat(cc);%定义显示颜色
figure,imshow(deleteImg)
hold on
for i = 1:length(seg_lis)
    cc=mat2cell(0+.75*rand(length(seg_lis),3),ones(1,length(seg_lis)),3 );
    c=cell2mat(cc);%定义显示颜色
    plot(cell_1{2,seg_lis(i)}(:,2),cell_1{2,seg_lis(i)}(:,1),'.','color',c(i,:));
end


%%
% %% Load Data            
% centers = [];
% [r, c] = size(mask_binary);
% for i = 1:r
%     for j = 1:c
%         if mask_binary(i, j) == 1
%             centers = [centers;[i,j]];
%         end
%     end
% end
% %% Run DBSCAN Clustering Algorithm    //定义Run运行模块
% epsilon=3;                          
% MinPts=10;
% IDX=DBSCAN(centers,epsilon,MinPts);         
% %% Plot Results                       //定义绘图结果模块
% figure
% imshow(mask_binary)
% hold on
% XX = [];
% XX(:,1) = centers(:,2);
% XX(:,2) = centers(:,1);
% X_plot = XX; 
% PlotClusterinResult(X_plot, IDX);       
% title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
