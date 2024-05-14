function [adj_cell,bifurPointsNum,bifurPoints_mean,endPoints,deleteImg] =segment_extraction(SkelImg)
% 功能：
% 输入：
% 输出：
I = SkelImg;
bifurPoints = bifurFind(I);
%% ==========最近邻搜索求每个分叉点群的平均==========
neighbors = neighborFind(bifurPoints,5);%在所有分叉点列表中找到属于同一个分叉的点的索引
bifurPoints_mean = neighborMean(neighbors,bifurPoints);%用其中一个点代替一个分叉点群
bifurPointsNum = size(bifurPoints_mean,1);                                 % √ 分叉点个数
deleteImg = bifur_delete(I,bifurPoints);
endPoints = endFind(deleteImg);
% 可视化分叉点和端点
% figure,imshow(I)
% hold on
% plot(bifurPoints_mean(:,2),bifurPoints_mean(:,1),'o','MarkerFaceColor','cyan');
% plot(endPoints(:,2),endPoints(:,1),'.','color','red');
%% 
segNum = 0;%记录中心线段数目 没约束没有中心线的情况
seen = [0,0];%用于存储所有已经被索引过的像素点
adj_cell={};%用于存储所有分支
for i=1:size(endPoints,1) %从每个端点开始索引
    pointNow = endPoints(i,:);
    if ~ismember(pointNow,seen,'rows')
        pointSave = [];
        pointSave = [pointSave;pointNow];
        seen = [seen;pointNow];
        while 1
            [adj_,~] = adj_search(pointNow,deleteImg);%返回当前点的邻接像素数目和坐标矩阵
            if isempty(adj_)    %孤立点情况
                segNum = segNum+1;
                adj_cell{1,segNum}=pointSave;
                adj_cell{2,segNum}=segNum;
                break
            end
            C = setdiff(adj_,seen,'rows'); %这里有问题！！！！！！没考虑到更复杂的情况 这里假设C解出来只有一个点 理想化了
            pointSave = [pointSave;C];
            seen = [seen;C];
            pointNow = C;
            % 终止条件：遇到端点或者分叉点
            if ismember(pointNow,endPoints,'rows')
                segNum = segNum+1;
                adj_cell{1,segNum}=pointSave;
                adj_cell{2,segNum}=segNum;
                break
            end
        end
    end
end
%% -------------定义显示-------------
% figure,imshow(I)
% title('中心线分段显示')
% hold on
% L = size(adj_cell,2);
% cc=mat2cell(0+.75*rand(L,3),ones(1,L),3 );
% c=cell2mat(cc);%定义显示颜色
% for ii = 1:size(adj_cell,2)
%     plot(adj_cell{1,ii}(:,2),adj_cell{1,ii}(:,1),'.','color',c(ii,:));
% end    
