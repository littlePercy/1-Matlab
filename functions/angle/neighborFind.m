function neighbors = neighborFind(bifurPoints,radius)
% 2022/7/12 yuShuai
% 输入所有分叉点候选点bifurPoints
% 输入搜索半径radius
% 输出同一个radius范围内的点群集neighbors
%% ==========最近邻搜索求每个分叉点群的平均==========
% MD2 = createns(bifurPoints(:,1:2),'NSMethod','kdtree','Distance','euclidean'); % 最近邻搜索器对象
% seen = [];
% neighbors = [];
% seen_num = 1;
% for i =1:size(MD2.X,1)
%     point = bifurPoints(i,1:2); % 某个分叉点
%     check_point=rangesearch(MD2,point,radius); % 查找某个端点周围指定距离内的所有邻居(为point点找到距离RADIUS范围内的x中的所有点)
%     if ~ismember(sum(check_point{1}),seen)
%         neighbors{seen_num} = check_point{1};
%         seen = [seen;sum(check_point{1})];
%         seen_num = seen_num+1;
%     end
% end


MD2 = createns(bifurPoints(:,1:2),'NSMethod','kdtree','Distance','euclidean'); % 最近邻搜索器对象
seen = [];
seen_ = [];
neighbors = [];
seen_num = 1;
for i =1:size(MD2.X,1)
    point = bifurPoints(i,1:2); % 某个分叉点
    check_point=rangesearch(MD2,point,radius); % 查找某个端点周围指定距离内的所有邻居(为point点找到距离RADIUS范围内的x中的所有点)
    if ~ismember(sum(check_point{1}),seen)
        neighbors{seen_num} = check_point{1};
        seen = [seen;sum(check_point{1})];
        seen_num = seen_num+1;
    end
    if ismember(sum(check_point{1}),seen)
        index_lis = find(seen==sum(check_point{1}));
        for j = 1:length(index_lis)
            aa = sort(neighbors{index_lis(j)}); % 可能有多个seen，但先不考虑
            bb = sort(check_point{1});
            if ~isequal(aa,bb)
                neighbors{seen_num} = check_point{1};
                seen = [seen;sum(check_point{1})];
                seen_num = seen_num+1;
            end
        end
    end
end
