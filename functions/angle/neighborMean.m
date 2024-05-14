function neighbors_mean = neighborMean(neighbors,bifurPoints)
% 2022/7/12 yuShuai
% 输入所有分叉点候选点bifurPoints以及属于一个分叉的点的索引集合neighbors
% 根据与平均距离最小原则，每个分叉点群只输出一个最终的分叉点neighbors_mean
neighbors_mean = [];
for i=1:length(neighbors)
    final_neighbors = bifurPoints(neighbors{i},:);
    point_mean = mean(final_neighbors,1);
    k = dsearchn(final_neighbors,point_mean); %返回分叉点平均位置坐标离 原始分叉点群最近的一个作为最终的分叉点输出
    final_neighbor = final_neighbors(k,:);
    neighbors_mean = [neighbors_mean;final_neighbor];
end


% MD2 = createns(bifurPoints(:,1:2),'NSMethod','kdtree','Distance','euclidean'); % 最近邻搜索器对象
% seen = [];
% seen_ = [];
% neighbors = [];
% seen_num = 1;
% for i =1:size(MD2.X,1)
%     point = bifurPoints(i,1:2); % 某个分叉点
%     check_point=rangesearch(MD2,point,5); % 查找某个端点周围指定距离内的所有邻居(为point点找到距离RADIUS范围内的x中的所有点)
%     if ~ismember(sum(check_point{1}),seen)
%         neighbors{seen_num} = check_point{1};
%         seen = [seen;sum(check_point{1})];
%         seen_num = seen_num+1;
%     end
%     if ismember(sum(check_point{1}),seen)
%         index_lis = find(seen==sum(check_point{1}));
%         for j = 1:length(index_lis)
%             aa = sort(neighbors{index_lis(j)}); % 可能有多个seen，但先不考虑
%             bb = sort(check_point{1});
%             if ~isequal(aa,bb)
%                 neighbors{seen_num} = check_point{1};
%                 seen = [seen;sum(check_point{1})];
%                 seen_num = seen_num+1;
%             end
%         end
%     end
% end

    
    
